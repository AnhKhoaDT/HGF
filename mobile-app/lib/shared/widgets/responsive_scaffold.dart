import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';

/// Scaffold dùng chung cho Web & Mobile.
///
/// - Trên mobile: nội dung chiếm toàn bộ chiều rộng.
/// - Trên web/màn hình rộng: nội dung được canh giữa và giới hạn bề rộng
///   ([maxContentWidth]) để dễ đọc, phần nền hai bên dùng màu nền chung.
class ResponsiveScaffold extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final double maxContentWidth;

  /// Bọc [child] trong SafeArea (mặc định true).
  final bool useSafeArea;

  const ResponsiveScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.backgroundColor,
    this.maxContentWidth = AppSizes.maxContentWidth,
    this.useSafeArea = true,
  });

  /// Tiện ích: màn hình hiện tại có được coi là "rộng" (web/desktop/tablet)?
  static bool isWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= AppSizes.wideBreakpoint;

  @override
  Widget build(BuildContext context) {
    final wide = isWide(context);

    Widget content = child;
    if (wide) {
      content = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: content,
        ),
      );
    }
    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.background,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: content,
    );
  }
}
