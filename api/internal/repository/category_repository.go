package repository

import (
	"context"

	"github.com/TranVinhHien/sol-bet88.git/internal/handlers/dto"
	"github.com/TranVinhHien/sol-bet88.git/internal/models"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type ICategoryRepository interface {
	Create(ctx context.Context, cat *models.Category) error
	FindByID(ctx context.Context, id uuid.UUID) (*models.Category, error)
	FindAll(ctx context.Context, query dto.CategoryQuery) ([]models.Category, int64, error)
	Update(ctx context.Context, cat *models.Category) error
	Delete(ctx context.Context, id uuid.UUID) error
}

type CategoryRepository struct {
	db *gorm.DB
}

func NewCategoryRepository(db *gorm.DB) ICategoryRepository {
	return &CategoryRepository{db: db}
}

func (r *CategoryRepository) Create(ctx context.Context, cat *models.Category) error {
	return r.db.WithContext(ctx).Create(cat).Error
}

func (r *CategoryRepository) FindByID(ctx context.Context, id uuid.UUID) (*models.Category, error) {
	var cat models.Category
	if err := r.db.WithContext(ctx).First(&cat, "id = ?", id).Error; err != nil {
		return nil, err
	}
	return &cat, nil
}

func (r *CategoryRepository) FindAll(ctx context.Context, query dto.CategoryQuery) ([]models.Category, int64, error) {
	var categories []models.Category
	var total int64

	tx := r.db.WithContext(ctx).Model(&models.Category{})

	if query.Query != "" {
		tx = tx.Where("name ILIKE ?", "%"+query.Query+"%")
	}
	if query.Status != "" {
		tx = tx.Where("status = ?", query.Status)
	} else {
		tx = tx.Where("status != ?", models.StatusDeleted)
	}

	if err := tx.Count(&total).Error; err != nil {
		return nil, 0, err
	}

	offset := (query.Page - 1) * query.Limit
	if err := tx.Offset(offset).Limit(query.Limit).Find(&categories).Error; err != nil {
		return nil, 0, err
	}

	return categories, total, nil
}

func (r *CategoryRepository) Update(ctx context.Context, cat *models.Category) error {
	return r.db.WithContext(ctx).Save(cat).Error
}

func (r *CategoryRepository) Delete(ctx context.Context, id uuid.UUID) error {
	return r.db.WithContext(ctx).Model(&models.Category{}).Where("id = ?", id).Update("status", models.StatusDeleted).Error
}
