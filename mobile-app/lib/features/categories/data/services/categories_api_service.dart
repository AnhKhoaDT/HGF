import '../../../../core/api/api_client.dart';
import '../models/category_model.dart';

class CategoriesApiService {
  final ApiClient _apiClient;

  CategoriesApiService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<CategoryModel>> fetchCategories() async {
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

      return (items as List)
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
