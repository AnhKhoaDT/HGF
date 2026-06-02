import 'package:flutter/material.dart';
import 'features/home/presentation/pages/welcome_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/signup_page.dart';
import 'core/theme/app_colors.dart';
import 'core/routes/slide_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hidden Gems Finder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.darkBackground,
        fontFamily: 'Plus Jakarta Sans',
        colorScheme: ColorScheme.light(
          primary: AppColors.brandPrimary,
          secondary: AppColors.brandLight,
          surface: AppColors.darkSurface,
          error: AppColors.error,
          background: AppColors.darkBackground,
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
            return MaterialPageRoute(builder: (_) => const WelcomePage());
          case '/home':
            return SlideRightRoute(page: const HomePage());
          case '/login':
            return SlideRightRoute(page: const LoginPage());
          case '/signup':
            return SlideRightRoute(page: const SignUpPage());
          default:
            return MaterialPageRoute(builder: (_) => const WelcomePage());
        }
      },
    );
  }
}
