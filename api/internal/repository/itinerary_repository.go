package repository

import (
	"context"

	"github.com/TranVinhHien/sol-bet88.git/internal/handlers/dto"
	"github.com/TranVinhHien/sol-bet88.git/internal/models"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type IItineraryRepository interface {
	Create(ctx context.Context, itinerary *models.Itinerary) error
	FindByID(ctx context.Context, id uuid.UUID) (*models.Itinerary, error)
	FindAll(ctx context.Context, query dto.ItineraryQuery) ([]models.Itinerary, int64, error)
	Update(ctx context.Context, itinerary *models.Itinerary) error
	Delete(ctx context.Context, id uuid.UUID, deletedBy uuid.UUID) error
}

type ItineraryRepository struct {
	db *gorm.DB
}

func NewItineraryRepository(db *gorm.DB) IItineraryRepository {
	return &ItineraryRepository{db: db}
}

func (r *ItineraryRepository) Create(ctx context.Context, itinerary *models.Itinerary) error {
	return r.db.WithContext(ctx).Create(itinerary).Error
}

func (r *ItineraryRepository) FindByID(ctx context.Context, id uuid.UUID) (*models.Itinerary, error) {
	var itinerary models.Itinerary
	if err := r.db.WithContext(ctx).First(&itinerary, "id = ?", id).Error; err != nil {
		return nil, err
	}
	return &itinerary, nil
}

func (r *ItineraryRepository) FindAll(ctx context.Context, query dto.ItineraryQuery) ([]models.Itinerary, int64, error) {
	var itineraries []models.Itinerary
	var total int64

	tx := r.db.WithContext(ctx).Model(&models.Itinerary{})

	if query.Query != "" {
		tx = tx.Where("trip_name ILIKE ?", "%"+query.Query+"%")
	}
	if query.Status != "" {
		tx = tx.Where("status = ?", query.Status)
	} else {
		tx = tx.Where("status != ?", models.StatusDeleted)
	}
	
	if query.UserID != nil {
		tx = tx.Where("user_id = ?", *query.UserID)
	}
	if query.StartDate != nil {
		tx = tx.Where("start_date >= ?", *query.StartDate)
	}
	if query.EndDate != nil {
		tx = tx.Where("end_date <= ?", *query.EndDate)
	}
	if query.IsAIGenerated != nil {
		tx = tx.Where("is_ai_generated = ?", *query.IsAIGenerated)
	}
	if query.LangCode != "" {
		tx = tx.Where("lang_code = ?", query.LangCode)
	}

	if err := tx.Count(&total).Error; err != nil {
		return nil, 0, err
	}

	offset := (query.Page - 1) * query.Limit
	if err := tx.Offset(offset).Limit(query.Limit).Find(&itineraries).Error; err != nil {
		return nil, 0, err
	}

	return itineraries, total, nil
}

func (r *ItineraryRepository) Update(ctx context.Context, itinerary *models.Itinerary) error {
	return r.db.WithContext(ctx).Save(itinerary).Error
}

func (r *ItineraryRepository) Delete(ctx context.Context, id uuid.UUID, deletedBy uuid.UUID) error {
	return r.db.WithContext(ctx).Model(&models.Itinerary{}).Where("id = ?", id).Updates(map[string]interface{}{
		"status":     models.StatusDeleted,
		"updated_by": deletedBy,
	}).Error
}
