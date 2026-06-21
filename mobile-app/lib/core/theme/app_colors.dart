import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color brandPrimary = Color(0xFF16B075);
  static const Color brandLight = Color(0xFF3BCB92);
  static const Color brandDark = Color(0xFF0B8E5C);
  static const Color brandLighter = Color(0xFF72E2B3);
  static const Color brandDarker = Color(0xFF0A714C);

  static const Color darkBackground = Color(0xFFF5F7FA);
  static const Color darkSurface = Color(0xFFFFFFFF);
  static const Color darkCard = Color(0xFFF8F9FB);
  static const Color darkBorder = Color(0xFFCBD5E0);

  static const Color textPrimary = Color(0xFF1A202C);
  static const Color textSecondary = Color(0xFF4A5568);
  static const Color textTertiary = Color(0xFF718096);
  static const Color textDisabled = Color(0xFFA0AEC0);

  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  static const LinearGradient brandGradient = LinearGradient(
    colors: [brandLight, Color(0xFF10B981), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFFFAFBFC), darkBackground, Color(0xFFF0F4F8)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Color overlayLight = Color(0x0D000000);
  static const Color overlayMedium = Color(0x1A000000);
  static const Color overlayDark = Color(0x40000000);

  static const Color shadowBrand = Color(0x1A16B075);
  static const Color shadowDark = Color(0x0A000000);

  static const Color socialButtonBg = Color(0xFFFFFFFF);
  static const Color googleBlue = Color(0xFF4285F4);
}

extension AppColorsExtension on BuildContext {
  AppColors get colors => AppColors._();
}
