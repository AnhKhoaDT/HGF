import 'package:equatable/equatable.dart';

class AppSettingsEntity extends Equatable {
  final bool enableVipSystem;
  final int monthlyVipPrice;
  final int yearlyVipPrice;
  final int yearlyDiscountPercent;
  final String currency;
  final Map<String, int> levelThresholds;
  final Map<String, int> xpRewards;

  const AppSettingsEntity({
    required this.enableVipSystem,
    required this.monthlyVipPrice,
    required this.yearlyVipPrice,
    required this.yearlyDiscountPercent,
    required this.currency,
    required this.levelThresholds,
    required this.xpRewards,
  });

  factory AppSettingsEntity.defaultSettings() {
    return const AppSettingsEntity(
      enableVipSystem: true,
      monthlyVipPrice: 49000,
      yearlyVipPrice: 399000,
      yearlyDiscountPercent: 32,
      currency: 'VND',
      levelThresholds: {
        'explorer': 1000,
        'gem_hunter': 5000,
        'discovery_master': 20000,
        'legend': 50000,
      },
      xpRewards: {
        'checkin': 50,
        'review': 30,
        'create_itinerary': 100,
        'daily_streak': 10,
      },
    );
  }

  @override
  List<Object?> get props => [
        enableVipSystem,
        monthlyVipPrice,
        yearlyVipPrice,
        yearlyDiscountPercent,
        currency,
        levelThresholds,
        xpRewards,
      ];
}
