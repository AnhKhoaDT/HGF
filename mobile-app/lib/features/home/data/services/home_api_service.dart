import '../../../../core/api/api_client.dart';

class HomeApiService {
  final ApiClient _apiClient;

  HomeApiService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<Map<String, dynamic>>> fetchFeaturedPlaces({int limit = 5}) async {
    try {
      final response = await _apiClient.dio.get(
        '/places',
        queryParameters: {
          'limit': limit,
          'status': 'active',
          'page': 1,
        },
      );
      final data = response.data['data'];
      if (data == null) return [];
      final items = data['items'];
      if (items == null) return [];
      return List<Map<String, dynamic>>.from(items);
    } catch (_) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      final response = await _apiClient.dio.get(
        '/categories',
        queryParameters: {
          'status': 'active',
          'limit': 20,
          'page': 1,
        },
      );
      final data = response.data['data'];
      if (data == null) return [];
      final items = data['items'];
      if (items == null) return [];
      return List<Map<String, dynamic>>.from(items);
    } catch (_) {
      return [];
    }
  }
}
