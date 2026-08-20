package services

import "github.com/TranVinhHien/sol-bet88.git/internal/handlers/dto"

type SettingService interface {
	GetSystemSettings() dto.SystemSettingsResponse
}

type settingService struct{}

func NewSettingService() SettingService {
	return &settingService{}
}

func (s *settingService) GetSystemSettings() dto.SystemSettingsResponse {
	return dto.SystemSettingsResponse{
		EnableVIPSystem:       true,
		MonthlyVIPPrice:       49000,
		YearlyVIPPrice:        399000,
		YearlyDiscountPercent: 32,
		Currency:              "VND",
		LevelThresholds: map[string]int{
			"explorer":         1000,
			"gem_hunter":       5000,
			"discovery_master": 20000,
			"legend":           50000,
		},
		XPRewards: map[string]int{
			"checkin":          50,
			"review":           30,
			"create_itinerary": 100,
			"daily_streak":     10,
		},
		FreeTierFeatures: []dto.FeatureItem{
			{Title: "Tạo tối đa 3 lịch trình AI/tháng", Included: true, Highlight: false},
			{Title: "Xuất lịch trình dạng PDF cơ bản", Included: true, Highlight: false},
			{Title: "Tích lũy 1x điểm kinh nghiệm (XP)", Included: true, Highlight: false},
			{Title: "Xem ưu đãi đối tác phổ thông", Included: true, Highlight: false},
			{Title: "Không giới hạn tạo lịch trình AI", Included: false, Highlight: false},
			{Title: "Tích lũy x2 điểm kinh nghiệm (XP)", Included: false, Highlight: false},
		},
		VIPTierFeatures: []dto.FeatureItem{
			{Title: "Không giới hạn tạo lịch trình AI thông minh", Included: true, Highlight: true},
			{Title: "Xuất lịch trình nâng cao (PDF & Google Calendar)", Included: true, Highlight: true},
			{Title: "Tích lũy x2 điểm kinh nghiệm (XP) tăng cấp nhanh", Included: true, Highlight: true},
			{Title: "Voucher ưu đãi độc quyền từ đối tác cao cấp", Included: true, Highlight: true},
			{Title: "Trợ lý AI hỗ trợ ưu tiên 24/7", Included: true, Highlight: true},
			{Title: "Trải nghiệm ứng dụng hoàn toàn không quảng cáo", Included: true, Highlight: true},
		},
	}
}
