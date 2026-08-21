package dto

import (
	"github.com/TranVinhHien/sol-bet88.git/internal/models"
	"github.com/google/uuid"
)

// AdministrativeDivisionQuery filters
type AdministrativeDivisionQuery struct {
	Page     int                  `form:"page,default=1"`
	Limit    int                  `form:"limit,default=10"`
	Query    string               `form:"query"`
	Level    models.DivisionLevel `form:"level"`
	ParentID *uuid.UUID           `form:"parent_id"`
	Status   string               `form:"status"`
}

// CreateAdministrativeDivisionReq payload
type CreateAdministrativeDivisionReq struct {
	ParentID *uuid.UUID           `json:"parent_id"`
	Level    models.DivisionLevel `json:"level" binding:"required"`
	Name     string               `json:"name" binding:"required,max=50"`
	Status   string               `json:"status" binding:"required"`
}

// UpdateAdministrativeDivisionReq payload
type UpdateAdministrativeDivisionReq struct {
	ParentID *uuid.UUID           `json:"parent_id"`
	Level    models.DivisionLevel `json:"level"`
	Name     string               `json:"name" binding:"max=50"`
	Status   string               `json:"status"`
}
