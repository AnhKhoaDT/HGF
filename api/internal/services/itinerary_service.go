package services

import (
	"context"
	"time"

	"github.com/TranVinhHien/sol-bet88.git/internal/handlers/dto"
	"github.com/TranVinhHien/sol-bet88.git/internal/models"
	"github.com/TranVinhHien/sol-bet88.git/internal/repository"
	"github.com/google/uuid"
)

type IItineraryService interface {
	CreateItinerary(ctx context.Context, userID uuid.UUID, req dto.CreateItineraryReq) (*models.Itinerary, error)
	GetItineraryByID(ctx context.Context, id uuid.UUID) (*models.Itinerary, error)
	ListItineraries(ctx context.Context, query dto.ItineraryQuery) ([]models.Itinerary, int64, error)
	UpdateItinerary(ctx context.Context, id uuid.UUID, userID uuid.UUID, req dto.UpdateItineraryReq) (*models.Itinerary, error)
	DeleteItinerary(ctx context.Context, id uuid.UUID, userID uuid.UUID) error
}

type ItineraryService struct {
	repo repository.IItineraryRepository
}

func NewItineraryService(repo repository.IItineraryRepository) IItineraryService {
	return &ItineraryService{repo: repo}
}

func (s *ItineraryService) CreateItinerary(ctx context.Context, userID uuid.UUID, req dto.CreateItineraryReq) (*models.Itinerary, error) {
	if !models.IsValidStatus(req.Status) {
		return nil, ErrInvalidStatus
	}

	langCode := "vi"
	if req.LangCode != "" {
		langCode = req.LangCode
	}

	itinerary := &models.Itinerary{
		ID:            uuid.New(),
		UserID:        userID,
		DivisionID:    req.DivisionID,
		TripName:      req.TripName,
		StartDate:     req.StartDate,
		EndDate:       req.EndDate,
		IsAIGenerated: req.IsAIGenerated,
		LangCode:      langCode,
		Status:        req.Status,
		CreatedBy:     userID,
	}

	if err := s.repo.Create(ctx, itinerary); err != nil {
		return nil, err
	}
	return itinerary, nil
}

func (s *ItineraryService) GetItineraryByID(ctx context.Context, id uuid.UUID) (*models.Itinerary, error) {
	itinerary, err := s.repo.FindByID(ctx, id)
	if err != nil {
		return nil, ErrNotFound
	}
	return itinerary, nil
}

func (s *ItineraryService) ListItineraries(ctx context.Context, query dto.ItineraryQuery) ([]models.Itinerary, int64, error) {
	if query.Page <= 0 {
		query.Page = 1
	}
	if query.Limit <= 0 {
		query.Limit = 10
	}
	return s.repo.FindAll(ctx, query)
}

func (s *ItineraryService) UpdateItinerary(ctx context.Context, id uuid.UUID, userID uuid.UUID, req dto.UpdateItineraryReq) (*models.Itinerary, error) {
	itinerary, err := s.repo.FindByID(ctx, id)
	if err != nil {
		return nil, ErrNotFound
	}

	if !models.IsValidStatus(req.Status) {
		return nil, ErrInvalidStatus
	}

	itinerary.DivisionID = req.DivisionID
	itinerary.TripName = req.TripName
	itinerary.StartDate = req.StartDate
	itinerary.EndDate = req.EndDate
	itinerary.IsAIGenerated = req.IsAIGenerated
	if req.LangCode != "" {
		itinerary.LangCode = req.LangCode
	}
	itinerary.Status = req.Status

	now := time.Now()
	itinerary.UpdatedAt = now
	itinerary.UpdatedBy = &userID

	if err := s.repo.Update(ctx, itinerary); err != nil {
		return nil, err
	}
	return itinerary, nil
}

func (s *ItineraryService) DeleteItinerary(ctx context.Context, id uuid.UUID, userID uuid.UUID) error {
	_, err := s.repo.FindByID(ctx, id)
	if err != nil {
		return ErrNotFound
	}

	return s.repo.Delete(ctx, id, userID)
}
