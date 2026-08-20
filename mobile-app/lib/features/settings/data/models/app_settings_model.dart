import '../../domain/entities/app_settings_entity.dart';

class AppSettingsModel extends AppSettingsEntity {
  const AppSettingsModel({
    required super.enableVipSystem,
    required super.monthlyVipPrice,
    required super.yearlyVipPrice,
    required super.yearlyDiscountPercent,
    required super.currency,
    required super.levelThresholds,
    required super.xpRewards,
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    final thresholdsRaw = json['level_thresholds'] as Map<String, dynamic>? ?? {};
    final rewardsRaw = json['xp_rewards'] as Map<String, dynamic>? ?? {};

    return AppSettingsModel(
      enableVipSystem: json['enable_vip_system'] ?? true,
      monthlyVipPrice: json['monthly_vip_price'] ?? 49000,
      yearlyVipPrice: json['yearly_vip_price'] ?? 399000,
      yearlyDiscountPercent: json['yearly_discount_percent'] ?? 32,
      currency: json['currency'] ?? 'VND',
      levelThresholds: thresholdsRaw.map((k, v) => MapEntry(k, (v as num).toInt())),
      xpRewards: rewardsRaw.map((k, v) => MapEntry(k, (v as num).toInt())),
    );
  }
}
