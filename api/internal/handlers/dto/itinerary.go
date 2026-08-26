package dto

import (
	"time"

	"github.com/google/uuid"
)

// ItineraryQuery filters
type ItineraryQuery struct {
	Page          int        `form:"page,default=1"`
	Limit         int        `form:"limit,default=10"`
	Query         string     `form:"query"` // searches in trip_name
	Status        string     `form:"status"`
	StartDate     *time.Time `form:"start_date" time_format:"2006-01-02"`
	EndDate       *time.Time `form:"end_date" time_format:"2006-01-02"`
	IsAIGenerated *bool      `form:"is_ai_generated"`
	LangCode      string     `form:"lang_code"`
	UserID        *uuid.UUID `form:"user_id"`
}

// CreateItineraryReq payload
type CreateItineraryReq struct {
	DivisionID    *uuid.UUID `json:"division_id"`
	TripName      string     `json:"trip_name" binding:"required,max=255"`
	StartDate     *time.Time `json:"start_date" time_format:"2006-01-02"`
	EndDate       *time.Time `json:"end_date" time_format:"2006-01-02"`
	IsAIGenerated bool       `json:"is_ai_generated"`
	LangCode      string     `json:"lang_code"`
	Status        string     `json:"status" binding:"required"`
}

// UpdateItineraryReq payload
type UpdateItineraryReq struct {
	DivisionID    *uuid.UUID `json:"division_id"`
	TripName      string     `json:"trip_name" binding:"required,max=255"`
	StartDate     *time.Time `json:"start_date" time_format:"2006-01-02"`
	EndDate       *time.Time `json:"end_date" time_format:"2006-01-02"`
	IsAIGenerated bool       `json:"is_ai_generated"`
	LangCode      string     `json:"lang_code"`
	Status        string     `json:"status" binding:"required"`
}
