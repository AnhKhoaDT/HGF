import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/services/auth_api_service.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/login_with_email_password.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/data/services/home_api_service.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../api/api_client.dart';
import '../store/app_store.dart';

final sl = GetIt.instance;

Future<void> initAppModule({required AppStore store}) async {
  // 1. App Store
  sl.registerSingleton<AppStore>(store);

  // 2. Core Services
  sl.registerLazySingleton<ApiClient>(() => ApiClient());
  sl.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());

  // 3. API Services
  sl.registerLazySingleton<AuthApiService>(
    () => AuthApiService(
      apiClient: sl<ApiClient>(),
      secureStorage: sl<FlutterSecureStorage>(),
    ),
  );

  sl.registerLazySingleton<HomeApiService>(
    () => HomeApiService(apiClient: sl<ApiClient>()),
  );

  // 4. Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(apiService: sl<AuthApiService>()),
  );

  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(apiService: sl<HomeApiService>()),
  );

  // 5. UseCases
  sl.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(repository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<LoginWithEmailPassword>(
    () => LoginWithEmailPassword(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(repository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(repository: sl<AuthRepository>()),
  );

  // 6. Controllers / ViewModels
  sl.registerLazySingleton<AuthController>(
    () => AuthController(
      store: sl<AppStore>(),
      registerUseCase: sl<RegisterUseCase>(),
      loginUseCase: sl<LoginWithEmailPassword>(),
      getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
      apiService: sl<AuthApiService>(),
    ),
  );
}
