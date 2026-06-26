import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/api/api_client.dart';
import 'core/store/app_store.dart';
import 'core/store/store_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/slide_route.dart';
import 'features/auth/data/datasources/impl/auth_local_data_source_impl.dart';
import 'features/auth/data/datasources/impl/auth_remote_data_source_impl.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/login_with_email_password.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';
import 'features/home/presentation/pages/welcome_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/signup_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppStore _store;
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();

    // ---- Dependency Injection thủ công ----
    final apiClient = ApiClient();
    const secureStorage = FlutterSecureStorage();

    final remoteDataSource = AuthRemoteDataSourceImpl(apiClient);
    final localDataSource = AuthLocalDataSourceImpl(secureStorage);

    final authRepository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );

    // ---- Store dùng chung (Redux pattern) ----
    _store = AppStore();

    _authController = AuthController(
      store: _store,
      registerUseCase: RegisterUseCase(repository: authRepository),
      loginUseCase: LoginWithEmailPassword(authRepository),
      getCurrentUserUseCase: GetCurrentUserUseCase(repository: authRepository),
      logoutUseCase: LogoutUseCase(repository: authRepository),
      localDataSource: localDataSource,
    );
  }

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: _store,
      child: MaterialApp(
        title: 'TripWise',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                  builder: (_) => WelcomePage(controller: _authController));
            case '/home':
              return SlideRightRoute(
                  page: HomePage(controller: _authController));
            case '/login':
              return SlideRightRoute(
                  page: LoginPage(controller: _authController));
            case '/signup':
              return SlideRightRoute(
                  page: SignUpPage(controller: _authController));
            case '/profile':
              return SlideRightRoute(
                  page: ProfilePage(controller: _authController));
            default:
              return MaterialPageRoute(
                  builder: (_) => WelcomePage(controller: _authController));
          }
        },
      ),
    );
  }
}
