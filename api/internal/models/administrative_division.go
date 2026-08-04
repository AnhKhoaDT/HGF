package models

import (
	"time"

	"github.com/google/uuid"
)

// DivisionLevel defines level of administrative division
type DivisionLevel string

const (
	DivisionLevelCountry  DivisionLevel = "country"
	DivisionLevelProvince DivisionLevel = "province"
	DivisionLevelCity     DivisionLevel = "city"
	DivisionLevelDistrict DivisionLevel = "district"
)

// Status types
const (
	StatusActive   = "active"
	StatusInactive = "inactive"
	StatusDeleted  = "deleted"
)

// AdministrativeDivision model mapping to administrative_divisions table
type AdministrativeDivision struct {
	ID        uuid.UUID               `gorm:"type:uuid;primaryKey;default:uuid_generate_v4()" json:"id"`
	ParentID  *uuid.UUID              `gorm:"type:uuid" json:"parent_id,omitempty"`
	Level     DivisionLevel           `gorm:"type:varchar(50);not null" json:"level"`
	Name      string                  `gorm:"type:varchar(50);not null" json:"name"`
	Status    string                  `gorm:"type:varchar(50);not null" json:"status"`
	CreatedAt time.Time               `gorm:"autoCreateTime" json:"created_at"`
	Parent    *AdministrativeDivision `gorm:"foreignKey:ParentID" json:"parent,omitempty"`
}

func (AdministrativeDivision) TableName() string {
	return "administrative_divisions"
}

// Validate validates administrative division level
func (l DivisionLevel) IsValid() bool {
	switch l {
	case DivisionLevelCountry, DivisionLevelProvince, DivisionLevelCity, DivisionLevelDistrict:
		return true
	}
	return false
}

// Validate status
func IsValidStatus(status string) bool {
	switch status {
	case StatusActive, StatusInactive, StatusDeleted:
		return true
	}
	return false
}
