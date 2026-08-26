package handlers

import (
	"errors"
	"net/http"

	"github.com/TranVinhHien/sol-bet88.git/internal/handlers/dto"
	"github.com/TranVinhHien/sol-bet88.git/internal/services"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type ItineraryHandler struct {
	service services.IItineraryService
}

func NewItineraryHandler(service services.IItineraryService) *ItineraryHandler {
	return &ItineraryHandler{service: service}
}

func (h *ItineraryHandler) CreateItinerary(c *gin.Context) {
	userIDStr, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, dto.ErrorResponse{Status: false, Errors: "unauthorized"})
		return
	}
	userID, err := uuid.Parse(userIDStr.(string))
	if err != nil {
		c.JSON(http.StatusUnauthorized, dto.ErrorResponse{Status: false, Errors: "invalid user id"})
		return
	}

	var req dto.CreateItineraryReq
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	itinerary, err := h.service.CreateItinerary(c.Request.Context(), userID, req)
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	c.JSON(http.StatusCreated, dto.SuccessResponse{Status: true, Data: itinerary})
}

func (h *ItineraryHandler) GetItinerary(c *gin.Context) {
	id, err := uuid.Parse(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Status: false, Errors: "invalid uuid"})
		return
	}

	itinerary, err := h.service.GetItineraryByID(c.Request.Context(), id)
	if err != nil {
		status := http.StatusInternalServerError
		if errors.Is(err, services.ErrNotFound) {
			status = http.StatusNotFound
		}
		c.JSON(status, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	c.JSON(http.StatusOK, dto.SuccessResponse{Status: true, Data: itinerary})
}

func (h *ItineraryHandler) ListItineraries(c *gin.Context) {
	var query dto.ItineraryQuery
	if err := c.ShouldBindQuery(&query); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	itineraries, total, err := h.service.ListItineraries(c.Request.Context(), query)
	if err != nil {
		c.JSON(http.StatusInternalServerError, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	c.JSON(http.StatusOK, dto.SuccessResponse{
		Status: true,
		Data: gin.H{
			"items": itineraries,
			"pagination": dto.PaginationResponse{
				Total: total,
				Page:  query.Page,
				Limit: query.Limit,
			},
		},
	})
}

func (h *ItineraryHandler) UpdateItinerary(c *gin.Context) {
	userIDStr, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, dto.ErrorResponse{Status: false, Errors: "unauthorized"})
		return
	}
	userID, err := uuid.Parse(userIDStr.(string))
	if err != nil {
		c.JSON(http.StatusUnauthorized, dto.ErrorResponse{Status: false, Errors: "invalid user id"})
		return
	}

	id, err := uuid.Parse(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Status: false, Errors: "invalid uuid"})
		return
	}

	var req dto.UpdateItineraryReq
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	itinerary, err := h.service.UpdateItinerary(c.Request.Context(), id, userID, req)
	if err != nil {
		status := http.StatusInternalServerError
		if errors.Is(err, services.ErrNotFound) {
			status = http.StatusNotFound
		}
		c.JSON(status, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	c.JSON(http.StatusOK, dto.SuccessResponse{Status: true, Data: itinerary})
}

func (h *ItineraryHandler) DeleteItinerary(c *gin.Context) {
	userIDStr, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, dto.ErrorResponse{Status: false, Errors: "unauthorized"})
		return
	}
	userID, err := uuid.Parse(userIDStr.(string))
	if err != nil {
		c.JSON(http.StatusUnauthorized, dto.ErrorResponse{Status: false, Errors: "invalid user id"})
		return
	}

	id, err := uuid.Parse(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Status: false, Errors: "invalid uuid"})
		return
	}

	err = h.service.DeleteItinerary(c.Request.Context(), id, userID)
	if err != nil {
		status := http.StatusInternalServerError
		if errors.Is(err, services.ErrNotFound) {
			status = http.StatusNotFound
		}
		c.JSON(status, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	c.JSON(http.StatusOK, dto.SuccessResponse{Status: true, Message: "itinerary deleted successfully"})
}
