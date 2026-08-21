package dto

type FeatureItem struct {
	Title     string `json:"title"`
	Included  bool   `json:"included"`
	Highlight bool   `json:"highlight"`
}

type SystemSettingsResponse struct {
	EnableVIPSystem       bool           `json:"enable_vip_system"`
	MonthlyVIPPrice       int            `json:"monthly_vip_price"`
	YearlyVIPPrice        int            `json:"yearly_vip_price"`
	YearlyDiscountPercent int            `json:"yearly_discount_percent"`
	Currency              string         `json:"currency"`
	LevelThresholds       map[string]int `json:"level_thresholds"`
	XPRewards             map[string]int `json:"xp_rewards"`
	FreeTierFeatures      []FeatureItem  `json:"free_tier_features"`
	VIPTierFeatures       []FeatureItem  `json:"vip_tier_features"`
}
