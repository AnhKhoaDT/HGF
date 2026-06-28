package dto

type RegisterRequest struct {
	Email       string   `json:"email" binding:"required,email"`
	Password    string   `json:"password" binding:"required,min=6"`
	FullName    string   `json:"full_name" binding:"required"`
	AvatarURL   *string  `json:"avatar_url"`
	PhoneNumber *string  `json:"phone_number"`
	HomeAddress *string  `json:"home_address"`
	CurrentLat  *float64 `json:"current_lat"`
	CurrentLng  *float64 `json:"current_lng"`
}

type LoginRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required"`
}

type RefreshTokenRequest struct {
	RefreshToken string `json:"refresh_token" binding:"required"`
}

type LogoutRequest struct {
	RefreshToken string `json:"refresh_token" binding:"required"`
}

type UpdateProfileRequest struct {
	FullName    *string `json:"full_name"`
	PhoneNumber *string `json:"phone_number"`
	HomeAddress *string `json:"home_address"`
	AvatarURL   *string `json:"avatar_url"`
}

type UpdatePasswordRequest struct {
	OldPassword string `json:"old_password" binding:"required"`
	NewPassword string `json:"new_password" binding:"required,min=6"`
}
