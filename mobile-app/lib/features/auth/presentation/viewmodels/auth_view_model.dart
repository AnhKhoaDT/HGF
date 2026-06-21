import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/login_with_email_password.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../data/datasources/auth_local_data_source.dart';

enum AuthStatus { initial, loading, success, error }

class AuthViewModel extends ChangeNotifier {
  final RegisterUseCase registerUseCase;
  final LoginWithEmailPassword loginUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LogoutUseCase logoutUseCase;
  final AuthLocalDataSource localDataSource;

  AuthViewModel({
    required this.registerUseCase,
    required this.loginUseCase,
    required this.getCurrentUserUseCase,
    required this.logoutUseCase,
    required this.localDataSource,
  });

  AuthStatus _status = AuthStatus.initial;
  AuthStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  UserEntity? _user;
  UserEntity? get user => _user;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  bool get isLoading => _status == AuthStatus.loading;

  Future<bool> checkLoginStatus() async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      final token = await localDataSource.getAccessToken();
      if (token != null && token.isNotEmpty) {
        final result = await getCurrentUserUseCase.call();
        return result.fold(
          (failure) async {
            await localDataSource.clearTokens();
            _isAuthenticated = false;
            _status = AuthStatus.initial;
            return false;
          },
          (userEntity) {
            _user = userEntity;
            _isAuthenticated = true;
            _status = AuthStatus.success;
            return true;
          },
        );
      } else {
        _isAuthenticated = false;
        _status = AuthStatus.initial;
        return false;
      }
    } catch (e) {
      _isAuthenticated = false;
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await registerUseCase.call(
        username: username,
        email: email,
        password: password,
      );
      _isAuthenticated = true;
      _status = AuthStatus.success;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      notifyListeners();
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await loginUseCase.call(
      email: email,
      password: password,
    );

    result.fold(
      (failure) {
        _status = AuthStatus.error;
        _errorMessage = failure.message;
      },
      (user) {
        _user = user;
        _isAuthenticated = true;
        _status = AuthStatus.success;
      },
    );
    notifyListeners();
  }

  Future<void> logout() async {
    _status = AuthStatus.loading;
    notifyListeners();

    await logoutUseCase.call();

    _isAuthenticated = false;
    _user = null;
    _status = AuthStatus.initial;
    notifyListeners();
  }
}
