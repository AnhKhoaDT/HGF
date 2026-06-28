package handlers

import (
	"fmt"
	"net/http"
	"path/filepath"
	"time"

	"github.com/TranVinhHien/sol-bet88.git/internal/handlers/dto"
	"github.com/TranVinhHien/sol-bet88.git/internal/services"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type UploadHandler struct {
	uploadService *services.UploadService
}

func NewUploadHandler(uploadService *services.UploadService) *UploadHandler {
	return &UploadHandler{uploadService: uploadService}
}

// UploadImage godoc
// @Summary Upload an image to AWS S3
// @Description Uploads an image, checks user authorization, and returns the static S3 URL
// @Tags upload
// @Accept multipart/form-data
// @Produce json
// @Param image formData file true "Image file to upload"
// @Success 200 {object} dto.SuccessResponse
// @Failure 400 {object} dto.ErrorResponse
// @Failure 401 {object} dto.ErrorResponse
// @Failure 500 {object} dto.ErrorResponse
// @Router /upload [post]
func (h *UploadHandler) UploadImage(c *gin.Context) {
	// 1. Retrieve file from form
	fileHeader, err := c.FormFile("file")
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{
			Status: false,
			Errors: "file field is required",
		})
		return
	}

	// 1. Open the file
	file, err := fileHeader.Open()
	if err != nil {
		c.JSON(http.StatusInternalServerError, dto.ErrorResponse{
			Status: false,
			Errors: fmt.Sprintf("failed to open file: %v", err),
		})
		return
	}
	defer file.Close()

	// 2. Generate unique object key (e.g. media-dev/<timestamp>_<unique>.<ext>)
	ext := filepath.Ext(fileHeader.Filename)
	uniqueID := uuid.New().String()
	timestamp := time.Now().UnixNano()
	objectKey := fmt.Sprintf("media-dev/%d_%s%s", timestamp, uniqueID, ext)

	// 3. Upload using the service
	staticURL, err := h.uploadService.UploadImage(c.Request.Context(), file, objectKey)
	if err != nil {
		c.JSON(http.StatusInternalServerError, dto.ErrorResponse{
			Status: false,
			Errors: fmt.Sprintf("failed to upload image: %v", err),
		})
		return
	}

	// 4. Return response
	c.JSON(http.StatusOK, dto.SuccessResponse{
		Status:  true,
		Message: "Image uploaded successfully",
		Data: gin.H{
			"url": staticURL,
		},
	})
}
