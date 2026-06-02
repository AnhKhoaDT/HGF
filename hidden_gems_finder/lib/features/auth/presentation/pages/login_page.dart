import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_vi.dart';
import '../../../../core/utils/validators.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      await Future.delayed(const Duration(seconds: 2));
      
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppLocalizationsVi.loginSuccess),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  Future<void> _handleAppleLogin() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.darkGradient,
                ),
              ),
            ),
            Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        _buildHeader(),
                        const SizedBox(height: 48),
                        _buildLoginForm(),
                        const SizedBox(height: 16),
                        _buildForgotPassword(),
                        const SizedBox(height: 32),
                        CustomButton(
                          text: AppLocalizationsVi.login,
                          onPressed: _handleLogin,
                          isLoading: _isLoading,
                          variant: ButtonVariant.primary,
                        ),
                        const SizedBox(height: 24),
                        _buildDivider(),
                        const SizedBox(height: 24),
                        _buildSocialLogin(),
                        const SizedBox(height: 32),
                        _buildSignUpLink(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.textPrimary,
            ),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.darkCard.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.brandPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.brandPrimary.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: const Icon(
            Icons.diamond_rounded,
            size: 40,
            color: AppColors.brandLight,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          AppLocalizationsVi.welcomeBack,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: AppColors.brandLight,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          AppLocalizationsVi.welcomeMessage,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textTertiary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _emailController,
            label: AppLocalizationsVi.emailLabel,
            hint: AppLocalizationsVi.emailHint,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: AppColors.textDisabled,
              size: 22,
            ),
            validator: (value) => Validators.validateEmail(value),
          ),
          const SizedBox(height: 20),
          PasswordTextField(
            controller: _passwordController,
            label: AppLocalizationsVi.passwordLabel,
            hint: AppLocalizationsVi.passwordHint,
            validator: (value) => Validators.validatePassword(value),
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: CustomTextButton(
        text: AppLocalizationsVi.forgotPassword,
        onPressed: () {},
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.darkBorder.withOpacity(0.3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            AppLocalizationsVi.orContinueWith,
            style: TextStyle(
              color: AppColors.textDisabled,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.darkBorder.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLogin() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: 'Google',
            variant: ButtonVariant.social,
            height: 56,
            onPressed: _handleGoogleLogin,
            isLoading: _isLoading,
            icon: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  'G',
                  style: TextStyle(
                    color: AppColors.googleBlue,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomButton(
            text: 'Apple',
            variant: ButtonVariant.social,
            height: 56,
            onPressed: _handleAppleLogin,
            isLoading: _isLoading,
            icon: const Icon(
              Icons.apple_rounded,
              size: 24,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizationsVi.dontHaveAccount,
          style: TextStyle(
            color: AppColors.textTertiary,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 4),
        CustomTextButton(
          text: AppLocalizationsVi.signUp,
          onPressed: () {
            Navigator.pushNamed(context, '/signup');
          },
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }
}
