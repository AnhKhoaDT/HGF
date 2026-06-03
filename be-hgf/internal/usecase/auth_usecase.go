package usecase

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"hidden-gems-finder/internal/domain/entities"
	"hidden-gems-finder/internal/domain/repositories"
	"hidden-gems-finder/pkg/firebase"
	"hidden-gems-finder/pkg/jwt"
)

// AuthUseCase handles authentication business logic
type AuthUseCase struct {
	userRepo         repositories.UserRepository
	refreshTokenRepo repositories.RefreshTokenRepository
	firebaseAuth     *firebase.AuthClient
	jwtManager       *jwt.JWTManager
}

// NewAuthUseCase creates a new auth use case
func NewAuthUseCase(
	userRepo repositories.UserRepository,
	refreshTokenRepo repositories.RefreshTokenRepository,
	firebaseAuth *firebase.AuthClient,
	jwtManager *jwt.JWTManager,
) *AuthUseCase {
	return &AuthUseCase{
		userRepo:         userRepo,
		refreshTokenRepo: refreshTokenRepo,
		firebaseAuth:     firebaseAuth,
		jwtManager:       jwtManager,
	}
}

// LoginRequest represents login request data
type LoginRequest struct {
	FirebaseIDToken string `json:"firebase_id_token" binding:"required"`
}

// RegisterRequest represents registration request data
type RegisterRequest struct {
	FirebaseIDToken string `json:"firebase_id_token" binding:"required"`
	Username        string `json:"username" binding:"required,min=3,max=50"`
}

// AuthResponse represents authentication response
type AuthResponse struct {
	AccessToken  string        `json:"access_token"`
	RefreshToken string        `json:"refresh_token"`
	TokenType    string        `json:"token_type"`
	ExpiresIn    int64         `json:"expires_in"`
	User         *UserResponse `json:"user"`
}

// UserResponse represents user data in responses
type UserResponse struct {
	ID          uuid.UUID  `json:"id"`
	Username    string     `json:"username"`
	Email       string     `json:"email"`
	AvatarURL   *string    `json:"avatar_url"`
	ExpPoints   int        `json:"exp_points"`
	Level       int        `json:"level"`
	LevelTitle  string     `json:"level_title"`
	LastLoginAt *time.Time `json:"last_login_at"`
	CreatedAt   time.Time  `json:"created_at"`
}

// Login authenticates user with Firebase ID token
func (uc *AuthUseCase) Login(ctx context.Context, req *LoginRequest) (*AuthResponse, error) {
	// 1. Verify Firebase ID Token
	token, err := uc.firebaseAuth.VerifyIDToken(ctx, req.FirebaseIDToken)
	if err != nil {
		return nil, errors.New("invalid firebase token")
	}

	// 2. Get user from database by Firebase UID
	user, err := uc.userRepo.GetByFirebaseUID(ctx, token.UID)
	if err != nil {
		return nil, errors.New("user not found, please register first")
	}

	// 3. Update last login time
	if err := uc.userRepo.UpdateLastLogin(ctx, user.ID); err != nil {
		// Log error but continue
	}

	// 4. Generate JWT tokens
	accessToken, err := uc.jwtManager.GenerateAccessToken(user.ID, user.Email, user.Username, user.FirebaseUID)
	if err != nil {
		return nil, errors.New("failed to generate access token")
	}

	refreshTokenStr, expiresAt, err := uc.jwtManager.GenerateRefreshToken(user.ID)
	if err != nil {
		return nil, errors.New("failed to generate refresh token")
	}

	// 5. Store refresh token in database
	refreshToken := &entities.RefreshToken{
		UserID:    user.ID,
		Token:     refreshTokenStr,
		ExpiresAt: expiresAt,
		IsRevoked: false,
	}
	if err := uc.refreshTokenRepo.Create(ctx, refreshToken); err != nil {
		return nil, errors.New("failed to store refresh token")
	}

	return &AuthResponse{
		AccessToken:  accessToken,
		RefreshToken: refreshTokenStr,
		TokenType:    "Bearer",
		ExpiresIn:    900, // 15 minutes
		User:         uc.toUserResponse(user),
	}, nil
}

// Register creates a new user account
func (uc *AuthUseCase) Register(ctx context.Context, req *RegisterRequest) (*AuthResponse, error) {
	// 1. Verify Firebase ID Token
	token, err := uc.firebaseAuth.VerifyIDToken(ctx, req.FirebaseIDToken)
	if err != nil {
		return nil, errors.New("invalid firebase token")
	}

	// 2. Check if user already exists
	exists, err := uc.userRepo.ExistsByFirebaseUID(ctx, token.UID)
	if err != nil {
		return nil, errors.New("failed to check user existence")
	}
	if exists {
		return nil, errors.New("user already registered")
	}

	// 3. Check if username is taken
	exists, err = uc.userRepo.ExistsByUsername(ctx, req.Username)
	if err != nil {
		return nil, errors.New("failed to check username availability")
	}
	if exists {
		return nil, errors.New("username already taken")
	}

	// 4. Get Firebase user data
	firebaseUser, err := uc.firebaseAuth.GetUser(ctx, token.UID)
	if err != nil {
		return nil, errors.New("failed to get firebase user data")
	}

	// 5. Create new user
	now := time.Now()
	user := &entities.User{
		Username:    req.Username,
		Email:       firebaseUser.Email,
		FirebaseUID: token.UID,
		AvatarURL:   &firebaseUser.PhotoURL,
		ExpPoints:   0,
		Level:       1,
		LevelTitle:  "Nhà Thám Hiểm",
		IsActive:    true,
		LastLoginAt: &now,
	}

	if err := uc.userRepo.Create(ctx, user); err != nil {
		return nil, errors.New("failed to create user")
	}

	// 6. Generate JWT tokens
	accessToken, err := uc.jwtManager.GenerateAccessToken(user.ID, user.Email, user.Username, user.FirebaseUID)
	if err != nil {
		return nil, errors.New("failed to generate access token")
	}

	refreshTokenStr, expiresAt, err := uc.jwtManager.GenerateRefreshToken(user.ID)
	if err != nil {
		return nil, errors.New("failed to generate refresh token")
	}

	// 7. Store refresh token in database
	refreshToken := &entities.RefreshToken{
		UserID:    user.ID,
		Token:     refreshTokenStr,
		ExpiresAt: expiresAt,
		IsRevoked: false,
	}
	if err := uc.refreshTokenRepo.Create(ctx, refreshToken); err != nil {
		return nil, errors.New("failed to store refresh token")
	}

	return &AuthResponse{
		AccessToken:  accessToken,
		RefreshToken: refreshTokenStr,
		TokenType:    "Bearer",
		ExpiresIn:    900, // 15 minutes
		User:         uc.toUserResponse(user),
	}, nil
}

// RefreshToken generates new access token using refresh token
func (uc *AuthUseCase) RefreshToken(ctx context.Context, refreshTokenStr string) (*AuthResponse, error) {
	// 1. Verify refresh token format
	userID, err := uc.jwtManager.VerifyRefreshToken(refreshTokenStr)
	if err != nil {
		return nil, errors.New("invalid refresh token")
	}

	// 2. Check if refresh token exists in database and is valid
	refreshToken, err := uc.refreshTokenRepo.GetByToken(ctx, refreshTokenStr)
	if err != nil {
		return nil, errors.New("refresh token not found")
	}

	if !refreshToken.IsValid() {
		return nil, errors.New("refresh token expired or revoked")
	}

	// 3. Get user
	user, err := uc.userRepo.GetByID(ctx, userID)
	if err != nil {
		return nil, errors.New("user not found")
	}

	// 4. Generate new access token
	accessToken, err := uc.jwtManager.GenerateAccessToken(user.ID, user.Email, user.Username, user.FirebaseUID)
	if err != nil {
		return nil, errors.New("failed to generate access token")
	}

	return &AuthResponse{
		AccessToken:  accessToken,
		RefreshToken: refreshTokenStr, // Return the same refresh token
		TokenType:    "Bearer",
		ExpiresIn:    900, // 15 minutes
		User:         uc.toUserResponse(user),
	}, nil
}

// Logout revokes refresh token
func (uc *AuthUseCase) Logout(ctx context.Context, refreshTokenStr string) error {
	return uc.refreshTokenRepo.Revoke(ctx, refreshTokenStr)
}

// LogoutAll revokes all refresh tokens for a user
func (uc *AuthUseCase) LogoutAll(ctx context.Context, userID uuid.UUID) error {
	return uc.refreshTokenRepo.RevokeAllForUser(ctx, userID)
}

// GetMe returns current user profile
func (uc *AuthUseCase) GetMe(ctx context.Context, userID uuid.UUID) (*UserResponse, error) {
	user, err := uc.userRepo.GetByID(ctx, userID)
	if err != nil {
		return nil, err
	}
	return uc.toUserResponse(user), nil
}

// UpdateProfile updates user profile
func (uc *AuthUseCase) UpdateProfile(ctx context.Context, userID uuid.UUID, username string, avatarURL *string) (*UserResponse, error) {
	// Get current user
	user, err := uc.userRepo.GetByID(ctx, userID)
	if err != nil {
		return nil, err
	}

	// Check if username is different and already taken
	if username != user.Username {
		exists, err := uc.userRepo.ExistsByUsername(ctx, username)
		if err != nil {
			return nil, errors.New("failed to check username availability")
		}
		if exists {
			return nil, errors.New("username already taken")
		}
		user.Username = username
	}

	// Update avatar if provided
	if avatarURL != nil {
		user.AvatarURL = avatarURL
	}

	// Save changes
	if err := uc.userRepo.Update(ctx, user); err != nil {
		return nil, errors.New("failed to update profile")
	}

	return uc.toUserResponse(user), nil
}

// Helper function to convert User to UserResponse
func (uc *AuthUseCase) toUserResponse(user *entities.User) *UserResponse {
	return &UserResponse{
		ID:          user.ID,
		Username:    user.Username,
		Email:       user.Email,
		AvatarURL:   user.AvatarURL,
		ExpPoints:   user.ExpPoints,
		Level:       user.Level,
		LevelTitle:  user.LevelTitle,
		LastLoginAt: user.LastLoginAt,
		CreatedAt:   user.CreatedAt,
	}
}
