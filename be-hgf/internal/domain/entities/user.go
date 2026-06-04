package entities

import (
	"time"

	"github.com/google/uuid"
)

type User struct {
	ID           uuid.UUID  `json:"id" gorm:"type:uuid;primary_key;default:gen_random_uuid()"`
	Username     string     `json:"username" gorm:"type:varchar(50);not null"`
	Email        string     `json:"email" gorm:"type:varchar(100);not null"`
	PasswordHash string     `json:"-" gorm:"type:varchar(255);not null"`
	AvatarURL    *string    `json:"avatar_url" gorm:"type:text"`
	ExpPoints    int        `json:"exp_points" gorm:"default:0"`
	Level        int        `json:"level" gorm:"default:1"`
	LevelTitle   string     `json:"level_title" gorm:"type:varchar(100);default:'Nhà Thám Hiểm'"`
	IsActive     bool       `json:"is_active" gorm:"default:true"`
	LastLoginAt  *time.Time `json:"last_login_at"`
	CreatedAt    time.Time  `json:"created_at" gorm:"autoCreateTime"`
	UpdatedAt    time.Time  `json:"updated_at" gorm:"autoUpdateTime"`
}

func (User) TableName() string {
	return "users"
}

// GetLevelTitle returns title based on level
func (u *User) GetLevelTitle() string {
	switch {
	case u.Level >= 50:
		return "Huyền Thoại Thám Hiểm"
	case u.Level >= 40:
		return "Bậc Thầy Săn Gem"
	case u.Level >= 30:
		return "Thợ Săn Quán Ẩn"
	case u.Level >= 20:
		return "Chuyên Gia Khám Phá"
	case u.Level >= 10:
		return "Nhà Thám Hiểm Kỳ Cựu"
	case u.Level >= 5:
		return "Thám Hiểm Viên"
	default:
		return "Nhà Thám Hiểm"
	}
}

// AddExp adds exp points and updates level
func (u *User) AddExp(points int) {
	u.ExpPoints += points
	u.UpdateLevel()
}

// UpdateLevel calculates level: Level = (ExpPoints / 100) + 1
func (u *User) UpdateLevel() {
	newLevel := (u.ExpPoints / 100) + 1
	if newLevel > u.Level {
		u.Level = newLevel
		u.LevelTitle = u.GetLevelTitle()
	}
}
