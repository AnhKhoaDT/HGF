import '../../domain/entities/home_overview_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../services/home_api_service.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeApiService apiService;

  HomeRepositoryImpl({required this.apiService});

  @override
  Future<HomeOverviewEntity> getHomeOverview() async {
    return await apiService.fetchHomeOverview();
  }
}
