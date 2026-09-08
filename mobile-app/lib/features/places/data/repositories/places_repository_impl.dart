import '../../domain/entities/place_entity.dart';
import '../../domain/repositories/places_repository.dart';
import '../services/places_api_service.dart';

class PlacesRepositoryImpl implements PlacesRepository {
  final PlacesApiService apiService;

  PlacesRepositoryImpl({required this.apiService});

  @override
  Future<List<PlaceEntity>> getPlaces({int limit = 20, int page = 1}) async {
    return await apiService.fetchPlaces(limit: limit, page: page);
  }
}
