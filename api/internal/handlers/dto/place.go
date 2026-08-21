package dto

import (
	"github.com/TranVinhHien/sol-bet88.git/internal/models"
	"github.com/google/uuid"
)

// PaginationResponse represents pagination metadata
type PaginationResponse struct {
	Total int64 `json:"total"`
	Page  int   `json:"page"`
	Limit int   `json:"limit"`
}

// PlaceQuery filters
type PlaceQuery struct {
	Page       int        `form:"page,default=1"`
	Limit      int        `form:"limit,default=10"`
	Query      string     `form:"query"`
	Status     string     `form:"status"`
	DivisionID *uuid.UUID `form:"division_id"`
	CategoryID *uuid.UUID `form:"category_id"`
}

// CreatePlaceReq payload
type CreatePlaceReq struct {
	DivisionID  *uuid.UUID             `json:"division_id"`
	CategoryID  *uuid.UUID             `json:"category_id"`
	Name        string                 `json:"name" binding:"required"`
	Title       *string                `json:"title"`
	Description models.DescriptionJSON `json:"description"`
	AddressRaw  string                 `json:"address_raw" binding:"required"`
	Lat         float64                `json:"lat" binding:"required"`
	Lng         float64                `json:"lng" binding:"required"`
	Images      models.PlaceImages     `json:"images"`
	Status      string                 `json:"status" binding:"required"`
	Metadata    models.PlaceMetadata   `json:"metadata"`
}

// UpdatePlaceReq payload
type UpdatePlaceReq struct {
	DivisionID  *uuid.UUID             `json:"division_id"`
	CategoryID  *uuid.UUID             `json:"category_id"`
	Name        string                 `json:"name"`
	Title       *string                `json:"title"`
	Description models.DescriptionJSON `json:"description"`
	AddressRaw  string                 `json:"address_raw"`
	Lat         *float64               `json:"lat"`
	Lng         *float64               `json:"lng"`
	Images      models.PlaceImages     `json:"images"`
	Status      string                 `json:"status"`
	Metadata    models.PlaceMetadata   `json:"metadata"`
}
