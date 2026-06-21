import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/api/api_client.dart';
import 'features/auth/data/datasources/impl/auth_local_data_source_impl.dart';
import 'features/auth/data/datasources/impl/auth_remote_data_source_impl.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/login_with_email_password.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/presentation/viewmodels/auth_view_model.dart';
import 'features/home/presentation/pages/welcome_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/signup_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'core/theme/app_colors.dart';
import 'core/routes/slide_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load environment variables
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Khởi tạo Dependency Injection thủ công
    final apiClient = ApiClient();
    const secureStorage = FlutterSecureStorage();

    final remoteDataSource = AuthRemoteDataSourceImpl(apiClient);
    final localDataSource = AuthLocalDataSourceImpl(secureStorage);

    final authRepository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );

    final registerUseCase = RegisterUseCase(repository: authRepository);
    final loginUseCase = LoginWithEmailPassword(authRepository);
    final getCurrentUserUseCase = GetCurrentUserUseCase(repository: authRepository);
    final logoutUseCase = LogoutUseCase(repository: authRepository);
    final authViewModel = AuthViewModel(
      registerUseCase: registerUseCase,
      loginUseCase: loginUseCase,
      getCurrentUserUseCase: getCurrentUserUseCase,
      logoutUseCase: logoutUseCase,
      localDataSource: localDataSource,
    );

    return MaterialApp(
      title: 'Hidden Gems Finder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.darkBackground,
        fontFamily: 'Plus Jakarta Sans',
        colorScheme: const ColorScheme.light(
          primary: AppColors.brandPrimary,
          secondary: AppColors.brandLight,
          surface: AppColors.darkSurface,
          error: AppColors.error,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => WelcomePage(viewModel: authViewModel));
          case '/home':
            return SlideRightRoute(page: HomePage(viewModel: authViewModel));
          case '/login':
            return SlideRightRoute(page: LoginPage(viewModel: authViewModel));
          case '/signup':
            return SlideRightRoute(page: SignUpPage(viewModel: authViewModel));
          case '/profile':
            return SlideRightRoute(page: ProfilePage(viewModel: authViewModel));
          default:
            return MaterialPageRoute(builder: (_) => WelcomePage(viewModel: authViewModel));
        }
      },
    );
  }
}
