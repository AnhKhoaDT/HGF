import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpWithEmailPassword {
  final AuthRepository repository;

  SignUpWithEmailPassword(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    String? username,
    String? fullName,
  }) async {
    return await repository.signUpWithEmailPassword(
      email: email.trim(),
      password: password,
      username: username?.trim(),
      fullName: fullName?.trim(),
    );
  }
}
