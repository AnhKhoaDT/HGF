package dto

// CategoryQuery filters
type CategoryQuery struct {
	Page   int    `form:"page,default=1"`
	Limit  int    `form:"limit,default=10"`
	Query  string `form:"query"`
	Status string `form:"status"`
}

// CreateCategoryReq payload
type CreateCategoryReq struct {
	Name    string  `json:"name" binding:"required,max=50"`
	Status  string  `json:"status" binding:"required"`
	IconURL *string `json:"icon_url"`
}

// UpdateCategoryReq payload
type UpdateCategoryReq struct {
	Name    string  `json:"name" binding:"max=50"`
	Status  string  `json:"status"`
	IconURL *string `json:"icon_url"`
}
