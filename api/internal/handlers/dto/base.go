package dto

type ErrorResponse struct {
	Status bool   `json:"status"`
	Errors string `json:"errors"`
}

type SuccessResponse struct {
	Status  bool        `json:"status"`
	Data    interface{} `json:"data,omitempty"`
	Message string      `json:"message,omitempty"`
}

type BaseQuery struct {
	Page  int    `form:"page,default=1"`
	Limit int    `form:"limit,default=10"`
	Query string `form:"query"`
}
