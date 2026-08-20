import '../localization/app_localizations_vi.dart';
import '../localization/app_localizations_en.dart';

class Validators {
  Validators._();

  static String? validateEmail(String? value, {bool isVietnamese = true}) {
    if (value == null || value.isEmpty) {
      return isVietnamese ? AppLocalizationsVi.emailRequired : AppLocalizationsEn.emailRequired;
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return isVietnamese ? AppLocalizationsVi.emailInvalid : AppLocalizationsEn.emailInvalid;
    }

    return null;
  }

  static String? validatePassword(String? value, {bool isVietnamese = true}) {
    if (value == null || value.isEmpty) {
      return isVietnamese ? AppLocalizationsVi.passwordRequired : AppLocalizationsEn.passwordRequired;
    }

    if (value.length < 8) {
      return isVietnamese ? AppLocalizationsVi.passwordTooShort : AppLocalizationsEn.passwordTooShort;
    }

    final hasUppercase = value.contains(RegExp(r'[A-Z]'));
    final hasLowercase = value.contains(RegExp(r'[a-z]'));
    final hasDigit = value.contains(RegExp(r'[0-9]'));

    if (!hasUppercase || !hasLowercase || !hasDigit) {
      return isVietnamese ? AppLocalizationsVi.passwordTooWeak : AppLocalizationsEn.passwordTooWeak;
    }

    return null;
  }

  static String? validateConfirmPassword(
    String? value,
    String? originalPassword, {
    bool isVietnamese = true,
  }) {
    if (value == null || value.isEmpty) {
      return isVietnamese ? AppLocalizationsVi.passwordRequired : AppLocalizationsEn.passwordRequired;
    }

    if (value != originalPassword) {
      return isVietnamese ? AppLocalizationsVi.passwordNotMatch : AppLocalizationsEn.passwordNotMatch;
    }

    return null;
  }

  static String? validateUsername(String? value, {bool isVietnamese = true}) {
    if (value == null || value.trim().isEmpty) {
      return isVietnamese ? AppLocalizationsVi.usernameRequired : AppLocalizationsEn.usernameRequired;
    }

    if (value.trim().length < 3) {
      return isVietnamese ? AppLocalizationsVi.usernameTooShort : AppLocalizationsEn.usernameTooShort;
    }

    final usernameRegex = RegExp(r'^[\p{L}\p{N}_\s]+$', unicode: true);

    if (!usernameRegex.hasMatch(value.trim())) {
      return isVietnamese ? AppLocalizationsVi.usernameInvalid : AppLocalizationsEn.usernameInvalid;
    }

    return null;
  }

  static String? validatePhone(String? value, {bool isVietnamese = true}) {
    if (value == null || value.isEmpty) {
      return isVietnamese ? AppLocalizationsVi.phoneRequired : AppLocalizationsEn.phoneRequired;
    }

    final cleanedPhone = value.replaceAll(RegExp(r'[\s-]'), '');

    final phoneRegex = RegExp(
      r'^(\+84|0)(3|5|7|8|9)[0-9]{8}$',
    );

    if (!phoneRegex.hasMatch(cleanedPhone)) {
      return isVietnamese ? AppLocalizationsVi.phoneInvalid : AppLocalizationsEn.phoneInvalid;
    }

    return null;
  }

  static String? validateFullName(String? value, {bool isVietnamese = true}) {
    if (value == null || value.isEmpty) {
      return isVietnamese ? AppLocalizationsVi.fullNameRequired : AppLocalizationsEn.fullNameRequired;
    }

    if (value.trim().length < 2) {
      return isVietnamese ? AppLocalizationsVi.fullNameTooShort : AppLocalizationsEn.fullNameTooShort;
    }

    return null;
  }

  static String? validateRequired(String? value, {bool isVietnamese = true}) {
    if (value == null || value.isEmpty) {
      return isVietnamese ? AppLocalizationsVi.fieldRequired : AppLocalizationsEn.fieldRequired;
    }

    return null;
  }

  static String? validateVerificationCode(String? value, {bool isVietnamese = true}) {
    if (value == null || value.isEmpty) {
      return isVietnamese ? AppLocalizationsVi.fieldRequired : AppLocalizationsEn.fieldRequired;
    }

    final codeRegex = RegExp(r'^[0-9]{6}$');

    if (!codeRegex.hasMatch(value)) {
      return 'Mã xác thực phải gồm 6 chữ số';
    }

    return null;
  }
}
