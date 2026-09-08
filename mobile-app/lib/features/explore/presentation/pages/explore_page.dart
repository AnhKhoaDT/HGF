import 'package:flutter/material.dart';
import '../../../../core/di/app_module.dart';
import '../../../../core/localization/app_localizations_vi.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../categories/data/repositories/categories_repository_impl.dart';
import '../../../categories/data/services/categories_api_service.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../../home/data/services/home_api_service.dart';
import '../../../places/data/repositories/places_repository_impl.dart';
import '../../../places/data/services/places_api_service.dart';
import '../../../places/domain/entities/place_entity.dart';

class ExplorePage extends StatefulWidget {
  final HomeApiService? homeApiService;

  const ExplorePage({super.key, this.homeApiService});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
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
    // Explore calls dedicated Places & Categories Repositories
    final placesRepo = PlacesRepositoryImpl(
      apiService: PlacesApiService(apiClient: apiService.apiClient),
    );
    final categoriesRepo = CategoriesRepositoryImpl(
      apiService: CategoriesApiService(apiClient: apiService.apiClient),
    );

    final results = await Future.wait([
      placesRepo.getPlaces(limit: 20),
      categoriesRepo.getCategories(),
    ]);

    if (!mounted) return;
    setState(() {
      _places = results[0] as List<PlaceEntity>;
      _categories = results[1] as List<CategoryEntity>;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      maxContentWidth: 720,
      appBar: AppBar(
        title: const Text(AppLocalizationsVi.exploreTitle, style: AppTextStyles.h2),
        elevation: 0,
      ),
      child: RefreshIndicator(
        onRefresh: _fetchData,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSearchBar(
                hintText: AppLocalizationsVi.homeSearchHint,
                onTap: _showFeatureInDev,
              ),
              AppSpacing.gapLg,
              if (_categories.isNotEmpty) ...[
                const Text(AppLocalizationsVi.homeCategories,
                    style: AppTextStyles.h3),
                AppSpacing.gapSm,
                _categoryChips(),
                AppSpacing.gapLg,
              ],
              const Text(AppLocalizationsVi.homeFeaturedPlaces,
                  style: AppTextStyles.h3),
              AppSpacing.gapSm,
              _placesGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryChips() {
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
              ),
              child: Center(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _placesGrid() {
    if (_isLoading) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
        ),
        itemCount: 4,
        itemBuilder: (_, __) => Container(
          decoration: const BoxDecoration(
            color: AppColors.backgroundAlt,
            borderRadius: AppRadius.brLg,
          ),
        ),
      );
    }

    if (_places.isEmpty) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.travel_explore_rounded,
                size: 48, color: AppColors.textTertiary),
            AppSpacing.gapSm,
            Text(AppLocalizationsVi.homeNoPlaces,
                style: AppTextStyles.caption),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.78,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: _places.length,
      itemBuilder: (context, i) {
        final place = _places[i];
        final name = place.name;
        final address = place.addressRaw ?? '';
        final imageUrl = place.imageUrl;

        return GestureDetector(
          onTap: _showFeatureInDev,
          child: AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(AppRadius.lg)),
                      gradient: imageUrl == null
                          ? LinearGradient(
                              colors: [
                                AppColors.primary.withValues(alpha: 0.7),
                                AppColors.secondary.withValues(alpha: 0.5),
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
                            child: Icon(Icons.place_rounded,
                                size: 36, color: Colors.white70),
                          )
                        : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTextStyles.h3,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 12, color: AppColors.textTertiary),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              address,
                              style: AppTextStyles.caption,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFeatureInDev() {
    showAppSnackBar(context, AppLocalizationsVi.homeFeatureInDev);
  }
}
