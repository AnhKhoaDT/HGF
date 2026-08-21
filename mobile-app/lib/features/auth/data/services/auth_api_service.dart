import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/api/api_client.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

class AuthApiService {
  final ApiClient apiClient;
  final FlutterSecureStorage secureStorage;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _savedEmailKey = 'saved_email';
  static const String _savedPasswordKey = 'saved_password';

  AuthApiService({
    required this.apiClient,
    required this.secureStorage,
  });

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.dio.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );
    return AuthResponseModel.fromJson(response.data);
  }

  Future<AuthResponseModel> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await apiClient.dio.post(
      '/auth/register',
      data: {
        'full_name': fullName,
        'username': username,
        'email': email,
        'password': password,
      },
    );
    return AuthResponseModel.fromJson(response.data);
  }

  Future<UserModel> getCurrentUser() async {
    final token = await getAccessToken();
    final response = await apiClient.dio.get(
      '/auth/me',
      options: Options(
        headers: {
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
      ),
    );
    return UserModel.fromJson(response.data['data']);
  }

  Future<void> logout() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await apiClient.dio.post(
          '/auth/logout',
          data: {'refresh_token': refreshToken},
        );
      }
    } catch (_) {}
    await clearTokens();
  }

  Future<void> saveTokens({
    required String token,
    required String refreshToken,
  }) async {
    await secureStorage.write(key: _accessTokenKey, value: token);
    await secureStorage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await secureStorage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await secureStorage.read(key: _refreshTokenKey);
  }

  Future<void> clearTokens() async {
    await secureStorage.delete(key: _accessTokenKey);
    await secureStorage.delete(key: _refreshTokenKey);
  }

  static const String _biometricEnabledKey = 'biometric_enabled';

  Future<bool> isBiometricEnabled() async {
    final val = await secureStorage.read(key: _biometricEnabledKey);
    return val == 'true';
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await secureStorage.write(
        key: _biometricEnabledKey, value: enabled.toString());
  }

  Future<Map<String, String>?> getSavedAccount() async {
    final email = await secureStorage.read(key: _savedEmailKey);
    final password = await secureStorage.read(key: _savedPasswordKey);
    if (email != null &&
        email.isNotEmpty &&
        password != null &&
        password.isNotEmpty) {
      return {'email': email, 'password': password};
    }
    return null;
  }

  Future<void> saveSavedAccount({
    required String email,
    required String password,
  }) async {
    await secureStorage.write(key: _savedEmailKey, value: email);
    await secureStorage.write(key: _savedPasswordKey, value: password);
  }

  Future<void> clearSavedAccount() async {
    await secureStorage.delete(key: _savedEmailKey);
    await secureStorage.delete(key: _savedPasswordKey);
  }
}
