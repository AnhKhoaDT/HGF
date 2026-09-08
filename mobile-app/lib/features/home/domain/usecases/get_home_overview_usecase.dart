import '../entities/home_overview_entity.dart';
import '../repositories/home_repository.dart';

class GetHomeOverviewUseCase {
  final HomeRepository repository;

  GetHomeOverviewUseCase({required this.repository});

  Future<HomeOverviewEntity> call() async {
    return await repository.getHomeOverview();
  }
}
