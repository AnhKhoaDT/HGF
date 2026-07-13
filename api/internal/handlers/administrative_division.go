package handlers

import (
	"errors"
	"net/http"

	"github.com/TranVinhHien/sol-bet88.git/internal/handlers/dto"
	"github.com/TranVinhHien/sol-bet88.git/internal/services"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type AdministrativeDivisionHandler struct {
	service services.IAdministrativeDivisionService
}

func NewAdministrativeDivisionHandler(service services.IAdministrativeDivisionService) *AdministrativeDivisionHandler {
	return &AdministrativeDivisionHandler{service: service}
}

func (h *AdministrativeDivisionHandler) CreateDivision(c *gin.Context) {
	var req dto.CreateAdministrativeDivisionReq
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	div, err := h.service.CreateDivision(c.Request.Context(), req)
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	c.JSON(http.StatusCreated, dto.SuccessResponse{Status: true, Data: div})
}

func (h *AdministrativeDivisionHandler) GetDivision(c *gin.Context) {
	id, err := uuid.Parse(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Status: false, Errors: "invalid uuid"})
		return
	}

	div, err := h.service.GetDivisionByID(c.Request.Context(), id)
	if err != nil {
		status := http.StatusInternalServerError
		if errors.Is(err, services.ErrNotFound) {
			status = http.StatusNotFound
		}
		c.JSON(status, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	c.JSON(http.StatusOK, dto.SuccessResponse{Status: true, Data: div})
}

func (h *AdministrativeDivisionHandler) ListDivisions(c *gin.Context) {
	var query dto.AdministrativeDivisionQuery
	if err := c.ShouldBindQuery(&query); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	divisions, total, err := h.service.ListDivisions(c.Request.Context(), query)
	if err != nil {
		c.JSON(http.StatusInternalServerError, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	c.JSON(http.StatusOK, dto.SuccessResponse{
		Status: true,
		Data: gin.H{
			"items": divisions,
			"pagination": dto.PaginationResponse{
				Total: total,
				Page:  query.Page,
				Limit: query.Limit,
			},
		},
	})
}

func (h *AdministrativeDivisionHandler) UpdateDivision(c *gin.Context) {
	id, err := uuid.Parse(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Status: false, Errors: "invalid uuid"})
		return
	}

	var req dto.UpdateAdministrativeDivisionReq
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	div, err := h.service.UpdateDivision(c.Request.Context(), id, req)
	if err != nil {
		status := http.StatusInternalServerError
		if errors.Is(err, services.ErrNotFound) {
			status = http.StatusNotFound
		}
		c.JSON(status, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	c.JSON(http.StatusOK, dto.SuccessResponse{Status: true, Data: div})
}

func (h *AdministrativeDivisionHandler) DeleteDivision(c *gin.Context) {
	id, err := uuid.Parse(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Status: false, Errors: "invalid uuid"})
		return
	}

	err = h.service.DeleteDivision(c.Request.Context(), id)
	if err != nil {
		status := http.StatusInternalServerError
		if errors.Is(err, services.ErrNotFound) {
			status = http.StatusNotFound
		}
		c.JSON(status, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	c.JSON(http.StatusOK, dto.SuccessResponse{Status: true, Message: "administrative division deleted successfully"})
}
