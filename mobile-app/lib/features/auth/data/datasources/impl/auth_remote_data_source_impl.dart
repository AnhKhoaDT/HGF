import 'package:dio/dio.dart';
import '../../../../../core/api/api_client.dart';
import '../auth_remote_data_source.dart';
import '../../models/auth_response_model.dart';
import '../../models/user_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
    final ApiClient apiClient;

    AuthRemoteDataSourceImpl(this.apiClient);

    @override
    Future<AuthResponseModel> register({
        required String username,
        required String email,
        required String password,
    }) async {
        try {
            final response = await apiClient.dio.post(
                '/auth/register',
                data: {
                    'username': username,
                    'email': email,
                    'password': password,
                },
            );
            return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
        } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['error'] ?? 'Đăng ký thất bại');
      }
      throw Exception('Không thể kết nối đến máy chủ');
    }
  }

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['error'] ?? 'Đăng nhập thất bại');
      }
      throw Exception('Không thể kết nối đến máy chủ');
    }
  }

  @override
  Future<UserModel> getCurrentUser({
    required String token,
  }) async {
    try {
      final response = await apiClient.dio.get(
        '/auth/me',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['error'] ?? 'Lấy thông tin người dùng thất bại');
      }
      throw Exception('Không thể kết nối đến máy chủ');
    }
  }

  @override
  Future<void> logout({
    required String refreshToken,
  }) async {
    try {
      await apiClient.dio.post(
        '/auth/logout',
        data: {
          'refresh_token': refreshToken,
        },
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['error'] ?? 'Đăng xuất thất bại');
      }
      throw Exception('Không thể kết nối đến máy chủ');
    }
  }
}