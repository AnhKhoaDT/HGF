package handlers

import (
	"errors"
	"net/http"

	"github.com/TranVinhHien/sol-bet88.git/internal/handlers/dto"
	"github.com/TranVinhHien/sol-bet88.git/internal/services"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type CategoryHandler struct {
	service services.ICategoryService
}

func NewCategoryHandler(service services.ICategoryService) *CategoryHandler {
	return &CategoryHandler{service: service}
}

func (h *CategoryHandler) CreateCategory(c *gin.Context) {
	var req dto.CreateCategoryReq
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	cat, err := h.service.CreateCategory(c.Request.Context(), req)
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	c.JSON(http.StatusCreated, dto.SuccessResponse{Status: true, Data: cat})
}

func (h *CategoryHandler) GetCategory(c *gin.Context) {
	id, err := uuid.Parse(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Status: false, Errors: "invalid uuid"})
		return
	}

	cat, err := h.service.GetCategoryByID(c.Request.Context(), id)
	if err != nil {
		status := http.StatusInternalServerError
		if errors.Is(err, services.ErrNotFound) {
			status = http.StatusNotFound
		}
		c.JSON(status, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	c.JSON(http.StatusOK, dto.SuccessResponse{Status: true, Data: cat})
}

func (h *CategoryHandler) ListCategories(c *gin.Context) {
	var query dto.CategoryQuery
	if err := c.ShouldBindQuery(&query); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	categories, total, err := h.service.ListCategories(c.Request.Context(), query)
	if err != nil {
		c.JSON(http.StatusInternalServerError, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	c.JSON(http.StatusOK, dto.SuccessResponse{
		Status: true,
		Data: gin.H{
			"items": categories,
			"pagination": dto.PaginationResponse{
				Total: total,
				Page:  query.Page,
				Limit: query.Limit,
			},
		},
	})
}

func (h *CategoryHandler) UpdateCategory(c *gin.Context) {
	id, err := uuid.Parse(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Status: false, Errors: "invalid uuid"})
		return
	}

	var req dto.UpdateCategoryReq
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	cat, err := h.service.UpdateCategory(c.Request.Context(), id, req)
	if err != nil {
		status := http.StatusInternalServerError
		if errors.Is(err, services.ErrNotFound) {
			status = http.StatusNotFound
		}
		c.JSON(status, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	c.JSON(http.StatusOK, dto.SuccessResponse{Status: true, Data: cat})
}

func (h *CategoryHandler) DeleteCategory(c *gin.Context) {
	id, err := uuid.Parse(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Status: false, Errors: "invalid uuid"})
		return
	}

	err = h.service.DeleteCategory(c.Request.Context(), id)
	if err != nil {
		status := http.StatusInternalServerError
		if errors.Is(err, services.ErrNotFound) {
			status = http.StatusNotFound
		}
		c.JSON(status, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	c.JSON(http.StatusOK, dto.SuccessResponse{Status: true, Message: "category deleted successfully"})
}
