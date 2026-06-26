import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';

enum AppButtonVariant { primary, secondary, outline, social }

/// Nút bấm dùng chung cho Web & Mobile.
///
/// - [primary]   : nền đất nung (màu hành động chính).
/// - [secondary] : nền nhạt, viền — hành động phụ.
/// - [outline]   : nền trong suốt, viền xanh rêu.
/// - [social]    : nút trắng cho đăng nhập mạng xã hội.
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonVariant variant;
  final Widget? icon;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.width,
    this.height = AppSizes.buttonHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: _style(),
        child: isLoading ? _loader() : _content(),
      ),
    );
  }

  ButtonStyle _style() {
    const shape = RoundedRectangleBorder(borderRadius: AppRadius.brMd);
    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: AppColors.onSecondary,
          disabledBackgroundColor: AppColors.secondary.withOpacity(0.5),
          elevation: 0,
          shape: shape,
        );
      case AppButtonVariant.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.primarySoft,
          foregroundColor: AppColors.primaryDark,
          disabledBackgroundColor: AppColors.primarySoft.withOpacity(0.5),
          elevation: 0,
          shape: shape,
        );
      case AppButtonVariant.outline:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primary,
          disabledBackgroundColor: Colors.transparent,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.brMd,
            side: BorderSide(color: AppColors.primary, width: 1.5),
          ),
        );
      case AppButtonVariant.social:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.card,
          foregroundColor: AppColors.textPrimary,
          disabledBackgroundColor: AppColors.card.withOpacity(0.5),
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.brMd,
            side: BorderSide(color: AppColors.border, width: 1.5),
          ),
        );
    }
  }

  Widget _loader() {
    final color = (variant == AppButtonVariant.primary)
        ? AppColors.onSecondary
        : AppColors.primary;
    return SizedBox(
      width: 22,
      height: 22,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  Widget _content() {
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          AppSpacing.gapSm,
          Text(text, style: AppTextStyles.button),
        ],
      );
    }
    return Text(text, style: AppTextStyles.button);
  }
}

/// Nút dạng text (link) dùng chung.
class AppTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final FontWeight fontWeight;
  final double fontSize;

  const AppTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color,
    this.fontWeight = FontWeight.w700,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color ?? AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: const Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
      ),
    );
  }
}
