package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/TranVinhHien/sol-bet88.git/internal/handlers/dto"
	"github.com/TranVinhHien/sol-bet88.git/internal/services"
)

type SettingHandler struct {
	settingService services.SettingService
}

func NewSettingHandler(settingService services.SettingService) *SettingHandler {
	return &SettingHandler{
		settingService: settingService,
	}
}

// GetSettings godoc
// @Summary Get system settings
// @Description Returns dynamic system configurations including VIP system status, pricing, and XP rules
// @Tags settings
// @Produce json
// @Success 200 {object} dto.SuccessResponse
// @Router /api/settings [get]
func (h *SettingHandler) GetSettings(c *gin.Context) {
	settings := h.settingService.GetSystemSettings()

	c.JSON(http.StatusOK, dto.SuccessResponse{
		Status: true,
		Data:   settings,
	})
}
