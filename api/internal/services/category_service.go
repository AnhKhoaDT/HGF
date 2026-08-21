package services

import (
	"context"

	"github.com/TranVinhHien/sol-bet88.git/internal/handlers/dto"
	"github.com/TranVinhHien/sol-bet88.git/internal/models"
	"github.com/TranVinhHien/sol-bet88.git/internal/repository"
	"github.com/google/uuid"
)

type ICategoryService interface {
	CreateCategory(ctx context.Context, req dto.CreateCategoryReq) (*models.Category, error)
	GetCategoryByID(ctx context.Context, id uuid.UUID) (*models.Category, error)
	ListCategories(ctx context.Context, query dto.CategoryQuery) ([]models.Category, int64, error)
	UpdateCategory(ctx context.Context, id uuid.UUID, req dto.UpdateCategoryReq) (*models.Category, error)
	DeleteCategory(ctx context.Context, id uuid.UUID) error
}

type CategoryService struct {
	catRepo repository.ICategoryRepository
}

func NewCategoryService(catRepo repository.ICategoryRepository) ICategoryService {
	return &CategoryService{catRepo: catRepo}
}

func (s *CategoryService) CreateCategory(ctx context.Context, req dto.CreateCategoryReq) (*models.Category, error) {
	if !models.IsValidStatus(req.Status) {
		return nil, ErrInvalidStatus
	}

	cat := &models.Category{
		ID:      uuid.New(),
		Name:    req.Name,
		Status:  req.Status,
		IconURL: req.IconURL,
	}

	if err := s.catRepo.Create(ctx, cat); err != nil {
		return nil, err
	}
	return cat, nil
}

func (s *CategoryService) GetCategoryByID(ctx context.Context, id uuid.UUID) (*models.Category, error) {
	cat, err := s.catRepo.FindByID(ctx, id)
	if err != nil {
		return nil, ErrNotFound
	}
	return cat, nil
}

func (s *CategoryService) ListCategories(ctx context.Context, query dto.CategoryQuery) ([]models.Category, int64, error) {
	if query.Page <= 0 {
		query.Page = 1
	}
	if query.Limit <= 0 {
		query.Limit = 10
	}
	return s.catRepo.FindAll(ctx, query)
}

func (s *CategoryService) UpdateCategory(ctx context.Context, id uuid.UUID, req dto.UpdateCategoryReq) (*models.Category, error) {
	cat, err := s.catRepo.FindByID(ctx, id)
	if err != nil {
		return nil, ErrNotFound
	}

	if req.Name != "" {
		cat.Name = req.Name
	}
	if req.Status != "" {
		if !models.IsValidStatus(req.Status) {
			return nil, ErrInvalidStatus
		}
		cat.Status = req.Status
	}
	if req.IconURL != nil {
		cat.IconURL = req.IconURL
	}

	if err := s.catRepo.Update(ctx, cat); err != nil {
		return nil, err
	}
	return cat, nil
}

func (s *CategoryService) DeleteCategory(ctx context.Context, id uuid.UUID) error {
	_, err := s.catRepo.FindByID(ctx, id)
	if err != nil {
		return ErrNotFound
	}
	return s.catRepo.Delete(ctx, id)
}
