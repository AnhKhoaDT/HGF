import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../services/auth_api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService apiService;

  AuthRepositoryImpl({required this.apiService});

  @override
  Future<UserEntity> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await apiService.register(
      fullName: fullName,
      username: username,
      email: email,
      password: password,
    );
    return response.user;
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await apiService.login(
        email: email,
        password: password,
      );

      await apiService.saveTokens(
        token: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
      );

      await apiService.saveSavedAccount(
        email: email,
        password: password,
      );

      return Right(authResponse.user);
    } catch (e) {
      return Left(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final token = await apiService.getAccessToken();
      if (token == null || token.isEmpty) {
        return const Left(UnauthorizedFailure(message: 'Không tìm thấy phiên đăng nhập'));
      }
      final user = await apiService.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await apiService.logout();
      return const Right(null);
    } catch (e) {
      await apiService.clearTokens();
      return Left(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithGoogle() => throw UnimplementedError();

  @override
  Future<Either<Failure, UserEntity>> loginWithApple() => throw UnimplementedError();

  @override
  Future<Either<Failure, UserEntity>> loginWithFacebook() => throw UnimplementedError();

  @override
  Future<Either<Failure, String>> sendPhoneVerificationCode({required String phoneNumber}) => throw UnimplementedError();

  @override
  Future<Either<Failure, UserEntity>> verifyPhoneCode({required String verificationId, required String code}) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail({required String email}) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> changePassword({required String currentPassword, required String newPassword}) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> sendEmailVerification() => throw UnimplementedError();

  @override
  Future<Either<Failure, bool>> checkEmailVerified() => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> deleteAccount() => throw UnimplementedError();

  @override
  Future<Either<Failure, String>> getIdToken() => throw UnimplementedError();

  @override
  Future<Either<Failure, String>> refreshToken() => throw UnimplementedError();

  @override
  Future<Either<Failure, UserEntity>> updateProfile({String? username, String? fullName, String? avatarUrl}) => throw UnimplementedError();

  @override
  Future<Either<Failure, String>> uploadAvatar({required String imagePath}) => throw UnimplementedError();
}
