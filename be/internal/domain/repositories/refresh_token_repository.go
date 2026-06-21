package repositories

import (
	"context"

	"github.com/google/uuid"
	"hidden-gems-finder/internal/domain/entities"
)

// RefreshTokenRepository defines the interface for refresh token operations
type RefreshTokenRepository interface {
	// Create creates a new refresh token
	Create(ctx context.Context, token *entities.RefreshToken) error
	
	// GetByToken retrieves a refresh token by token string
	GetByToken(ctx context.Context, token string) (*entities.RefreshToken, error)
	
	// GetByUserID retrieves all refresh tokens for a user
	GetByUserID(ctx context.Context, userID uuid.UUID) ([]*entities.RefreshToken, error)
	
	// Revoke revokes a refresh token
	Revoke(ctx context.Context, token string) error
	
	// RevokeAllForUser revokes all refresh tokens for a user
	RevokeAllForUser(ctx context.Context, userID uuid.UUID) error
	
	// DeleteExpired deletes all expired refresh tokens
	DeleteExpired(ctx context.Context) error
	
	// Delete deletes a refresh token
	Delete(ctx context.Context, token string) error
}
