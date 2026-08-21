import 'package:flutter/material.dart';

/// Bảng màu dùng chung cho cả Web và Mobile.
///
/// Tông màu tự nhiên (giấy ấm + xanh rêu + đất nung) — dễ nhìn dưới ánh
/// sáng mạnh, hạn chế gradient. Mọi nơi nên dùng các tên ngữ nghĩa mới
/// (primary / secondary / surface ...). Các hằng cũ (brand*, dark*) vẫn
/// được giữ lại làm alias để không phá vỡ code hiện có.
class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------------
  // PRIMARY — Xanh rêu (màu thương hiệu)
  // ---------------------------------------------------------------------------
  static const Color primary = Color(0xFF5C7150);
  static const Color primaryDark = Color(0xFF45563C);
  static const Color primaryDarker = Color(0xFF36442F);
  static const Color primaryLight = Color(0xFF6E8560);
  static const Color primarySoft = Color(0xFFE7ECDF); // nền nhạt của primary
  static const Color onPrimary = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------------------
  // SECONDARY — Đất nung (màu nhấn/hành động)
  // ---------------------------------------------------------------------------
  static const Color secondary = Color(0xFFB56A4A);
  static const Color secondaryDark = Color(0xFF9E5A3D);
  static const Color secondaryLight = Color(0xFFC9866A);
  static const Color secondarySoft = Color(0xFFF3E2D8); // nền nhạt của secondary
  static const Color onSecondary = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------------------
  // TERTIARY & ACCENT — Xanh biển trầm + Vàng nắng
  // ---------------------------------------------------------------------------
  static const Color tertiary = Color(0xFF5A7D8C);
  static const Color tertiarySoft = Color(0xFFE0E8EA);
  static const Color accent = Color(0xFFC79A3F);
  static const Color accentSoft = Color(0xFFF3E9D2);

  // ---------------------------------------------------------------------------
  // NEUTRALS — Nền giấy ấm
  // ---------------------------------------------------------------------------
  static const Color background = Color(0xFFF4EFE6);
  static const Color backgroundAlt = Color(0xFFECE4D6);
  static const Color surface = Color(0xFFFBF8F2);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFDDD4C4);
  static const Color divider = Color(0xFFE5DDCF);

  // ---------------------------------------------------------------------------
  // TEXT — Mực ấm
  // ---------------------------------------------------------------------------
  static const Color textPrimary = Color(0xFF2F342E);
  static const Color textSecondary = Color(0xFF5B6157);
  static const Color textTertiary = Color(0xFF868C7C);
  static const Color textDisabled = Color(0xFFB3B6AB);

  // ---------------------------------------------------------------------------
  // TRẠNG THÁI
  // ---------------------------------------------------------------------------
  static const Color success = Color(0xFF4F7A52);
  static const Color error = Color(0xFFC0503F);
  static const Color warning = Color(0xFFC79A3F);
  static const Color info = Color(0xFF5A7D8C);

  // ---------------------------------------------------------------------------
  // OVERLAY & SHADOW
  // ---------------------------------------------------------------------------
  static const Color overlayLight = Color(0x0D2F342E);
  static const Color overlayMedium = Color(0x1A2F342E);
  static const Color overlayDark = Color(0x66201D17);
  static const Color shadowSoft = Color(0x14403728);
  static const Color shadowMedium = Color(0x1F403728);

  // ---------------------------------------------------------------------------
  // MISC
  // ---------------------------------------------------------------------------
  static const Color socialButtonBg = Color(0xFFFFFFFF);
  static const Color googleBlue = Color(0xFF4285F4);

  // ---------------------------------------------------------------------------
  // GRADIENT — giữ lại để tương thích; dùng rất hạn chế, tông gần phẳng.
  // ---------------------------------------------------------------------------
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [surface, background],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ===========================================================================
  // ALIAS TƯƠNG THÍCH NGƯỢC (code cũ vẫn biên dịch được)
  // ===========================================================================
  static const Color brandPrimary = primary;
  static const Color brandLight = primaryLight;
  static const Color brandDark = primaryDark;
  static const Color brandLighter = Color(0xFF8AA07C);
  static const Color brandDarker = primaryDarker;

  static const Color darkBackground = background;
  static const Color darkSurface = card;
  static const Color darkCard = background;
  static const Color darkBorder = border;

  static const Color shadowBrand = shadowSoft;
  static const Color shadowDark = shadowSoft;

  static const LinearGradient brandGradient = primaryGradient;
  static const LinearGradient darkGradient = surfaceGradient;
}

extension AppColorsExtension on BuildContext {
  AppColors get colors => AppColors._();
}
