import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations_vi.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/widgets.dart';

class TripsPage extends StatelessWidget {
  const TripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      maxContentWidth: 720,
      appBar: AppBar(
        title: const Text(AppLocalizationsVi.tripsTitle, style: AppTextStyles.h2),
        elevation: 0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: const BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.map_rounded,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            AppSpacing.gapLg,
            const Text(
              AppLocalizationsVi.tripsEmpty,
              style: AppTextStyles.h3,
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapSm,
            Text(
              AppLocalizationsVi.tripsEmptyDesc,
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapXl,
            AppButton(
              text: AppLocalizationsVi.homeCreateTrip,
              icon: const Icon(Icons.auto_awesome_rounded),
              onPressed: () {
                showAppSnackBar(context, AppLocalizationsVi.homeFeatureInDev);
              },
            ),
          ],
        ),
      ),
    );
  }
}
