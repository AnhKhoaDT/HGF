import '../../features/auth/domain/entities/user_entity.dart';

/// Action cơ sở (theo mẫu Redux). Reducer sẽ phân loại theo kiểu action.
abstract class AppAction {
  const AppAction();
}

// --------------------------- Auth actions ----------------------------------

/// Bắt đầu một thao tác xác thực (login/register/check) — chuyển sang loading.
class AuthStarted extends AppAction {
  const AuthStarted();
}

/// Xác thực thành công, kèm thông tin người dùng.
class AuthSucceeded extends AppAction {
  final UserEntity user;
  const AuthSucceeded(this.user);
}

/// Xác thực thất bại, kèm thông điệp lỗi.
class AuthFailed extends AppAction {
  final String message;
  const AuthFailed(this.message);
}

/// Người dùng chưa đăng nhập (vd: không có token).
class AuthUnauthenticated extends AppAction {
  const AuthUnauthenticated();
}

/// Đăng xuất, xóa người dùng khỏi state.
class AuthLoggedOut extends AppAction {
  const AuthLoggedOut();
}

/// Xóa thông điệp lỗi hiện tại.
class AuthErrorCleared extends AppAction {
  const AuthErrorCleared();
}
