import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/categories_repository.dart';
import '../services/categories_api_service.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesApiService apiService;

  CategoriesRepositoryImpl({required this.apiService});

  @override
  Future<List<CategoryEntity>> getCategories() async {
    return await apiService.fetchCategories();
  }
}
