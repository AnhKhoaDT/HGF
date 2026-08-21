import 'package:flutter/widgets.dart';
import 'app_state.dart';
import 'app_store.dart';

/// Cung cấp [AppStore] xuống cây widget (giống Provider/StoreProvider của Redux).
class StoreProvider extends InheritedNotifier<AppStore> {
  const StoreProvider({
    super.key,
    required AppStore store,
    required super.child,
  }) : super(notifier: store);

  /// Lấy store. Mặc định KHÔNG lắng nghe (chỉ để dispatch).
  static AppStore of(BuildContext context, {bool listen = false}) {
    final provider = listen
        ? context.dependOnInheritedWidgetOfExactType<StoreProvider>()
        : context.getInheritedWidgetOfExactType<StoreProvider>();
    assert(provider != null, 'Không tìm thấy StoreProvider trong context');
    return provider!.notifier!;
  }
}

/// Tiện ích build lại UI theo một "lát cắt" (slice) của state — giống
/// `connect`/`StoreConnector` trong react-redux/flutter_redux.
///
/// Ví dụ:
/// ```dart
/// StoreConnector<AuthState>(
///   selector: (s) => s.auth,
///   builder: (context, auth) => Text(auth.user?.email ?? ''),
/// )
/// ```
class StoreConnector<T> extends StatelessWidget {
  final T Function(AppState state) selector;
  final Widget Function(BuildContext context, T value) builder;

  const StoreConnector({
    super.key,
    required this.selector,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of(context, listen: true);
    return builder(context, selector(store.state));
  }
}
