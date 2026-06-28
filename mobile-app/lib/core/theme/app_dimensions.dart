import 'package:flutter/widgets.dart';

/// Khoảng cách, bo góc, kích thước dùng chung cho Web & Mobile.
class AppSpacing {
  AppSpacing._();

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // Khoảng cách dạng SizedBox dựng sẵn (đỡ phải gõ lại)
  static const SizedBox gapXxs = SizedBox(height: xxs, width: xxs);
  static const SizedBox gapXs = SizedBox(height: xs, width: xs);
  static const SizedBox gapSm = SizedBox(height: sm, width: sm);
  static const SizedBox gapMd = SizedBox(height: md, width: md);
  static const SizedBox gapLg = SizedBox(height: lg, width: lg);
  static const SizedBox gapXl = SizedBox(height: xl, width: xl);
}

class AppRadius {
  AppRadius._();

  static const double sm = 10;
  static const double md = 14;
  static const double lg = 18;
  static const double xl = 24;
  static const double pill = 999;

  static const BorderRadius brSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius brMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius brLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius brXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius brPill = BorderRadius.all(Radius.circular(pill));
}

class AppSizes {
  AppSizes._();

  /// Chiều rộng tối đa của nội dung trên web (form/đăng nhập...).
  static const double maxContentWidth = 460;

  /// Ngưỡng coi là layout rộng (web/desktop/tablet).
  static const double wideBreakpoint = 720;

  static const double buttonHeight = 54;
  static const double inputHeight = 56;
  static const double iconSm = 18;
  static const double iconMd = 22;
  static const double iconLg = 28;
}
