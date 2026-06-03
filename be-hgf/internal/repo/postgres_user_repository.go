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

type postgresUserRepository struct {
	db *gorm.DB
}

// NewPostgresUserRepository creates a new PostgreSQL user repository
func NewPostgresUserRepository(db *gorm.DB) repositories.UserRepository {
	return &postgresUserRepository{db: db}
}

func (r *postgresUserRepository) Create(ctx context.Context, user *entities.User) error {
	return r.db.WithContext(ctx).Create(user).Error
}

func (r *postgresUserRepository) GetByID(ctx context.Context, id uuid.UUID) (*entities.User, error) {
	var user entities.User
	err := r.db.WithContext(ctx).Where("id = ? AND is_active = ?", id, true).First(&user).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, errors.New("user not found")
		}
		return nil, err
	}
	return &user, nil
}

func (r *postgresUserRepository) GetByEmail(ctx context.Context, email string) (*entities.User, error) {
	var user entities.User
	err := r.db.WithContext(ctx).Where("email = ? AND is_active = ?", email, true).First(&user).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, errors.New("user not found")
		}
		return nil, err
	}
	return &user, nil
}

func (r *postgresUserRepository) GetByFirebaseUID(ctx context.Context, firebaseUID string) (*entities.User, error) {
	var user entities.User
	err := r.db.WithContext(ctx).Where("firebase_uid = ? AND is_active = ?", firebaseUID, true).First(&user).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, errors.New("user not found")
		}
		return nil, err
	}
	return &user, nil
}

func (r *postgresUserRepository) GetByUsername(ctx context.Context, username string) (*entities.User, error) {
	var user entities.User
	err := r.db.WithContext(ctx).Where("username = ? AND is_active = ?", username, true).First(&user).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, errors.New("user not found")
		}
		return nil, err
	}
	return &user, nil
}

func (r *postgresUserRepository) Update(ctx context.Context, user *entities.User) error {
	return r.db.WithContext(ctx).Save(user).Error
}

func (r *postgresUserRepository) Delete(ctx context.Context, id uuid.UUID) error {
	return r.db.WithContext(ctx).Model(&entities.User{}).
		Where("id = ?", id).
		Update("is_active", false).Error
}

func (r *postgresUserRepository) UpdateLastLogin(ctx context.Context, id uuid.UUID) error {
	now := time.Now()
	return r.db.WithContext(ctx).Model(&entities.User{}).
		Where("id = ?", id).
		Update("last_login_at", now).Error
}

func (r *postgresUserRepository) ExistsByEmail(ctx context.Context, email string) (bool, error) {
	var count int64
	err := r.db.WithContext(ctx).Model(&entities.User{}).
		Where("email = ? AND is_active = ?", email, true).
		Count(&count).Error
	return count > 0, err
}

func (r *postgresUserRepository) ExistsByUsername(ctx context.Context, username string) (bool, error) {
	var count int64
	err := r.db.WithContext(ctx).Model(&entities.User{}).
		Where("username = ? AND is_active = ?", username, true).
		Count(&count).Error
	return count > 0, err
}

func (r *postgresUserRepository) ExistsByFirebaseUID(ctx context.Context, firebaseUID string) (bool, error) {
	var count int64
	err := r.db.WithContext(ctx).Model(&entities.User{}).
		Where("firebase_uid = ? AND is_active = ?", firebaseUID, true).
		Count(&count).Error
	return count > 0, err
}
