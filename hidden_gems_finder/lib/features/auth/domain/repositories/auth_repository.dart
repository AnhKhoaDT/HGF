import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signUpWithEmailPassword({
    required String email,
    required String password,
    String? username,
    String? fullName,
  });

  Future<Either<Failure, UserEntity>> loginWithGoogle();

  Future<Either<Failure, UserEntity>> loginWithApple();

  Future<Either<Failure, UserEntity>> loginWithFacebook();

  Future<Either<Failure, String>> sendPhoneVerificationCode({
    required String phoneNumber,
  });

  Future<Either<Failure, UserEntity>> verifyPhoneCode({
    required String verificationId,
    required String code,
  });

  Future<Either<Failure, void>> sendPasswordResetEmail({
    required String email,
  });

  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<Either<Failure, void>> sendEmailVerification();

  Future<Either<Failure, bool>> checkEmailVerified();

  Future<Either<Failure, UserEntity>> getCurrentUser();

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, void>> deleteAccount();

  Future<Either<Failure, String>> getIdToken();

  Future<Either<Failure, String>> refreshToken();

  Future<Either<Failure, UserEntity>> updateProfile({
    String? username,
    String? fullName,
    String? avatarUrl,
  });

  Future<Either<Failure, String>> uploadAvatar({
    required String imagePath,
  });
}
