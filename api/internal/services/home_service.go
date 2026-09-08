package services

import (
	"context"

	"golang.org/x/sync/errgroup"

	"github.com/TranVinhHien/sol-bet88.git/internal/handlers/dto"
	"github.com/TranVinhHien/sol-bet88.git/internal/models"
	"github.com/TranVinhHien/sol-bet88.git/internal/repository"
)

const featuredPlacesLimit = 6

type IHomeService interface {
	GetOverview(ctx context.Context) (*dto.HomeOverviewResponse, error)
}

type HomeService struct {
	placeRepo repository.IPlaceRepository
	catRepo   repository.ICategoryRepository
}

func NewHomeService(placeRepo repository.IPlaceRepository, catRepo repository.ICategoryRepository) IHomeService {
	return &HomeService{placeRepo: placeRepo, catRepo: catRepo}
}

func (s *HomeService) GetOverview(ctx context.Context) (*dto.HomeOverviewResponse, error) {
	var (
		places     []models.Place
		categories []models.Category
	)

	g, gCtx := errgroup.WithContext(ctx)

	g.Go(func() error {
		var err error
		places, err = s.placeRepo.FindFeatured(gCtx, featuredPlacesLimit)
		return err
	})

	g.Go(func() error {
		var err error
		categories, err = s.catRepo.FindAllActive(gCtx)
		return err
	})

	if err := g.Wait(); err != nil {
		return nil, err
	}

	return &dto.HomeOverviewResponse{
		FeaturedPlaces: places,
		Categories:     categories,
	}, nil
}
