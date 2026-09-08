import '../../../categories/data/models/category_model.dart';
import '../../../places/data/models/place_model.dart';
import '../../domain/entities/home_overview_entity.dart';

class HomeOverviewModel extends HomeOverviewEntity {
  const HomeOverviewModel({
    super.featuredPlaces = const [],
    super.categories = const [],
  });

  factory HomeOverviewModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    final placesRaw = (data['featured_places'] ?? data['places']) as List<dynamic>?;
    final categoriesRaw = (data['categories']) as List<dynamic>?;

    final places = placesRaw != null
        ? placesRaw
            .whereType<Map<String, dynamic>>()
            .map((item) => PlaceModel.fromJson(item))
            .toList()
        : <PlaceModel>[];

    final categories = categoriesRaw != null
        ? categoriesRaw
            .whereType<Map<String, dynamic>>()
            .map((item) => CategoryModel.fromJson(item))
            .toList()
        : <CategoryModel>[];

    return HomeOverviewModel(
      featuredPlaces: places,
      categories: categories,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'featured_places': featuredPlaces
          .map((p) => (p is PlaceModel ? p.toJson() : {}))
          .toList(),
      'categories': categories
          .map((c) => (c is CategoryModel ? c.toJson() : {}))
          .toList(),
    };
  }
}
