package repository

import (
	"context"

	"github.com/TranVinhHien/sol-bet88.git/internal/handlers/dto"
	"github.com/TranVinhHien/sol-bet88.git/internal/models"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type IAdministrativeDivisionRepository interface {
	Create(ctx context.Context, div *models.AdministrativeDivision) error
	FindByID(ctx context.Context, id uuid.UUID) (*models.AdministrativeDivision, error)
	FindAll(ctx context.Context, query dto.AdministrativeDivisionQuery) ([]models.AdministrativeDivision, int64, error)
	Update(ctx context.Context, div *models.AdministrativeDivision) error
	Delete(ctx context.Context, id uuid.UUID) error
}

type AdministrativeDivisionRepository struct {
	db *gorm.DB
}

func NewAdministrativeDivisionRepository(db *gorm.DB) IAdministrativeDivisionRepository {
	return &AdministrativeDivisionRepository{db: db}
}

func (r *AdministrativeDivisionRepository) Create(ctx context.Context, div *models.AdministrativeDivision) error {
	return r.db.WithContext(ctx).Create(div).Error
}

func (r *AdministrativeDivisionRepository) FindByID(ctx context.Context, id uuid.UUID) (*models.AdministrativeDivision, error) {
	var div models.AdministrativeDivision
	if err := r.db.WithContext(ctx).Preload("Parent").First(&div, "id = ?", id).Error; err != nil {
		return nil, err
	}
	return &div, nil
}

func (r *AdministrativeDivisionRepository) FindAll(ctx context.Context, query dto.AdministrativeDivisionQuery) ([]models.AdministrativeDivision, int64, error) {
	var divisions []models.AdministrativeDivision
	var total int64

	tx := r.db.WithContext(ctx).Model(&models.AdministrativeDivision{})

	if query.Query != "" {
		tx = tx.Where("name ILIKE ?", "%"+query.Query+"%")
	}
	if query.Level != "" {
		tx = tx.Where("level = ?", string(query.Level))
	}
	if query.ParentID != nil {
		tx = tx.Where("parent_id = ?", query.ParentID)
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
	if err := tx.Offset(offset).Limit(query.Limit).Find(&divisions).Error; err != nil {
		return nil, 0, err
	}

	return divisions, total, nil
}

func (r *AdministrativeDivisionRepository) Update(ctx context.Context, div *models.AdministrativeDivision) error {
	return r.db.WithContext(ctx).Save(div).Error
}

func (r *AdministrativeDivisionRepository) Delete(ctx context.Context, id uuid.UUID) error {
	return r.db.WithContext(ctx).Model(&models.AdministrativeDivision{}).Where("id = ?", id).Update("status", models.StatusDeleted).Error
}
