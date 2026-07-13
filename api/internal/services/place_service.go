package services

import (
	"context"
	"fmt"

	"github.com/TranVinhHien/sol-bet88.git/internal/handlers/dto"
	"github.com/TranVinhHien/sol-bet88.git/internal/models"
	"github.com/TranVinhHien/sol-bet88.git/internal/repository"
	"github.com/google/uuid"
)

type IPlaceService interface {
	CreatePlace(ctx context.Context, req dto.CreatePlaceReq) (*models.Place, error)
	GetPlaceByID(ctx context.Context, id uuid.UUID) (*models.Place, error)
	ListPlaces(ctx context.Context, query dto.PlaceQuery) ([]models.Place, int64, error)
	UpdatePlace(ctx context.Context, id uuid.UUID, req dto.UpdatePlaceReq) (*models.Place, error)
	DeletePlace(ctx context.Context, id uuid.UUID) error
}

type PlaceService struct {
	placeRepo repository.IPlaceRepository
}

func NewPlaceService(placeRepo repository.IPlaceRepository) IPlaceService {
	return &PlaceService{placeRepo: placeRepo}
}

func (s *PlaceService) CreatePlace(ctx context.Context, req dto.CreatePlaceReq) (*models.Place, error) {
	if !models.IsValidStatus(req.Status) {
		return nil, ErrInvalidStatus
	}

	// Validate JSONB structures
	for _, img := range req.Images {
		if err := img.Validate(); err != nil {
			return nil, fmt.Errorf("%w: %s", ErrInvalidJSONB, err.Error())
		}
	}

	if err := req.Metadata.Validate(); err != nil {
		return nil, fmt.Errorf("%w: %s", ErrInvalidJSONB, err.Error())
	}

	p := &models.Place{
		ID:          uuid.New(),
		DivisionID:  req.DivisionID,
		CategoryID:  req.CategoryID,
		Name:        req.Name,
		Title:       req.Title,
		Description: req.Description,
		AddressRaw:  req.AddressRaw,
		Lat:         req.Lat,
		Lng:         req.Lng,
		Images:      req.Images,
		Status:      req.Status,
		Metadata:    req.Metadata,
	}

	if err := s.placeRepo.Create(ctx, p); err != nil {
		return nil, err
	}
	return s.placeRepo.FindByID(ctx, p.ID)
}

func (s *PlaceService) GetPlaceByID(ctx context.Context, id uuid.UUID) (*models.Place, error) {
	p, err := s.placeRepo.FindByID(ctx, id)
	if err != nil {
		return nil, ErrNotFound
	}
	return p, nil
}

func (s *PlaceService) ListPlaces(ctx context.Context, query dto.PlaceQuery) ([]models.Place, int64, error) {
	if query.Page <= 0 {
		query.Page = 1
	}
	if query.Limit <= 0 {
		query.Limit = 10
	}
	return s.placeRepo.FindAll(ctx, query)
}

func (s *PlaceService) UpdatePlace(ctx context.Context, id uuid.UUID, req dto.UpdatePlaceReq) (*models.Place, error) {
	p, err := s.placeRepo.FindByID(ctx, id)
	if err != nil {
		return nil, ErrNotFound
	}

	if req.DivisionID != nil {
		p.DivisionID = req.DivisionID
	}
	if req.CategoryID != nil {
		p.CategoryID = req.CategoryID
	}
	if req.Name != "" {
		p.Name = req.Name
	}
	if req.Title != nil {
		p.Title = req.Title
	}
	if req.Description != nil {
		p.Description = req.Description
	}
	if req.AddressRaw != "" {
		p.AddressRaw = req.AddressRaw
	}
	if req.Lat != nil {
		p.Lat = *req.Lat
	}
	if req.Lng != nil {
		p.Lng = *req.Lng
	}
	if req.Images != nil {
		for _, img := range req.Images {
			if err := img.Validate(); err != nil {
				return nil, fmt.Errorf("%w: %s", ErrInvalidJSONB, err.Error())
			}
		}
		p.Images = req.Images
	}
	if req.Status != "" {
		if !models.IsValidStatus(req.Status) {
			return nil, ErrInvalidStatus
		}
		p.Status = req.Status
	}
	if req.Metadata.Infomations != nil {
		if err := req.Metadata.Validate(); err != nil {
			return nil, fmt.Errorf("%w: %s", ErrInvalidJSONB, err.Error())
		}
		p.Metadata = req.Metadata
	}

	if err := s.placeRepo.Update(ctx, p); err != nil {
		return nil, err
	}
	return s.placeRepo.FindByID(ctx, p.ID)
}

func (s *PlaceService) DeletePlace(ctx context.Context, id uuid.UUID) error {
	_, err := s.placeRepo.FindByID(ctx, id)
	if err != nil {
		return ErrNotFound
	}
	return s.placeRepo.Delete(ctx, id)
}
