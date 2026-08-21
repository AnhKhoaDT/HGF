import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: ColoredBox(
              color: AppColors.overlayDark,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
          ),
      ],
    );
  }
}

enum ToastStatus {
  success,
  error,
  warning,
  info,
}

void showAppSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
  ToastStatus? status,
  IconData? icon,
}) {
  final toastStatus = status ?? (isError ? ToastStatus.error : ToastStatus.success);

  Color bgColor;
  IconData defaultIcon;

  switch (toastStatus) {
    case ToastStatus.success:
      bgColor = AppColors.success;
      defaultIcon = Icons.check_circle_outline_rounded;
      break;
    case ToastStatus.error:
      bgColor = AppColors.error;
      defaultIcon = Icons.error_outline_rounded;
      break;
    case ToastStatus.warning:
      bgColor = AppColors.warning;
      defaultIcon = Icons.warning_amber_rounded;
      break;
    case ToastStatus.info:
      bgColor = AppColors.info;
      defaultIcon = Icons.info_outline_rounded;
      break;
  }

  final selectedIcon = icon ?? defaultIcon;
  final mediaQuery = MediaQuery.of(context);
  final topPadding = mediaQuery.padding.top + 12;
  final screenHeight = mediaQuery.size.height;

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(selectedIcon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: screenHeight - topPadding - 65,
          left: 16,
          right: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
}
