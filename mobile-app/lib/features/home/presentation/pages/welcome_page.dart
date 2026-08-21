import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations_vi.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class WelcomePage extends StatefulWidget {
  final AuthController controller;
  const WelcomePage({super.key, required this.controller});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final isLoggedIn = await widget.controller.checkLoginStatus();
    if (!mounted) return;
    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const ResponsiveScaffold(
        useSafeArea: false,
        child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    return ResponsiveScaffold(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          children: [
            const Spacer(),
            const AppLogo(size: 84, direction: Axis.vertical),
            const SizedBox(height: AppSpacing.xl),
            const Text(
              'Lên kế hoạch du lịch\ntrong vài phút',
              textAlign: TextAlign.center,
              style: AppTextStyles.display,
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Chọn điểm đến và sở thích — TripWise gợi ý\nnhiều lịch trình tối ưu cho bạn.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge,
            ),
            const Spacer(),
            AppButton(
              text: AppLocalizationsVi.login,
              onPressed: () => Navigator.pushNamed(context, '/login'),
            ),
            AppSpacing.gapMd,
            AppButton(
              text: AppLocalizationsVi.signUp,
              variant: AppButtonVariant.outline,
              onPressed: () => Navigator.pushNamed(context, '/signup'),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
