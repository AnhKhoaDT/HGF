import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations_vi.dart';
import '../../../../core/store/app_state.dart';
import '../../../../core/store/store_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/widgets.dart';
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
