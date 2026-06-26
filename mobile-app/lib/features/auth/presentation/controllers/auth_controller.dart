import '../../../../core/store/app_actions.dart';
import '../../../../core/store/app_store.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_with_email_password.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

/// Tầng "thunk" cho Auth: thực hiện side-effect (gọi use-case) rồi dispatch
/// các action kết quả vào [AppStore]. Reducer là nơi duy nhất đổi state.
///
/// Cách này giữ nguyên tầng data/domain hiện có, đồng thời đưa toàn bộ
/// trạng thái auth về store dùng chung cho cả Web & Mobile.
class AuthController {
  final AppStore store;
  final RegisterUseCase registerUseCase;
  final LoginWithEmailPassword loginUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LogoutUseCase logoutUseCase;
  final AuthLocalDataSource localDataSource;

  AuthController({
    required this.store,
    required this.registerUseCase,
    required this.loginUseCase,
    required this.getCurrentUserUseCase,
    required this.logoutUseCase,
    required this.localDataSource,
  });

  /// Kiểm tra trạng thái đăng nhập khi mở app.
  Future<bool> checkLoginStatus() async {
    store.dispatch(const AuthStarted());
    try {
      final token = await localDataSource.getAccessToken();
      if (token == null || token.isEmpty) {
        store.dispatch(const AuthUnauthenticated());
        return false;
      }
      final result = await getCurrentUserUseCase.call();
      return result.fold(
        (failure) async {
          await localDataSource.clearTokens();
          store.dispatch(const AuthUnauthenticated());
          return false;
        },
        (user) {
          store.dispatch(AuthSucceeded(user));
          return true;
        },
      );
    } catch (e) {
      store.dispatch(const AuthUnauthenticated());
      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    store.dispatch(const AuthStarted());
    final result = await loginUseCase.call(email: email, password: password);
    return result.fold(
      (failure) {
        store.dispatch(AuthFailed(failure.message));
        return false;
      },
      (user) {
        store.dispatch(AuthSucceeded(user));
        return true;
      },
    );
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
  }) async {
    store.dispatch(const AuthStarted());
    try {
      final user = await registerUseCase.call(
        username: username,
        email: email,
        password: password,
      );
      store.dispatch(AuthSucceeded(user));
      return true;
    } catch (e) {
      store.dispatch(AuthFailed(e.toString().replaceAll('Exception: ', '')));
      return false;
    }
  }

  Future<void> logout() async {
    store.dispatch(const AuthStarted());
    await logoutUseCase.call();
    store.dispatch(const AuthLoggedOut());
  }
}
