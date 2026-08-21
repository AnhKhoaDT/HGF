import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/api/api_client.dart';
import 'core/localization/app_localizations_vi.dart';
import 'core/store/app_actions.dart';
import 'core/store/app_store.dart';
import 'shared/widgets/loading_overlay.dart';
import 'core/store/store_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/slide_route.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/services/auth_api_service.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/login_with_email_password.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';
import 'features/home/data/services/home_api_service.dart';
import 'features/home/presentation/pages/welcome_page.dart';
import 'features/home/presentation/pages/main_screen.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/signup_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/profile/presentation/pages/security_settings_page.dart';

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
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late final AppStore _store;
  late final AuthController _authController;
  late final HomeApiService _homeApiService;

  @override
  void initState() {
    super.initState();

    _store = AppStore();

    final apiClient = ApiClient();
    _homeApiService = HomeApiService(apiClient: apiClient);
    const secureStorage = FlutterSecureStorage();

    final authApiService = AuthApiService(
      apiClient: apiClient,
      secureStorage: secureStorage,
    );

    apiClient.onUnauthorized = () async {
      await authApiService.clearTokens();
      _store.dispatch(const AuthUnauthenticated());
      final nav = _navigatorKey.currentState;
      if (nav != null && nav.context.mounted) {
        final context = nav.context;
        showAppSnackBar(context, AppLocalizationsVi.errorUnauthorized,
            isError: true);
        nav.pushNamedAndRemoveUntil('/', (route) => false);
      }
    };

    final authRepository = AuthRepositoryImpl(apiService: authApiService);

    _authController = AuthController(
      store: _store,
      registerUseCase: RegisterUseCase(repository: authRepository),
      loginUseCase: LoginWithEmailPassword(authRepository),
      getCurrentUserUseCase: GetCurrentUserUseCase(repository: authRepository),
      logoutUseCase: LogoutUseCase(repository: authRepository),
      apiService: authApiService,
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
        navigatorKey: _navigatorKey,
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
                  page: MainScreen(
                    controller: _authController,
                    homeApiService: _homeApiService,
                  ));
            case '/login':
              return SlideRightRoute(
                  page: LoginPage(controller: _authController));
            case '/signup':
              return SlideRightRoute(
                  page: SignUpPage(controller: _authController));
            case '/profile':
              return SlideRightRoute(
                  page: ProfilePage(controller: _authController));
            case '/security-settings':
              return SlideRightRoute(
                  page: SecuritySettingsPage(controller: _authController));
            default:
              return MaterialPageRoute(
                  builder: (_) => WelcomePage(controller: _authController));
          }
        },
      ),
    );
  }
}
