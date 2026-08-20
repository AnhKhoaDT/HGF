import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations_vi.dart';
import '../../../../core/services/biometric_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class SecuritySettingsPage extends StatefulWidget {
  final AuthController controller;
  const SecuritySettingsPage({super.key, required this.controller});

  @override
  State<SecuritySettingsPage> createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends State<SecuritySettingsPage> {
  final _biometricService = BiometricService();
  bool _isBiometricEnabled = false;
  bool _isBiometricSupported = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final enabled =
        await widget.controller.apiService.isBiometricEnabled();
    final supported = await _biometricService.isBiometricAvailable();

    if (mounted) {
      setState(() {
        _isBiometricEnabled = enabled;
        _isBiometricSupported = supported;
      });
    }
  }

  Future<void> _handleToggleBiometric(bool value) async {
    if (value) {
      if (!_isBiometricSupported) {
        showAppSnackBar(
          context,
          AppLocalizationsVi.biometricNotAvailable,
          isError: true,
        );
        return;
      }

      final authenticated = await _biometricService.authenticate(
        localizedReason: AppLocalizationsVi.biometricReason,
      );

      if (!authenticated) {
        if (mounted) {
          showAppSnackBar(
            context,
            AppLocalizationsVi.biometricAuthFailed,
            isError: true,
          );
        }
        return;
      }

      await widget.controller.apiService.setBiometricEnabled(true);
      if (mounted) {
        setState(() => _isBiometricEnabled = true);
        showAppSnackBar(context, AppLocalizationsVi.biometricEnabledSuccess);
      }
    } else {
      await widget.controller.apiService.setBiometricEnabled(false);
      if (mounted) {
        setState(() => _isBiometricEnabled = false);
        showAppSnackBar(context, AppLocalizationsVi.biometricDisabledSuccess);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizationsVi.securityAndPassword, style: AppTextStyles.h3),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader('ĐĂNG NHẬP SINH TRÁC HỌC'),
            AppSpacing.gapSm,
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primary,
                secondary: const Icon(
                  Icons.fingerprint_rounded,
                  color: AppColors.primary,
                  size: AppSizes.iconMd,
                ),
                title: Text(
                  AppLocalizationsVi.biometricLogin,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  AppLocalizationsVi.biometricLoginDesc,
                  style: AppTextStyles.caption,
                ),
                value: _isBiometricEnabled,
                onChanged: _handleToggleBiometric,
              ),
            ),
            AppSpacing.gapLg,
            _sectionHeader('MẬT KHẨU & TÀI KHOẢN'),
            AppSpacing.gapSm,
            _optionTile(
              Icons.lock_reset_outlined,
              AppLocalizationsVi.forgotPassword,
              () {
                showAppSnackBar(
                  context,
                  'Tính năng quên mật khẩu qua email sẽ được gửi liên kết đặt lại',
                );
              },
            ),
            _optionTile(
              Icons.password_outlined,
              'Đổi mật khẩu',
              () {
                showAppSnackBar(
                  context,
                  'Bạn có thể đổi mật khẩu trong tài khoản của mình',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title, style: AppTextStyles.overline),
    );
  }

  Widget _optionTile(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        padding: EdgeInsets.zero,
        onTap: onTap,
        child: ListTile(
          leading: Icon(icon, color: AppColors.primary, size: AppSizes.iconMd),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: const Icon(Icons.chevron_right_rounded,
              color: AppColors.textTertiary),
        ),
      ),
    );
  }
}
