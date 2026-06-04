import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
    final AuthRepository repository;

    RegisterUseCase({required this.repository});

    Future<UserEntity> call({
        required String username,
        required String email,
        required String password,
    }) {
        return repository.register(
            username: username,
            email: email,
            password: password,
        );
    }
}