import '../../../../core/api/api_client.dart';
import '../models/place_model.dart';

class PlacesApiService {
  final ApiClient _apiClient;

  PlacesApiService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<PlaceModel>> fetchPlaces({int limit = 20, int page = 1}) async {
    try {
      final response = await _apiClient.dio.get(
        '/places',
        queryParameters: {
          'limit': limit,
          'status': 'active',
          'page': page,
        },
      );
      final data = response.data['data'];
      if (data == null) return [];
      final items = data['items'];
      if (items == null) return [];

      return (items as List)
          .map((json) => PlaceModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
