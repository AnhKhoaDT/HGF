package models

import (
	"database/sql/driver"
	"encoding/json"
	"errors"
	"fmt"
	"time"

	"github.com/google/uuid"
)

// PlaceImage maps each element in the JSONB array for images
type PlaceImage struct {
	ImageURL  string `json:"image_url" binding:"required"`
	Caption   string `json:"caption"`
	SortOrder int    `json:"sort_order"`
}

// PlaceImages implements scanner/valuer for jsonb array
type PlaceImages []PlaceImage

func (pi *PlaceImages) Scan(value interface{}) error {
	bytes, ok := value.([]byte)
	if !ok {
		return errors.New("type assertion to []byte failed")
	}
	return json.Unmarshal(bytes, pi)
}

func (pi PlaceImages) Value() (driver.Value, error) {
	if pi == nil {
		return "[]", nil
	}
	return json.Marshal(pi)
}

// PlaceMetadataInfo maps label/value pair in metadata JSONB
type PlaceMetadataInfo struct {
	Label string `json:"label" binding:"required"`
	Value string `json:"value"`
}

// PlaceMetadata maps metadata JSONB
type PlaceMetadata struct {
	Infomations []PlaceMetadataInfo `json:"infomations"`
}

func (pm *PlaceMetadata) Scan(value interface{}) error {
	bytes, ok := value.([]byte)
	if !ok {
		return errors.New("type assertion to []byte failed")
	}
	return json.Unmarshal(bytes, pm)
}

func (pm PlaceMetadata) Value() (driver.Value, error) {
	if pm.Infomations == nil {
		return `{"infomations":[]}`, nil
	}
	return json.Marshal(pm)
}

// DescriptionJSON maps description JSONB
type DescriptionJSON map[string]interface{}

func (dj *DescriptionJSON) Scan(value interface{}) error {
	bytes, ok := value.([]byte)
	if !ok {
		return errors.New("type assertion to []byte failed")
	}
	return json.Unmarshal(bytes, dj)
}

func (dj DescriptionJSON) Value() (driver.Value, error) {
	if dj == nil {
		return "{}", nil
	}
	return json.Marshal(dj)
}

// Place model mapping to places table
type Place struct {
	ID          uuid.UUID               `gorm:"type:uuid;primaryKey;default:uuid_generate_v4()" json:"id"`
	DivisionID  *uuid.UUID              `gorm:"type:uuid" json:"division_id,omitempty"`
	CategoryID  *uuid.UUID              `gorm:"type:uuid" json:"category_id,omitempty"`
	Name        string                  `gorm:"type:text;not null" json:"name"`
	Title       *string                 `gorm:"type:varchar(500)" json:"title,omitempty"`
	Description DescriptionJSON         `gorm:"type:jsonb;not null;default:'{}'" json:"description"`
	AddressRaw  string                  `gorm:"type:text;not null" json:"address_raw"`
	Lat         float64                 `gorm:"type:double precision;not null" json:"lat"`
	Lng         float64                 `gorm:"type:double precision;not null" json:"lng"`
	Images      PlaceImages             `gorm:"type:jsonb;not null;default:'[]'" json:"images"`
	Status      string                  `gorm:"type:varchar(50);not null" json:"status"`
	Metadata    PlaceMetadata           `gorm:"type:jsonb;not null;default:'{}'" json:"metadata"`
	CreatedAt   time.Time               `gorm:"autoCreateTime" json:"created_at"`
	UpdatedAt   time.Time               `gorm:"autoUpdateTime" json:"updated_at"`
	Division    *AdministrativeDivision `gorm:"foreignKey:DivisionID" json:"division,omitempty"`
	Category    *Category               `gorm:"foreignKey:CategoryID" json:"category,omitempty"`
}

func (Place) TableName() string {
	return "places"
}

// Validate PlaceImage struct
func (img *PlaceImage) Validate() error {
	if img.ImageURL == "" {
		return errors.New("image_url cannot be empty")
	}
	return nil
}

// Validate PlaceMetadata struct
func (m *PlaceMetadata) Validate() error {
	for i, info := range m.Infomations {
		if info.Label == "" {
			return fmt.Errorf("metadata info at index %d label cannot be empty", i)
		}
	}
	return nil
}
