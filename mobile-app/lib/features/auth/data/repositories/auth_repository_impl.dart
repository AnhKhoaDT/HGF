import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource; 

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserEntity> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final authResponse = await remoteDataSource.register(
      username: username,
      email: email,
      password: password,
    );

    await localDataSource.saveTokens(
      accessToken: authResponse.accessToken,
      refreshToken: authResponse.refreshToken,
    );

    return authResponse.user;
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await remoteDataSource.login(
        email: email,
        password: password,
      );

      await localDataSource.saveTokens(
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
      );

      return Right(authResponse.user);
    } catch (e) {
      return Left(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithGoogle() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithApple() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithFacebook() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> sendPhoneVerificationCode({
    required String phoneNumber,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserEntity>> verifyPhoneCode({
    required String verificationId,
    required String code,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail({
    required String email,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> sendEmailVerification() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> checkEmailVerified() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final token = await localDataSource.getAccessToken();
      if (token == null || token.isEmpty) {
        return const Left(UnauthorizedFailure(message: 'Không tìm thấy phiên đăng nhập'));
      }
      final user = await remoteDataSource.getCurrentUser(token: token);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final refreshToken = await localDataSource.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await remoteDataSource.logout(refreshToken: refreshToken);
      }
      await localDataSource.clearTokens();
      return const Right(null);
    } catch (e) {
      await localDataSource.clearTokens();
      return Left(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> getIdToken() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> refreshToken() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? username,
    String? fullName,
    String? avatarUrl,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> uploadAvatar({
    required String imagePath,
  }) {
    throw UnimplementedError();
  }
}
