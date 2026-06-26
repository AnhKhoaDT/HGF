import 'package:flutter/gestures.dart';
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

class SignUpPage extends StatefulWidget {
  final AuthController controller;
  const SignUpPage({super.key, required this.controller});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _acceptedTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_acceptedTerms) {
      showAppSnackBar(context, AppLocalizationsVi.acceptTermsRequired,
          isError: true);
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    final ok = await widget.controller.register(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (!mounted) return;

    if (ok) {
      showAppSnackBar(context, AppLocalizationsVi.signUpSuccess);
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (r) => false);
    } else {
      final msg = widget.controller.store.state.auth.errorMessage ??
          AppLocalizationsVi.signUpFailed;
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
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded,
                    color: AppColors.textPrimary),
              ),
            ),
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
                    Text(AppLocalizationsVi.welcomeSignUp,
                        style: AppTextStyles.h1),
                    const SizedBox(height: 10),
                    Text(AppLocalizationsVi.welcomeSignUpMessage,
                        style: AppTextStyles.bodyLarge),
                    const SizedBox(height: AppSpacing.xl),
                    AppTextField(
                      controller: _fullNameController,
                      label: AppLocalizationsVi.fullNameLabel,
                      hint: AppLocalizationsVi.fullNameHint,
                      keyboardType: TextInputType.name,
                      prefixIcon: const Icon(Icons.person_outline_rounded,
                          color: AppColors.textTertiary, size: AppSizes.iconMd),
                      validator: Validators.validateFullName,
                    ),
                    AppSpacing.gapMd,
                    AppTextField(
                      controller: _usernameController,
                      label: AppLocalizationsVi.usernameLabel,
                      hint: AppLocalizationsVi.usernameHint,
                      prefixIcon: const Icon(Icons.alternate_email_rounded,
                          color: AppColors.textTertiary, size: AppSizes.iconMd),
                      validator: Validators.validateUsername,
                    ),
                    AppSpacing.gapMd,
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
                    AppSpacing.gapMd,
                    AppPasswordField(
                      controller: _confirmPasswordController,
                      label: AppLocalizationsVi.confirmPasswordLabel,
                      hint: AppLocalizationsVi.confirmPasswordHint,
                      validator: (v) => Validators.validateConfirmPassword(
                          v, _passwordController.text),
                    ),
                    AppSpacing.gapMd,
                    _termsCheckbox(),
                    const SizedBox(height: AppSpacing.lg),
                    AppButton(
                      text: AppLocalizationsVi.createAccount,
                      onPressed: _handleSignUp,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _loginLink(context),
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

  Widget _termsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _acceptedTerms,
          onChanged: (v) => setState(() => _acceptedTerms = v ?? false),
          activeColor: AppColors.primary,
          checkColor: Colors.white,
          side: const BorderSide(color: AppColors.border, width: 2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.body,
                children: [
                  TextSpan(text: '${AppLocalizationsVi.agreeToTerms} '),
                  TextSpan(
                    text: AppLocalizationsVi.termsOfService,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {},
                  ),
                  TextSpan(text: ' ${AppLocalizationsVi.and} '),
                  TextSpan(
                    text: AppLocalizationsVi.privacyPolicy,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _loginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppLocalizationsVi.alreadyHaveAccount, style: AppTextStyles.body),
        AppTextButton(
          text: AppLocalizationsVi.login,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
