import 'user_model.dart';

class AuthResponseModel {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    return AuthResponseModel(
      accessToken: (data['token'] ?? data['access_token'] ?? json['token'] ?? json['access_token'] ?? '') as String,
      refreshToken: (data['refresh_token'] ?? json['refresh_token'] ?? '') as String,
      user: UserModel.fromJson(
        (data['user'] is Map<String, dynamic>)
            ? data['user'] as Map<String, dynamic>
            : data,
      ),
    );
  }
}
