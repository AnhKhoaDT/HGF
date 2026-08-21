import 'package:flutter/foundation.dart';
import 'app_actions.dart';
import 'app_reducer.dart';
import 'app_state.dart';

/// Store dùng chung theo mẫu Redux (single source of truth).
///
/// - Giữ một [AppState] bất biến.
/// - [dispatch] một [AppAction] -> reducer tạo state mới -> thông báo listener.
/// - Là [ChangeNotifier] nên dễ lắng nghe bằng [StoreConnector]/AnimatedBuilder.
///
/// Side-effect (gọi API...) được xử lý ở tầng "thunk" trong các middleware/
/// service, sau đó dispatch action kết quả về store. Xem AuthController.
class AppStore extends ChangeNotifier {
  AppState _state;

  AppStore([AppState? initial]) : _state = initial ?? AppState.initial();

  AppState get state => _state;

  /// Đẩy một action vào store; reducer sẽ tính state mới.
  void dispatch(AppAction action) {
    final next = appReducer(_state, action);
    if (next != _state) {
      _state = next;
      notifyListeners();
    }
  }
}
