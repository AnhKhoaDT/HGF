import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginWithEmailPassword {
  final AuthRepository repository;

  LoginWithEmailPassword(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) async {
    return await repository.loginWithEmailPassword(
      email: email.trim(),
      password: password,
    );
  }
}
