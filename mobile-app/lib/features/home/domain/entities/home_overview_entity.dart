import 'package:equatable/equatable.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../../places/domain/entities/place_entity.dart';

class HomeOverviewEntity extends Equatable {
  final List<PlaceEntity> featuredPlaces;
  final List<CategoryEntity> categories;

  const HomeOverviewEntity({
    this.featuredPlaces = const [],
    this.categories = const [],
  });

  @override
  List<Object?> get props => [featuredPlaces, categories];
}
