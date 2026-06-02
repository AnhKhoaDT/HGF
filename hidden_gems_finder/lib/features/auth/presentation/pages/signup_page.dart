import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_vi.dart';
import '../../../../core/utils/validators.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

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
  
  bool _isLoading = false;
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppLocalizationsVi.acceptTermsRequired),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      await Future.delayed(const Duration(seconds: 2));
      
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppLocalizationsVi.signUpSuccess),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
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
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        _buildHeader(),
                        const SizedBox(height: 32),
                        _buildSignUpForm(),
                        const SizedBox(height: 20),
                        _buildTermsCheckbox(),
                        const SizedBox(height: 32),
                        CustomButton(
                          text: AppLocalizationsVi.createAccount,
                          onPressed: _handleSignUp,
                          isLoading: _isLoading,
                          variant: ButtonVariant.primary,
                        ),
                        const SizedBox(height: 24),
                        _buildDivider(),
                        const SizedBox(height: 24),
                        _buildSocialSignUp(),
                        const SizedBox(height: 24),
                        _buildLoginLink(),
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

  Widget _buildAppBar() {
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
        const Text(
          AppLocalizationsVi.welcomeSignUp,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: AppColors.brandLight,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          AppLocalizationsVi.welcomeSignUpMessage,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textTertiary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _fullNameController,
            label: AppLocalizationsVi.fullNameLabel,
            hint: AppLocalizationsVi.fullNameHint,
            keyboardType: TextInputType.name,
            prefixIcon: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.textDisabled,
              size: 22,
            ),
            validator: (value) => Validators.validateFullName(value),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _usernameController,
            label: AppLocalizationsVi.usernameLabel,
            hint: AppLocalizationsVi.usernameHint,
            keyboardType: TextInputType.text,
            prefixIcon: const Icon(
              Icons.alternate_email_rounded,
              color: AppColors.textDisabled,
              size: 22,
            ),
            validator: (value) => Validators.validateUsername(value),
          ),
          const SizedBox(height: 20),
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
          const SizedBox(height: 20),
          PasswordTextField(
            controller: _confirmPasswordController,
            label: AppLocalizationsVi.confirmPasswordLabel,
            hint: AppLocalizationsVi.confirmPasswordHint,
            validator: (value) => Validators.validateConfirmPassword(
              value,
              _passwordController.text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.scale(
          scale: 1.2, 
          child: Checkbox(
            value: _acceptedTerms,
            onChanged: (value) {
              setState(() {
                _acceptedTerms = value ?? false;
              });
            },
            activeColor: AppColors.brandPrimary,
            checkColor: Colors.white,
            side: BorderSide(
              color: AppColors.darkBorder.withOpacity(0.5),
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 14,
                  height: 1.4,
                ),
                children: [
                  TextSpan(text: AppLocalizationsVi.agreeToTerms + ' '),
                  TextSpan(
                    text: AppLocalizationsVi.termsOfService,
                    style: const TextStyle(
                      color: AppColors.brandLight,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {},
                  ),
                  TextSpan(text: ' ${AppLocalizationsVi.and} '),
                  TextSpan(
                    text: AppLocalizationsVi.privacyPolicy,
                    style: const TextStyle(
                      color: AppColors.brandLight,
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

  Widget _buildSocialSignUp() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: 'Google',
            variant: ButtonVariant.social,
            height: 56,
            onPressed: () {},
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
            onPressed: () {},
            icon: const Icon(
              Icons.apple_rounded,
              size: 20,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizationsVi.alreadyHaveAccount,
          style: TextStyle(
            color: AppColors.textTertiary,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 4),
        CustomTextButton(
          text: AppLocalizationsVi.login,
          onPressed: () {
            Navigator.pop(context);
          },
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }
}
