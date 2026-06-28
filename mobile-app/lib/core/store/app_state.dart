import 'package:equatable/equatable.dart';
import '../../features/auth/domain/entities/user_entity.dart';

/// Trạng thái xác thực dùng chung.
enum AuthFlowStatus { unknown, unauthenticated, authenticating, authenticated, error }

/// Slice trạng thái cho Auth.
class AuthState extends Equatable {
  final AuthFlowStatus status;
  final UserEntity? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthFlowStatus.unknown,
    this.user,
    this.errorMessage,
  });

  bool get isLoading => status == AuthFlowStatus.authenticating;
  bool get isAuthenticated => status == AuthFlowStatus.authenticated;

  AuthState copyWith({
    AuthFlowStatus? status,
    UserEntity? user,
    String? errorMessage,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}

/// Trạng thái gốc của toàn ứng dụng (root state).
///
/// Khi thêm tính năng mới (lịch trình, bộ sưu tập...), thêm slice mới vào đây.
class AppState extends Equatable {
  final AuthState auth;

  const AppState({this.auth = const AuthState()});

  factory AppState.initial() => const AppState();

  AppState copyWith({AuthState? auth}) {
    return AppState(auth: auth ?? this.auth);
  }

  @override
  List<Object?> get props => [auth];
}
