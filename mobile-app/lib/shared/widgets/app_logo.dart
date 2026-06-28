import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';

/// Logo thương hiệu dùng chung (icon lá trong khung bo tròn + chữ TripWise).
class AppLogo extends StatelessWidget {
  final double size;
  final bool showWordmark;
  final Axis direction;

  const AppLogo({
    super.key,
    this.size = 44,
    this.showWordmark = true,
    this.direction = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    final mark = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Icon(Icons.eco_rounded, color: Colors.white, size: size * 0.56),
    );

    if (!showWordmark) return mark;

    final wordmark = RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: size * 0.5,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
        children: const [
          TextSpan(text: 'Trip'),
          TextSpan(text: 'Wise', style: TextStyle(color: AppColors.primary)),
        ],
      ),
    );

    if (direction == Axis.vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [mark, AppSpacing.gapSm, wordmark],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [mark, AppSpacing.gapSm, wordmark],
    );
  }
}
