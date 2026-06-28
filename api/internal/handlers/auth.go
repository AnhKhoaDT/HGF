package handlers

import (
	"net/http"
	"strings"

	"github.com/TranVinhHien/sol-bet88.git/internal/handlers/dto"
	"github.com/TranVinhHien/sol-bet88.git/internal/services"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type AuthHandler struct {
	authService *services.AuthService
}

func NewAuthHandler(authService *services.AuthService) *AuthHandler {
	return &AuthHandler{authService: authService}
}

// Register godoc
// @Summary Register a new user
// @Description Creates a new user account
// @Tags auth
// @Accept json
// @Produce json
// @Param request body dto.RegisterRequest true "Registration data"
// @Success 201 {object} dto.SuccessResponse
// @Failure 400 {object} dto.ErrorResponse
// @Failure 409 {object} dto.ErrorResponse
// @Failure 500 {object} dto.ErrorResponse
// @Router /auth/register [post]
func (h *AuthHandler) Register(c *gin.Context) {
	var req dto.RegisterRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{
			Status: false,
			Errors: err.Error(),
		})
		return
	}

	user, err := h.authService.Register(c.Request.Context(), services.RegisterInput{
		Email:       req.Email,
		Password:    req.Password,
		FullName:    req.FullName,
		AvatarURL:   req.AvatarURL,
		PhoneNumber: req.PhoneNumber,
		HomeAddress: req.HomeAddress,
		CurrentLat:  req.CurrentLat,
		CurrentLng:  req.CurrentLng,
	})

	if err != nil {
		status := http.StatusInternalServerError
		if err == services.ErrEmailExists {
			status = http.StatusConflict
		}
		c.JSON(status, dto.ErrorResponse{
			Status: false,
			Errors: err.Error(),
		})
		return
	}

	// Don't return password hash
	user.PasswordHash = ""

	c.JSON(http.StatusCreated, dto.SuccessResponse{
		Status: true,
		Data:   user,
	})
}

// Login godoc
// @Summary Login
// @Description Authenticates a user and returns access and refresh tokens
// @Tags auth
// @Accept json
// @Produce json
// @Param request body dto.LoginRequest true "Login credentials"
// @Success 200 {object} dto.SuccessResponse
// @Failure 400 {object} dto.ErrorResponse
// @Failure 401 {object} dto.ErrorResponse
// @Failure 403 {object} dto.ErrorResponse
// @Failure 500 {object} dto.ErrorResponse
// @Router /auth/login [post]
func (h *AuthHandler) Login(c *gin.Context) {
	var req dto.LoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{
			Status: false,
			Errors: err.Error(),
		})
		return
	}

	clientIP := c.ClientIP()
	userAgent := c.Request.UserAgent()

	resp, err := h.authService.Login(c.Request.Context(), services.LoginInput{
		Email:     req.Email,
		Password:  req.Password,
		ClientIP:  &clientIP,
		UserAgent: &userAgent,
	})

	if err != nil {
		status := http.StatusInternalServerError
		if err == services.ErrInvalidCredentials {
			status = http.StatusUnauthorized
		} else if err == services.ErrUserInactive {
			status = http.StatusForbidden
		}
		c.JSON(status, dto.ErrorResponse{
			Status: false,
			Errors: err.Error(),
		})
		return
	}

	// Don't return password hash
	resp.User.PasswordHash = ""

	c.JSON(http.StatusOK, dto.SuccessResponse{
		Status: true,
		Data:   resp,
	})
}

// RefreshToken godoc
// @Summary Refresh access token
// @Description Generates a new access token using a refresh token
// @Tags auth
// @Accept json
// @Produce json
// @Param request body dto.RefreshTokenRequest true "Refresh token"
// @Success 200 {object} dto.SuccessResponse
// @Failure 400 {object} dto.ErrorResponse
// @Failure 401 {object} dto.ErrorResponse
// @Failure 403 {object} dto.ErrorResponse
// @Failure 500 {object} dto.ErrorResponse
// @Router /auth/refresh [post]
func (h *AuthHandler) RefreshToken(c *gin.Context) {
	var req dto.RefreshTokenRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{
			Status: false,
			Errors: err.Error(),
		})
		return
	}

	resp, err := h.authService.RefreshToken(c.Request.Context(), req.RefreshToken)
	if err != nil {
		status := http.StatusInternalServerError
		if err == services.ErrInvalidToken {
			status = http.StatusUnauthorized
		} else if err == services.ErrUserInactive {
			status = http.StatusForbidden
		}
		c.JSON(status, dto.ErrorResponse{
			Status: false,
			Errors: err.Error(),
		})
		return
	}

	resp.User.PasswordHash = ""

	c.JSON(http.StatusOK, dto.SuccessResponse{
		Status: true,
		Data:   resp,
	})
}

// Logout godoc
// @Summary Logout
// @Description Invalidates a refresh token
// @Tags auth
// @Accept json
// @Produce json
// @Param request body dto.LogoutRequest true "Refresh token to revoke"
// @Success 200 {object} dto.SuccessResponse
// @Failure 400 {object} dto.ErrorResponse
// @Failure 500 {object} dto.ErrorResponse
// @Router /auth/logout [post]
func (h *AuthHandler) Logout(c *gin.Context) {
	var req dto.LogoutRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{
			Status: false,
			Errors: err.Error(),
		})
		return
	}

	if err := h.authService.Logout(c.Request.Context(), req.RefreshToken); err != nil {
		c.JSON(http.StatusInternalServerError, dto.ErrorResponse{
			Status: false,
			Errors: err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, dto.SuccessResponse{
		Status: true,
		Data:   "Logged out successfully",
	})
}

// GetMe godoc
// @Summary Get current user
// @Description Gets the profile of the currently logged in user
// @Tags auth
// @Accept json
// @Produce json
// @Security BearerAuth
// @Success 200 {object} dto.SuccessResponse
// @Failure 400 {object} dto.ErrorResponse
// @Failure 401 {object} dto.ErrorResponse
// @Failure 404 {object} dto.ErrorResponse
// @Router /auth/me [get]
func (h *AuthHandler) GetMe(c *gin.Context) {
	userIDStr, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, dto.ErrorResponse{
			Status: false,
			Errors: "unauthorized",
		})
		return
	}

	userID, err := uuid.Parse(userIDStr.(string))
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{
			Status: false,
			Errors: "invalid user ID",
		})
		return
	}

	user, err := h.authService.GetUserByID(c.Request.Context(), userID)
	if err != nil {
		c.JSON(http.StatusNotFound, dto.ErrorResponse{
			Status: false,
			Errors: "user not found",
		})
		return
	}

	// Don't return password hash
	user.PasswordHash = ""

	c.JSON(http.StatusOK, dto.SuccessResponse{
		Status: true,
		Data:   user,
	})
}

// UpdateMe godoc
// @Summary Update profile
// @Description Updates the current user's profile information
// @Tags auth
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param request body dto.UpdateProfileRequest true "Profile details"
// @Success 200 {object} dto.SuccessResponse
// @Failure 400 {object} dto.ErrorResponse
// @Failure 401 {object} dto.ErrorResponse
// @Failure 500 {object} dto.ErrorResponse
// @Router /auth/me [put]
func (h *AuthHandler) UpdateMe(c *gin.Context) {
	userIDStr, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, dto.ErrorResponse{
			Status: false,
			Errors: "unauthorized",
		})
		return
	}

	userID, err := uuid.Parse(userIDStr.(string))
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{
			Status: false,
			Errors: "invalid user ID",
		})
		return
	}

	var req dto.UpdateProfileRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{
			Status: false,
			Errors: err.Error(),
		})
		return
	}

	user, err := h.authService.UpdateUser(c.Request.Context(), userID, services.UpdateProfileInput{
		FullName:    req.FullName,
		PhoneNumber: req.PhoneNumber,
		HomeAddress: req.HomeAddress,
		AvatarURL:   req.AvatarURL,
	})
	if err != nil {
		c.JSON(http.StatusInternalServerError, dto.ErrorResponse{
			Status: false,
			Errors: "failed to update user",
		})
		return
	}

	// Don't return password hash
	user.PasswordHash = ""

	c.JSON(http.StatusOK, dto.SuccessResponse{
		Status: true,
		Data:   user,
	})
}

// UpdatePassword godoc
// @Summary Update password
// @Description Changes the current user's password
// @Tags auth
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param request body dto.UpdatePasswordRequest true "Password details"
// @Success 200 {object} dto.SuccessResponse
// @Failure 400 {object} dto.ErrorResponse
// @Failure 401 {object} dto.ErrorResponse
// @Failure 500 {object} dto.ErrorResponse
// @Router /auth/me/password [put]
func (h *AuthHandler) UpdatePassword(c *gin.Context) {
	userIDStr, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, dto.ErrorResponse{
			Status: false,
			Errors: "unauthorized",
		})
		return
	}

	userID, err := uuid.Parse(userIDStr.(string))
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{
			Status: false,
			Errors: "invalid user ID",
		})
		return
	}

	var req dto.UpdatePasswordRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{
			Status: false,
			Errors: err.Error(),
		})
		return
	}

	err = h.authService.UpdatePassword(c.Request.Context(), userID, services.UpdatePasswordInput{
		OldPassword: req.OldPassword,
		NewPassword: req.NewPassword,
	})
	if err != nil {
		status := http.StatusInternalServerError
		if err.Error() == "invalid old password" {
			status = http.StatusBadRequest
		}
		c.JSON(status, dto.ErrorResponse{
			Status: false,
			Errors: err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, dto.SuccessResponse{
		Status: true,
		Data:   "Password updated successfully",
	})
}

// Middleware for JWT authentication
func AuthMiddleware(authService *services.AuthService) gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			c.JSON(http.StatusUnauthorized, dto.ErrorResponse{
				Status: false,
				Errors: "authorization header required",
			})
			c.Abort()
			return
		}

		// Extract token from "Bearer <token>"
		parts := strings.Split(authHeader, " ")
		if len(parts) != 2 || parts[0] != "Bearer" {
			c.JSON(http.StatusUnauthorized, dto.ErrorResponse{
				Status: false,
				Errors: "invalid authorization header format",
			})
			c.Abort()
			return
		}

		token := parts[1]
		claims, err := authService.ValidateToken(token)
		if err != nil {
			c.JSON(http.StatusUnauthorized, dto.ErrorResponse{
				Status: false,
				Errors: "invalid or expired token",
			})
			c.Abort()
			return
		}

		// Store user info in context
		c.Set("user_id", claims.UserID.String())
		c.Set("email", claims.Email)

		c.Next()
	}
}
