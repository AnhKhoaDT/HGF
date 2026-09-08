import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/api/api_client.dart';
import 'core/di/app_module.dart';
import 'core/localization/app_localizations_vi.dart';
import 'core/routes/slide_route.dart';
import 'core/store/app_actions.dart';
import 'core/store/app_store.dart';
import 'core/store/store_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/services/auth_api_service.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/signup_page.dart';
import 'features/home/presentation/pages/main_screen.dart';
import 'features/home/presentation/pages/welcome_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/profile/presentation/pages/security_settings_page.dart';
import 'shared/widgets/loading_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final store = AppStore();
  await initAppModule(store: store);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    sl<ApiClient>().onUnauthorized = () async {
      await sl<AuthApiService>().clearTokens();
      sl<AppStore>().dispatch(const AuthUnauthenticated());
      final nav = _navigatorKey.currentState;
      if (nav != null && nav.context.mounted) {
        final context = nav.context;
        showAppSnackBar(context, AppLocalizationsVi.errorUnauthorized,
            isError: true);
        nav.pushNamedAndRemoveUntil('/', (route) => false);
      }
    };
  }

  @override
  void dispose() {
    sl<AppStore>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: sl<AppStore>(),
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'TripWise',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (_) => const WelcomePage());
            case '/home':
              return SlideRightRoute(page: const MainScreen());
            case '/login':
              return SlideRightRoute(page: const LoginPage());
            case '/signup':
              return SlideRightRoute(page: const SignUpPage());
            case '/profile':
              return SlideRightRoute(page: const ProfilePage());
            case '/security-settings':
              return SlideRightRoute(page: const SecuritySettingsPage());
            default:
              return MaterialPageRoute(builder: (_) => const WelcomePage());
          }
        },
      ),
    );
  }
}
