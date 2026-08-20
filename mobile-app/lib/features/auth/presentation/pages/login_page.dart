import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations_vi.dart';
import '../../../../core/store/app_state.dart';
import '../../../../core/store/store_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/services/biometric_service.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  final AuthController controller;
  const LoginPage({super.key, required this.controller});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _biometricService = BiometricService();

  bool _hasSavedAccount = false;
  String? _savedEmail;
  String? _savedPassword;
  bool _canUseBiometric = false;

  @override
  void initState() {
    super.initState();
    _loadSavedAccount();
  }

  Future<void> _loadSavedAccount() async {
    final account = await widget.controller.apiService.getSavedAccount();
    final isBioEnabled =
        await widget.controller.apiService.isBiometricEnabled();
    final isBioAvailable = await _biometricService.isBiometricAvailable();

    if (mounted) {
      setState(() {
        if (account != null) {
          _hasSavedAccount = true;
          _savedEmail = account['email'];
          _savedPassword = account['password'];
          _emailController.text = _savedEmail ?? '';
        }
        _canUseBiometric = _hasSavedAccount && isBioEnabled && isBioAvailable;
      });
    }
  }

  Future<void> _showClearAccountDialog() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.brLg),
        title: Text(
          AppLocalizationsVi.clearSavedAccountTitle,
          style: AppTextStyles.h3,
        ),
        content: Text(
          AppLocalizationsVi.clearSavedAccountConfirm,
          style: AppTextStyles.body,
        ),
        actions: [
          AppTextButton(
            text: AppLocalizationsVi.cancel,
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: const RoundedRectangleBorder(borderRadius: AppRadius.brSm),
            ),
            child: Text(AppLocalizationsVi.confirm),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await widget.controller.apiService.clearSavedAccount();
      if (!mounted) return;
      setState(() {
        _hasSavedAccount = false;
        _savedEmail = null;
        _savedPassword = null;
        _canUseBiometric = false;
        _emailController.clear();
        _passwordController.clear();
      });
      showAppSnackBar(context, AppLocalizationsVi.clearSavedAccountSuccess);
    }
  }

  Future<void> _handleBiometricLogin() async {
    if (_savedEmail == null || _savedPassword == null) return;

    final authenticated = await _biometricService.authenticate(
      localizedReason: AppLocalizationsVi.biometricReason,
    );

    if (authenticated) {
      _emailController.text = _savedEmail!;
      _passwordController.text = _savedPassword!;
      await _handleLogin();
    } else {
      if (mounted) {
        showAppSnackBar(
          context,
          AppLocalizationsVi.biometricAuthFailed,
          isError: true,
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final ok = await widget.controller.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (!mounted) return;

    if (ok) {
      showAppSnackBar(context, AppLocalizationsVi.loginSuccess);
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (r) => false);
    } else {
      final msg = widget.controller.store.state.auth.errorMessage ??
          AppLocalizationsVi.loginFailed;
      showAppSnackBar(context, msg, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AuthState>(
      selector: (s) => s.auth,
      builder: (context, auth) {
        return LoadingOverlay(
          isLoading: auth.isLoading,
          child: ResponsiveScaffold(
            appBar: _appBar(context),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppLogo(size: 52, showWordmark: false),
                    AppSpacing.gapLg,
                    Text(AppLocalizationsVi.welcomeBack,
                        style: AppTextStyles.display),
                    const SizedBox(height: 10),
                    Text(AppLocalizationsVi.welcomeMessage,
                        style: AppTextStyles.bodyLarge),
                    const SizedBox(height: AppSpacing.xl),
                    AppTextField(
                      controller: _emailController,
                      label: AppLocalizationsVi.emailLabel,
                      hint: AppLocalizationsVi.emailHint,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined,
                          color: AppColors.textTertiary, size: AppSizes.iconMd),
                      suffixIcon: _hasSavedAccount
                          ? IconButton(
                              icon: const Icon(
                                Icons.edit_outlined,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              onPressed: _showClearAccountDialog,
                            )
                          : null,
                      validator: Validators.validateEmail,
                    ),
                    AppSpacing.gapMd,
                    AppPasswordField(
                      controller: _passwordController,
                      label: AppLocalizationsVi.passwordLabel,
                      hint: AppLocalizationsVi.passwordHint,
                      validator: Validators.validatePassword,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AppTextButton(
                        text: AppLocalizationsVi.forgotPassword,
                        onPressed: () {},
                      ),
                    ),
                    AppSpacing.gapMd,
                    AppButton(
                      text: AppLocalizationsVi.login,
                      onPressed: _handleLogin,
                    ),
                    if (_canUseBiometric) ...[
                      AppSpacing.gapSm,
                      AppButton(
                        text: AppLocalizationsVi.biometricLogin,
                        variant: AppButtonVariant.outline,
                        icon: const Icon(Icons.fingerprint_rounded,
                            color: AppColors.primary, size: 24),
                        onPressed: _handleBiometricLogin,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    _divider(),
                    const SizedBox(height: AppSpacing.lg),
                    _socialButtons(),
                    const SizedBox(height: AppSpacing.lg),
                    _signUpLink(context),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_rounded,
            color: AppColors.textPrimary),
      ),
    );
  }

  Widget _divider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(AppLocalizationsVi.orContinueWith,
              style: AppTextStyles.caption),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }

  Widget _socialButtons() {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            text: 'Google',
            variant: AppButtonVariant.social,
            onPressed: () {},
            icon: const Text('G',
                style: TextStyle(
                    color: AppColors.googleBlue,
                    fontWeight: FontWeight.w900,
                    fontSize: 16)),
          ),
        ),
        AppSpacing.gapMd,
        Expanded(
          child: AppButton(
            text: 'Apple',
            variant: AppButtonVariant.social,
            onPressed: () {},
            icon: const Icon(Icons.apple_rounded,
                size: 22, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _signUpLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppLocalizationsVi.dontHaveAccount, style: AppTextStyles.body),
        AppTextButton(
          text: AppLocalizationsVi.signUp,
          onPressed: () => Navigator.pushNamed(context, '/signup'),
        ),
      ],
    );
  }
}
