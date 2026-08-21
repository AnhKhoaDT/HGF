package repository

import (
	"context"
	"fmt"

	"github.com/TranVinhHien/sol-bet88.git/internal/handlers/dto"
	"github.com/TranVinhHien/sol-bet88.git/internal/models"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type IPlaceRepository interface {
	Create(ctx context.Context, p *models.Place) error
	FindByID(ctx context.Context, id uuid.UUID) (*models.Place, error)
	FindAll(ctx context.Context, query dto.PlaceQuery) ([]models.Place, int64, error)
	Update(ctx context.Context, p *models.Place) error
	Delete(ctx context.Context, id uuid.UUID) error
}

type PlaceRepository struct {
	db *gorm.DB
}

func NewPlaceRepository(db *gorm.DB) IPlaceRepository {
	return &PlaceRepository{db: db}
}

func (r *PlaceRepository) Create(ctx context.Context, p *models.Place) error {
	return r.db.WithContext(ctx).Create(p).Error
}

func (r *PlaceRepository) FindByID(ctx context.Context, id uuid.UUID) (*models.Place, error) {
	var p models.Place
	if err := r.db.WithContext(ctx).Preload("Division").Preload("Category").First(&p, "id = ?", id).Error; err != nil {
		return nil, err
	}
	return &p, nil
}

func (r *PlaceRepository) FindAll(ctx context.Context, query dto.PlaceQuery) ([]models.Place, int64, error) {
	var places []models.Place
	var total int64

	tx := r.db.WithContext(ctx).Model(&models.Place{}).Preload("Division").Preload("Category")

	if query.Query != "" {
		tx = tx.Where("name ILIKE ? OR title ILIKE ? OR address_raw ILIKE ?", "%"+query.Query+"%", "%"+query.Query+"%", "%"+query.Query+"%")
	}
	if query.Status != "" {
		tx = tx.Where("status = ?", query.Status)
	} else {
		tx = tx.Where("status != ?", models.StatusDeleted)
	}
	if query.DivisionID != nil {
		tx = tx.Where("division_id = ?", query.DivisionID)
	}
	if query.CategoryID != nil {
		tx = tx.Where("category_id = ?", query.CategoryID)
	}

	if err := tx.Count(&total).Error; err != nil {
		return nil, 0, err
	}

	offset := (query.Page - 1) * query.Limit
	if err := tx.Offset(offset).Limit(query.Limit).Order(fmt.Sprintf("%s.created_at DESC", models.Place{}.TableName())).Find(&places).Error; err != nil {
		return nil, 0, err
	}

	return places, total, nil
}

func (r *PlaceRepository) Update(ctx context.Context, p *models.Place) error {
	return r.db.WithContext(ctx).Save(p).Error
}

func (r *PlaceRepository) Delete(ctx context.Context, id uuid.UUID) error {
	return r.db.WithContext(ctx).Model(&models.Place{}).Where("id = ?", id).Update("status", models.StatusDeleted).Error
}
