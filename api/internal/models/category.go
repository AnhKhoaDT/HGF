package models

import (
	"github.com/google/uuid"
)

// Category model mapping to categories table
type Category struct {
	ID      uuid.UUID `gorm:"type:uuid;primaryKey;default:uuid_generate_v4()" json:"id"`
	Name    string    `gorm:"type:varchar(50)" json:"name"`
	Status  string    `gorm:"type:varchar(50);not null" json:"status"`
	IconURL *string   `gorm:"type:varchar(500)" json:"icon_url,omitempty"`
}

func (Category) TableName() string {
	return "categories"
}
