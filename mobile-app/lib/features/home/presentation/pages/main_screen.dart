import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/localization/app_localizations_vi.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../data/services/home_api_service.dart';
import 'explore_page.dart';
import 'home_page.dart';
import 'trips_page.dart';

class MainScreen extends StatefulWidget {
  final AuthController controller;
  final HomeApiService homeApiService;

  const MainScreen({
    super.key,
    required this.controller,
    required this.homeApiService,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(
        controller: widget.controller,
        homeApiService: widget.homeApiService,
      ),
      ExplorePage(
        homeApiService: widget.homeApiService,
      ),
      const TripsPage(),
      ProfilePage(
        controller: widget.controller,
        showBackButton: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
        } else {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: AppColors.card,
            border: Border(
              top: BorderSide(color: AppColors.border, width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowSoft,
                blurRadius: 12,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
              child: NavigationBar(
                selectedIndex: _currentIndex,
                onDestinationSelected: (index) {
                  setState(() => _currentIndex = index);
                },
                backgroundColor: Colors.transparent,
                indicatorColor: AppColors.primarySoft,
                elevation: 0,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined,
                        color: AppColors.textSecondary),
                    selectedIcon:
                        Icon(Icons.home_rounded, color: AppColors.primary),
                    label: AppLocalizationsVi.navHome,
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.explore_outlined,
                        color: AppColors.textSecondary),
                    selectedIcon:
                        Icon(Icons.explore_rounded, color: AppColors.primary),
                    label: AppLocalizationsVi.navExplore,
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.map_outlined,
                        color: AppColors.textSecondary),
                    selectedIcon:
                        Icon(Icons.map_rounded, color: AppColors.primary),
                    label: AppLocalizationsVi.navTrips,
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person_outline_rounded,
                        color: AppColors.textSecondary),
                    selectedIcon:
                        Icon(Icons.person_rounded, color: AppColors.primary),
                    label: AppLocalizationsVi.navProfile,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
