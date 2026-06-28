package services

import (
	"context"
	"crypto/rand"
	"encoding/hex"
	"errors"
	"fmt"
	"time"

	"github.com/TranVinhHien/sol-bet88.git/internal/config"
	"github.com/TranVinhHien/sol-bet88.git/internal/logging"
	"github.com/TranVinhHien/sol-bet88.git/internal/models"
	"github.com/TranVinhHien/sol-bet88.git/internal/repository"
	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"
)

type AuthService struct {
	userRepo repository.IUserRepository
}

func NewAuthService(userRepo repository.IUserRepository) *AuthService {
	return &AuthService{userRepo: userRepo}
}

type RegisterInput struct {
	Email       string
	Password    string
	FullName    string
	AvatarURL   *string
	PhoneNumber *string
	HomeAddress *string
	CurrentLat  *float64
	CurrentLng  *float64
}

type LoginInput struct {
	Email     string
	Password  string
	ClientIP  *string
	UserAgent *string
}

type AuthResponse struct {
	Token        string                 `json:"token"`
	RefreshToken string                 `json:"refresh_token"`
	User         *models.UserCredential `json:"user"`
}

var (
	ErrEmailExists        = errors.New("email already exists")
	ErrInvalidCredentials = errors.New("invalid email or password")
	ErrUserInactive       = errors.New("user account is inactive")
	ErrInvalidToken       = errors.New("invalid or expired token")
)

func (s *AuthService) Register(ctx context.Context, input RegisterInput) (*models.UserCredential, error) {
	var err error
	defer func() {
		if err != nil {
			logging.Error(ctx, "AuthService.Register", err)
		}
	}()

	// Check if user already exists
	existingUser, _ := s.userRepo.FindByEmail(ctx, input.Email)
	if existingUser != nil {
		err = ErrEmailExists
		return nil, err
	}

	// Hash password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(input.Password), bcrypt.DefaultCost)
	if err != nil {
		return nil, fmt.Errorf("hash password: %w", err)
	}

	// Create user
	user := &models.UserCredential{
		Email:        input.Email,
		PasswordHash: string(hashedPassword),
		IsActive:     true,
		Provider:     models.AuthProviderLocal,
	}

	if err = s.userRepo.Create(ctx, user); err != nil {
		return nil, fmt.Errorf("create user: %w", err)
	}

	// Create initial profile
	profile := &models.UserProfile{
		UserID:      user.ID,
		FullName:    &input.FullName,
		AvatarURL:   input.AvatarURL,
		PhoneNumber: input.PhoneNumber,
		HomeAddress: input.HomeAddress,
		CurrentLat:  input.CurrentLat,
		CurrentLng:  input.CurrentLng,
	}
	_ = s.userRepo.UpdateProfile(ctx, profile) // ignoring error for simple profile creation

	user.Profile = profile
	return user, nil
}

func (s *AuthService) Login(ctx context.Context, input LoginInput) (resp *AuthResponse, err error) {
	defer func() {
		if err != nil {
			logging.Error(ctx, "AuthService.Login", err)
		}
	}()
	// Find user
	user, err := s.userRepo.FindByEmail(ctx, input.Email)
	if err != nil {
		err = ErrInvalidCredentials
		return nil, err
	}

	// Check status
	if !user.IsActive {
		err = ErrUserInactive
		return nil, err
	}

	// Compare password
	if err = bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(input.Password)); err != nil {
		err = ErrInvalidCredentials
		return nil, err
	}

	// Generate access token
	token, err := s.GenerateToken(user)
	if err != nil {
		return nil, fmt.Errorf("generate token: %w", err)
	}

	// Generate refresh token
	refreshTokenStr, err := s.generateSecureToken(32)
	if err != nil {
		return nil, fmt.Errorf("generate refresh token: %w", err)
	}

	refreshTokenExpiry := 7 * 24 * time.Hour
	if config.App.Token.RefreshTokenExpirationTime > 0 {
		refreshTokenExpiry = time.Duration(config.App.Token.RefreshTokenExpirationTime) * time.Second
	}

	refreshToken := &models.RefreshToken{
		UserID:    user.ID,
		Token:     refreshTokenStr,
		ExpiresAt: time.Now().Add(refreshTokenExpiry),
		ClientIP:  input.ClientIP,
		UserAgent: input.UserAgent,
	}

	if err = s.userRepo.CreateRefreshToken(ctx, refreshToken); err != nil {
		return nil, fmt.Errorf("save refresh token: %w", err)
	}

	return &AuthResponse{
		Token:        token,
		RefreshToken: refreshTokenStr,
		User:         user,
	}, nil
}

func (s *AuthService) RefreshToken(ctx context.Context, tokenStr string) (*AuthResponse, error) {
	var err error
	defer func() {
		if err != nil {
			logging.Error(ctx, "AuthService.RefreshToken", err)
		}
	}()

	rt, err := s.userRepo.FindRefreshToken(ctx, tokenStr)
	if err != nil || rt.IsRevoked || rt.ExpiresAt.Before(time.Now()) {
		err = ErrInvalidToken
		return nil, err
	}

	user, err := s.userRepo.FindByID(ctx, rt.UserID)
	if err != nil {
		err = ErrInvalidToken
		return nil, err
	}

	if !user.IsActive {
		err = ErrUserInactive
		return nil, err
	}

	// Generate new access token
	token, err := s.GenerateToken(user)
	if err != nil {
		return nil, fmt.Errorf("generate token: %w", err)
	}
	return &AuthResponse{
		Token:        token,
		RefreshToken: rt.Token,
		User:         user,
	}, nil
}

func (s *AuthService) Logout(ctx context.Context, tokenStr string) error {
	var err error
	defer func() {
		if err != nil {
			logging.Error(ctx, "AuthService.Logout", err)
		}
	}()

	rt, err := s.userRepo.FindRefreshToken(ctx, tokenStr)
	if err != nil {
		return nil // If token not found, consider it already logged out
	}

	return s.userRepo.RevokeRefreshToken(ctx, rt.ID)
}

type JWTClaims struct {
	UserID uuid.UUID `json:"user_id"`
	Email  string    `json:"email"`
	jwt.RegisteredClaims
}

func (s *AuthService) GenerateToken(user *models.UserCredential) (tok string, err error) {
	defer func() {
		if err != nil {
			logging.Error(nil, "AuthService.GenerateToken", err)
		}
	}()

	accessTokenExpiry := 15 * time.Minute
	if config.App.Token.AccessTokenExpirationTime > 0 {
		accessTokenExpiry = time.Duration(config.App.Token.AccessTokenExpirationTime) * time.Second
	}

	claims := JWTClaims{
		UserID: user.ID,
		Email:  user.Email,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(accessTokenExpiry)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tok, err = token.SignedString([]byte(config.App.Token.Secret))
	return tok, err
}

func (s *AuthService) ValidateToken(tokenString string) (*JWTClaims, error) {
	var err error
	defer func() {
		if err != nil {
			logging.Error(nil, "AuthService.ValidateToken", err)
		}
	}()

	token, err := jwt.ParseWithClaims(tokenString, &JWTClaims{}, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return []byte(config.App.Token.Secret), nil
	})

	if err != nil {
		return nil, err
	}

	if claims, ok := token.Claims.(*JWTClaims); ok && token.Valid {
		return claims, nil
	}

	return nil, ErrInvalidToken
}

func (s *AuthService) GetUserByID(ctx context.Context, userID uuid.UUID) (*models.UserCredential, error) {
	var err error
	defer func() {
		if err != nil {
			logging.Error(ctx, "AuthService.GetUserByID", err)
		}
	}()
	u, err := s.userRepo.FindByID(ctx, userID)
	return u, err
}

type UpdateProfileInput struct {
	FullName    *string
	PhoneNumber *string
	HomeAddress *string
	AvatarURL   *string
}

func (s *AuthService) UpdateUser(ctx context.Context, userID uuid.UUID, input UpdateProfileInput) (*models.UserCredential, error) {
	var err error
	defer func() {
		if err != nil {
			logging.Error(ctx, "AuthService.UpdateUser", err)
		}
	}()

	user, err := s.userRepo.FindByID(ctx, userID)
	if err != nil {
		return nil, err
	}

	if user.Profile == nil {
		user.Profile = &models.UserProfile{UserID: userID}
	}

	if input.FullName != nil {
		user.Profile.FullName = input.FullName
	}
	if input.PhoneNumber != nil {
		user.Profile.PhoneNumber = input.PhoneNumber
	}
	if input.HomeAddress != nil {
		user.Profile.HomeAddress = input.HomeAddress
	}
	if input.AvatarURL != nil {
		user.Profile.AvatarURL = input.AvatarURL
	}

	if err = s.userRepo.UpdateProfile(ctx, user.Profile); err != nil {
		return nil, fmt.Errorf("update profile: %w", err)
	}

	return user, nil
}

type UpdatePasswordInput struct {
	OldPassword string
	NewPassword string
}

func (s *AuthService) UpdatePassword(ctx context.Context, userID uuid.UUID, input UpdatePasswordInput) error {
	var err error
	defer func() {
		if err != nil {
			logging.Error(ctx, "AuthService.UpdatePassword", err)
		}
	}()

	user, err := s.userRepo.FindByID(ctx, userID)
	if err != nil {
		return err
	}

	if err = bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(input.OldPassword)); err != nil {
		err = errors.New("invalid old password")
		return err
	}

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(input.NewPassword), bcrypt.DefaultCost)
	if err != nil {
		return fmt.Errorf("hash password: %w", err)
	}

	user.PasswordHash = string(hashedPassword)
	if err = s.userRepo.Update(ctx, user); err != nil {
		return fmt.Errorf("update user: %w", err)
	}

	// Revoke all refresh tokens on password change
	_ = s.userRepo.RevokeAllUserRefreshTokens(ctx, userID)

	return nil
}

func (s *AuthService) generateSecureToken(length int) (string, error) {
	b := make([]byte, length)
	if _, err := rand.Read(b); err != nil {
		return "", err
	}
	return hex.EncodeToString(b), nil
}
