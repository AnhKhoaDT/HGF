package repo

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
	"hidden-gems-finder/internal/domain/entities"
	"hidden-gems-finder/internal/domain/repositories"
)

type postgresRefreshTokenRepository struct {
	db *gorm.DB
}

// NewPostgresRefreshTokenRepository creates a new PostgreSQL refresh token repository
func NewPostgresRefreshTokenRepository(db *gorm.DB) repositories.RefreshTokenRepository {
	return &postgresRefreshTokenRepository{db: db}
}

func (r *postgresRefreshTokenRepository) Create(ctx context.Context, token *entities.RefreshToken) error {
	return r.db.WithContext(ctx).Create(token).Error
}

func (r *postgresRefreshTokenRepository) GetByToken(ctx context.Context, token string) (*entities.RefreshToken, error) {
	var refreshToken entities.RefreshToken
	err := r.db.WithContext(ctx).
		Preload("User").
		Where("token = ?", token).
		First(&refreshToken).Error
	
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, errors.New("refresh token not found")
		}
		return nil, err
	}
	return &refreshToken, nil
}

func (r *postgresRefreshTokenRepository) GetByUserID(ctx context.Context, userID uuid.UUID) ([]*entities.RefreshToken, error) {
	var tokens []*entities.RefreshToken
	err := r.db.WithContext(ctx).
		Where("user_id = ? AND is_revoked = ?", userID, false).
		Order("created_at DESC").
		Find(&tokens).Error
	return tokens, err
}

func (r *postgresRefreshTokenRepository) Revoke(ctx context.Context, token string) error {
	return r.db.WithContext(ctx).Model(&entities.RefreshToken{}).
		Where("token = ?", token).
		Update("is_revoked", true).Error
}

func (r *postgresRefreshTokenRepository) RevokeAllForUser(ctx context.Context, userID uuid.UUID) error {
	return r.db.WithContext(ctx).Model(&entities.RefreshToken{}).
		Where("user_id = ?", userID).
		Update("is_revoked", true).Error
}

func (r *postgresRefreshTokenRepository) DeleteExpired(ctx context.Context) error {
	return r.db.WithContext(ctx).
		Where("expires_at < ?", time.Now()).
		Delete(&entities.RefreshToken{}).Error
}

func (r *postgresRefreshTokenRepository) Delete(ctx context.Context, token string) error {
	return r.db.WithContext(ctx).
		Where("token = ?", token).
		Delete(&entities.RefreshToken{}).Error
}
