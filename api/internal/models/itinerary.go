package models

import (
	"time"

	"github.com/google/uuid"
)

// Itinerary model mapping to itineraries table
type Itinerary struct {
	ID            uuid.UUID  `gorm:"type:uuid;primaryKey;default:uuid_generate_v4()" json:"id"`
	UserID        uuid.UUID  `gorm:"type:uuid;not null" json:"user_id"`
	DivisionID    *uuid.UUID `gorm:"type:uuid" json:"division_id,omitempty"`
	TripName      string     `gorm:"type:varchar(255);not null" json:"trip_name"`
	StartDate     *time.Time `gorm:"type:date" json:"start_date,omitempty"`
	EndDate       *time.Time `gorm:"type:date" json:"end_date,omitempty"`
	IsAIGenerated bool       `gorm:"type:boolean;default:false" json:"is_ai_generated"`
	LangCode      string     `gorm:"type:varchar(10);default:'vi'" json:"lang_code"`
	Status        string     `gorm:"type:varchar(50);not null" json:"status"`
	CreatedAt     time.Time  `gorm:"autoCreateTime" json:"created_at"`
	CreatedBy     uuid.UUID  `gorm:"type:uuid;not null" json:"created_by"`
	UpdatedAt     time.Time  `gorm:"autoUpdateTime" json:"updated_at"`
	UpdatedBy     *uuid.UUID `gorm:"type:uuid" json:"updated_by,omitempty"`
}

func (Itinerary) TableName() string {
	return "itineraries"
}
