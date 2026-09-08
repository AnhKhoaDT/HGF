import 'package:flutter/material.dart';
import '../../../../core/di/app_module.dart';
import '../../../../core/localization/app_localizations_vi.dart';
import '../../../../core/store/app_state.dart';
import '../../../../core/store/store_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../../places/domain/entities/place_entity.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../data/services/home_api_service.dart';

class HomePage extends StatefulWidget {
  final AuthController? controller;
  final HomeApiService? homeApiService;

  const HomePage({
    super.key,
    this.controller,
    this.homeApiService,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PlaceEntity> _places = [];
  List<CategoryEntity> _categories = [];
  bool _isLoading = true;
  int _selectedCategoryIndex = -1;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    final apiService = widget.homeApiService ?? sl<HomeApiService>();
    final repository = HomeRepositoryImpl(apiService: apiService);
    final overview = await repository.getHomeOverview();
    if (!mounted) return;
    setState(() {
      _places = overview.featuredPlaces;
      _categories = overview.categories;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      maxContentWidth: 720,
      appBar: AppBar(
        titleSpacing: AppSpacing.md,
        title: const AppLogo(size: 30),
        actions: [
          IconButton(
            onPressed: () => _showFeatureInDev(),
            icon: const Icon(Icons.notifications_outlined,
                color: AppColors.textPrimary),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: StoreConnector<AuthState>(
              selector: (s) => s.auth,
              builder: (context, auth) {
                final avatarUrl = auth.user?.avatarUrl;
                return Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primarySoft,
                    border: Border.all(color: AppColors.primary, width: 2),
                    image: avatarUrl != null && avatarUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(avatarUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: avatarUrl == null || avatarUrl.isEmpty
                      ? const Icon(Icons.person_rounded,
                          size: 18, color: AppColors.primary)
                      : null,
                );
              },
            ),
          ),
          AppSpacing.gapSm,
        ],
      ),
      child: RefreshIndicator(
        onRefresh: _fetchData,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacing.gapMd,
              _greetingCard(),
              AppSpacing.gapLg,
              _searchBar(),
              AppSpacing.gapLg,
              _quickActions(),
              AppSpacing.gapLg,
              _sectionHeader(
                AppLocalizationsVi.homeCategories,
                showViewAll: _categories.isNotEmpty,
              ),
              AppSpacing.gapSm,
              _categoryChips(),
              AppSpacing.gapLg,
              _sectionHeader(
                AppLocalizationsVi.homeFeaturedPlaces,
                showViewAll: _places.isNotEmpty,
              ),
              AppSpacing.gapSm,
              _featuredPlaces(),
              AppSpacing.gapLg,
              _createTripCta(),
              AppSpacing.gapXl,
            ],
          ),
        ),
      ),
    );
  }

  // ─── Greeting Card with XP ───────────────────────────────────

  Widget _greetingCard() {
    return StoreConnector<AuthState>(
      selector: (s) => s.auth,
      builder: (context, auth) {
        final user = auth.user;
        final name = user?.username ?? user?.fullName ?? 'lữ khách';
        final xp = user?.expPoints ?? 0;
        final level = _getLevelName(user?.userLevel ?? 'explorer');
        final maxXp = _getMaxXpForLevel(user?.userLevel ?? 'explorer');
        final progress = maxXp > 0 ? (xp / maxXp).clamp(0.0, 1.0) : 0.0;

        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: AppRadius.brLg,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chào $name 👋',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizationsVi.homeSubtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.85),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: AppRadius.brPill,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.emoji_events_rounded,
                            color: Colors.amberAccent, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          level,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.amberAccent),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '$xp XP',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── Search Bar ──────────────────────────────────────────────

  Widget _searchBar() {
    return AppSearchBar(
      hintText: AppLocalizationsVi.homeSearchHint,
      onTap: _showFeatureInDev,
    );
  }

  // ─── Quick Actions ───────────────────────────────────────────

  Widget _quickActions() {
    return Row(
      children: [
        Expanded(
          child: _quickActionCard(
            Icons.auto_awesome_rounded,
            AppLocalizationsVi.homeAiItinerary,
            const Color(0xFF6C5CE7),
            const Color(0xFFE8E0FF),
          ),
        ),
        AppSpacing.gapSm,
        Expanded(
          child: _quickActionCard(
            Icons.explore_rounded,
            AppLocalizationsVi.homeExplore,
            AppColors.secondary,
            AppColors.secondarySoft,
          ),
        ),
        AppSpacing.gapSm,
        Expanded(
          child: _quickActionCard(
            Icons.location_on_rounded,
            AppLocalizationsVi.homeCheckin,
            AppColors.tertiary,
            AppColors.tertiarySoft,
          ),
        ),
      ],
    );
  }

  Widget _quickActionCard(
      IconData icon, String label, Color iconColor, Color bgColor) {
    return GestureDetector(
      onTap: _showFeatureInDev,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: AppRadius.brMd,
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowSoft,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Section Header ──────────────────────────────────────────

  Widget _sectionHeader(String title, {bool showViewAll = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.h3),
        if (showViewAll)
          GestureDetector(
            onTap: _showFeatureInDev,
            child: const Text(
              AppLocalizationsVi.homeViewAll,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }

  // ─── Category Chips ──────────────────────────────────────────

  Widget _categoryChips() {
    if (_isLoading) {
      return SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          separatorBuilder: (_, __) => AppSpacing.gapXs,
          itemBuilder: (_, __) => Container(
            width: 80,
            decoration: const BoxDecoration(
              color: AppColors.backgroundAlt,
              borderRadius: AppRadius.brPill,
            ),
          ),
        ),
      );
    }

    if (_categories.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Center(
          child: Text(
            AppLocalizationsVi.homeNoCategories,
            style: AppTextStyles.caption,
          ),
        ),
      );
    }

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => AppSpacing.gapXs,
        itemBuilder: (context, i) {
          final cat = _categories[i];
          final name = cat.name;
          final selected = _selectedCategoryIndex == i;
          return GestureDetector(
            onTap: () => setState(() {
              _selectedCategoryIndex = selected ? -1 : i;
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.card,
                borderRadius: AppRadius.brPill,
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.border,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color:
                        selected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── Featured Places ─────────────────────────────────────────

  Widget _featuredPlaces() {
    if (_isLoading) {
      return SizedBox(
        height: 200,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          separatorBuilder: (_, __) => AppSpacing.gapMd,
          itemBuilder: (_, __) => Container(
            width: 180,
            decoration: const BoxDecoration(
              color: AppColors.backgroundAlt,
              borderRadius: AppRadius.brLg,
            ),
          ),
        ),
      );
    }

    if (_places.isEmpty) {
      return Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: AppRadius.brLg,
          border: Border.all(color: AppColors.border),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.place_outlined,
                size: 40, color: AppColors.textTertiary),
            AppSpacing.gapSm,
            Text(AppLocalizationsVi.homeNoPlaces,
                style: AppTextStyles.caption),
          ],
        ),
      );
    }

    return SizedBox(
      height: 210,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _places.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, i) => _placeCard(_places[i]),
      ),
    );
  }

  Widget _placeCard(PlaceEntity place) {
    final name = place.name;
    final address = place.addressRaw ?? '';
    final imageUrl = place.imageUrl;
    final categoryName = place.categoryId;

    return GestureDetector(
      onTap: _showFeatureInDev,
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: AppRadius.brLg,
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowSoft,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image / Placeholder
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
                gradient: imageUrl == null
                    ? LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.7),
                          AppColors.tertiary.withValues(alpha: 0.5),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                image: imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imageUrl == null
                  ? const Center(
                      child: Icon(Icons.landscape_rounded,
                          size: 36, color: Colors.white70),
                    )
                  : null,
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xs + 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.place_outlined,
                            size: 12, color: AppColors.textTertiary),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            address,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textTertiary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (categoryName != null) ...[
                      const Spacer(),
                      AppTag(text: categoryName),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── CTA Card ────────────────────────────────────────────────

  Widget _createTripCta() {
    return GestureDetector(
      onTap: _showFeatureInDev,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: AppRadius.brLg,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C5CE7).withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppLocalizationsVi.homeCreateTrip,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizationsVi.homeCreateTripDesc,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapMd,
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome_rounded,
                  color: Colors.white, size: 28),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────

  String _getLevelName(String level) {
    switch (level) {
      case 'gem_hunter':
        return AppLocalizationsVi.gemHunterLevel;
      case 'discovery_master':
        return AppLocalizationsVi.discoveryMasterLevel;
      case 'legend':
        return AppLocalizationsVi.legendLevel;
      default:
        return AppLocalizationsVi.explorerLevel;
    }
  }

  int _getMaxXpForLevel(String level) {
    switch (level) {
      case 'explorer':
        return 1000;
      case 'gem_hunter':
        return 5000;
      case 'discovery_master':
        return 20000;
      case 'legend':
        return 50000;
      default:
        return 1000;
    }
  }

  void _showFeatureInDev() {
    showAppSnackBar(context, AppLocalizationsVi.homeFeatureInDev);
  }
}
