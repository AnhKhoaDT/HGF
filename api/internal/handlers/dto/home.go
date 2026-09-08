package dto

import "github.com/TranVinhHien/sol-bet88.git/internal/models"

type HomeOverviewResponse struct {
	FeaturedPlaces []models.Place    `json:"featured_places"`
	Categories     []models.Category `json:"categories"`
}
