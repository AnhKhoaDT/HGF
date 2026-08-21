package services

import (
	"context"
	"errors"

	"github.com/TranVinhHien/sol-bet88.git/internal/handlers/dto"
	"github.com/TranVinhHien/sol-bet88.git/internal/models"
	"github.com/TranVinhHien/sol-bet88.git/internal/repository"
	"github.com/google/uuid"
)

var (
	ErrNotFound      = errors.New("resource not found")
	ErrInvalidLevel  = errors.New("invalid division level")
	ErrInvalidStatus = errors.New("invalid status")
	ErrInvalidJSONB  = errors.New("invalid JSONB data")
)

type IAdministrativeDivisionService interface {
	CreateDivision(ctx context.Context, req dto.CreateAdministrativeDivisionReq) (*models.AdministrativeDivision, error)
	GetDivisionByID(ctx context.Context, id uuid.UUID) (*models.AdministrativeDivision, error)
	ListDivisions(ctx context.Context, query dto.AdministrativeDivisionQuery) ([]models.AdministrativeDivision, int64, error)
	UpdateDivision(ctx context.Context, id uuid.UUID, req dto.UpdateAdministrativeDivisionReq) (*models.AdministrativeDivision, error)
	DeleteDivision(ctx context.Context, id uuid.UUID) error
}

type AdministrativeDivisionService struct {
	divRepo repository.IAdministrativeDivisionRepository
}

func NewAdministrativeDivisionService(divRepo repository.IAdministrativeDivisionRepository) IAdministrativeDivisionService {
	return &AdministrativeDivisionService{divRepo: divRepo}
}

func (s *AdministrativeDivisionService) CreateDivision(ctx context.Context, req dto.CreateAdministrativeDivisionReq) (*models.AdministrativeDivision, error) {
	if !req.Level.IsValid() {
		return nil, ErrInvalidLevel
	}
	if !models.IsValidStatus(req.Status) {
		return nil, ErrInvalidStatus
	}

	div := &models.AdministrativeDivision{
		ID:       uuid.New(),
		ParentID: req.ParentID,
		Level:    req.Level,
		Name:     req.Name,
		Status:   req.Status,
	}

	if err := s.divRepo.Create(ctx, div); err != nil {
		return nil, err
	}
	return div, nil
}

func (s *AdministrativeDivisionService) GetDivisionByID(ctx context.Context, id uuid.UUID) (*models.AdministrativeDivision, error) {
	div, err := s.divRepo.FindByID(ctx, id)
	if err != nil {
		return nil, ErrNotFound
	}
	return div, nil
}

func (s *AdministrativeDivisionService) ListDivisions(ctx context.Context, query dto.AdministrativeDivisionQuery) ([]models.AdministrativeDivision, int64, error) {
	if query.Page <= 0 {
		query.Page = 1
	}
	if query.Limit <= 0 {
		query.Limit = 10
	}
	return s.divRepo.FindAll(ctx, query)
}

func (s *AdministrativeDivisionService) UpdateDivision(ctx context.Context, id uuid.UUID, req dto.UpdateAdministrativeDivisionReq) (*models.AdministrativeDivision, error) {
	div, err := s.divRepo.FindByID(ctx, id)
	if err != nil {
		return nil, ErrNotFound
	}

	if req.Level != "" {
		if !req.Level.IsValid() {
			return nil, ErrInvalidLevel
		}
		div.Level = req.Level
	}
	if req.Name != "" {
		div.Name = req.Name
	}
	if req.Status != "" {
		if !models.IsValidStatus(req.Status) {
			return nil, ErrInvalidStatus
		}
		div.Status = req.Status
	}
	div.ParentID = req.ParentID

	if err := s.divRepo.Update(ctx, div); err != nil {
		return nil, err
	}
	return div, nil
}

func (s *AdministrativeDivisionService) DeleteDivision(ctx context.Context, id uuid.UUID) error {
	_, err := s.divRepo.FindByID(ctx, id)
	if err != nil {
		return ErrNotFound
	}
	return s.divRepo.Delete(ctx, id)
}
