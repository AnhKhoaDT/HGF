import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    String message = 'Lỗi kết nối mạng',
    int? code,
  }) : super(message: message, code: code);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    String message = 'Hết thời gian chờ',
    int? code,
  }) : super(message: message, code: code);
}

class ServerFailure extends Failure {
  const ServerFailure({
    String message = 'Lỗi máy chủ',
    int? code,
  }) : super(message: message, code: code);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    String message = 'Phiên đăng nhập hết hạn',
    int? code = 401,
  }) : super(message: message, code: code);
}

class AuthFailure extends Failure {
  const AuthFailure({
    String message = 'Lỗi xác thực',
    int? code,
  }) : super(message: message, code: code);
}

class EmailAlreadyInUseFailure extends Failure {
  const EmailAlreadyInUseFailure({
    String message = 'Email đã được sử dụng',
    int? code,
  }) : super(message: message, code: code);
}

class WrongPasswordFailure extends Failure {
  const WrongPasswordFailure({
    String message = 'Mật khẩu không chính xác',
    int? code,
  }) : super(message: message, code: code);
}

class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure({
    String message = 'Không tìm thấy người dùng',
    int? code,
  }) : super(message: message, code: code);
}

class WeakPasswordFailure extends Failure {
  const WeakPasswordFailure({
    String message = 'Mật khẩu quá yếu',
    int? code,
  }) : super(message: message, code: code);
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure({
    String message = 'Thông tin đăng nhập không hợp lệ',
    int? code,
  }) : super(message: message, code: code);
}

class AccountDisabledFailure extends Failure {
  const AccountDisabledFailure({
    String message = 'Tài khoản đã bị vô hiệu hóa',
    int? code,
  }) : super(message: message, code: code);
}

class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure({
    String message = 'Quá nhiều yêu cầu, vui lòng thử lại sau',
    int? code,
  }) : super(message: message, code: code);
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    String message = 'Dữ liệu không hợp lệ',
    int? code,
  }) : super(message: message, code: code);
}

class CacheFailure extends Failure {
  const CacheFailure({
    String message = 'Lỗi lưu trữ cục bộ',
    int? code,
  }) : super(message: message, code: code);
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    String message = 'Đã xảy ra lỗi không xác định',
    int? code,
  }) : super(message: message, code: code);
}
