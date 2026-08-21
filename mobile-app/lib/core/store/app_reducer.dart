import 'app_actions.dart';
import 'app_state.dart';

/// Reducer gốc: nhận state hiện tại + action, trả về state mới (thuần, bất biến).
AppState appReducer(AppState state, AppAction action) {
  return state.copyWith(auth: _authReducer(state.auth, action));
}

AuthState _authReducer(AuthState state, AppAction action) {
  if (action is AuthStarted) {
    return state.copyWith(
      status: AuthFlowStatus.authenticating,
      clearError: true,
    );
  }
  if (action is AuthSucceeded) {
    return state.copyWith(
      status: AuthFlowStatus.authenticated,
      user: action.user,
      clearError: true,
    );
  }
  if (action is AuthFailed) {
    return state.copyWith(
      status: AuthFlowStatus.error,
      errorMessage: action.message,
    );
  }
  if (action is AuthUnauthenticated) {
    return state.copyWith(
      status: AuthFlowStatus.unauthenticated,
      clearUser: true,
      clearError: true,
    );
  }
  if (action is AuthLoggedOut) {
    return state.copyWith(
      status: AuthFlowStatus.unauthenticated,
      clearUser: true,
      clearError: true,
    );
  }
  if (action is AuthErrorCleared) {
    return state.copyWith(clearError: true);
  }
  return state;
}
