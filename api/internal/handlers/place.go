package handlers

import (
	"errors"
	"net/http"

	"github.com/TranVinhHien/sol-bet88.git/internal/handlers/dto"
	"github.com/TranVinhHien/sol-bet88.git/internal/services"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type PlaceHandler struct {
	service services.IPlaceService
}

func NewPlaceHandler(service services.IPlaceService) *PlaceHandler {
	return &PlaceHandler{service: service}
}

func (h *PlaceHandler) CreatePlace(c *gin.Context) {
	var req dto.CreatePlaceReq
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	p, err := h.service.CreatePlace(c.Request.Context(), req)
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	c.JSON(http.StatusCreated, dto.SuccessResponse{Status: true, Data: p})
}

func (h *PlaceHandler) GetPlace(c *gin.Context) {
	id, err := uuid.Parse(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Status: false, Errors: "invalid uuid"})
		return
	}

	p, err := h.service.GetPlaceByID(c.Request.Context(), id)
	if err != nil {
		status := http.StatusInternalServerError
		if errors.Is(err, services.ErrNotFound) {
			status = http.StatusNotFound
		}
		c.JSON(status, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	c.JSON(http.StatusOK, dto.SuccessResponse{Status: true, Data: p})
}

func (h *PlaceHandler) ListPlaces(c *gin.Context) {
	var query dto.PlaceQuery
	if err := c.ShouldBindQuery(&query); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	places, total, err := h.service.ListPlaces(c.Request.Context(), query)
	if err != nil {
		c.JSON(http.StatusInternalServerError, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	c.JSON(http.StatusOK, dto.SuccessResponse{
		Status: true,
		Data: gin.H{
			"items": places,
			"pagination": dto.PaginationResponse{
				Total: total,
				Page:  query.Page,
				Limit: query.Limit,
			},
		},
	})
}

func (h *PlaceHandler) UpdatePlace(c *gin.Context) {
	id, err := uuid.Parse(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Status: false, Errors: "invalid uuid"})
		return
	}

	var req dto.UpdatePlaceReq
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	p, err := h.service.UpdatePlace(c.Request.Context(), id, req)
	if err != nil {
		status := http.StatusInternalServerError
		if errors.Is(err, services.ErrNotFound) {
			status = http.StatusNotFound
		}
		c.JSON(status, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	c.JSON(http.StatusOK, dto.SuccessResponse{Status: true, Data: p})
}

func (h *PlaceHandler) DeletePlace(c *gin.Context) {
	id, err := uuid.Parse(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Status: false, Errors: "invalid uuid"})
		return
	}

	err = h.service.DeletePlace(c.Request.Context(), id)
	if err != nil {
		status := http.StatusInternalServerError
		if errors.Is(err, services.ErrNotFound) {
			status = http.StatusNotFound
		}
		c.JSON(status, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	c.JSON(http.StatusOK, dto.SuccessResponse{Status: true, Message: "place deleted successfully"})
}
