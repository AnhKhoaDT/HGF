import '../entities/place_entity.dart';

abstract class PlacesRepository {
  Future<List<PlaceEntity>> getPlaces({int limit = 20, int page = 1});
}
