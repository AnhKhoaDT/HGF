package handlers

import (
	"net/http"

	"github.com/TranVinhHien/sol-bet88.git/internal/handlers/dto"
	"github.com/TranVinhHien/sol-bet88.git/internal/services"
	"github.com/gin-gonic/gin"
)

type HomeOverviewHandler struct {
	service services.IHomeService
}

func NewHomeOverviewHandler(service services.IHomeService) *HomeOverviewHandler {
	return &HomeOverviewHandler{service: service}
}

func (h *HomeOverviewHandler) GetOverview(c *gin.Context) {
	result, err := h.service.GetOverview(c.Request.Context())
	if err != nil {
		c.JSON(http.StatusInternalServerError, dto.ErrorResponse{Status: false, Errors: err.Error()})
		return
	}

	c.JSON(http.StatusOK, dto.SuccessResponse{Status: true, Data: result})
}
