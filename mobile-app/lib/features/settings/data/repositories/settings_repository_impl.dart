import '../../domain/entities/app_settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../services/settings_api_service.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsApiService apiService;

  SettingsRepositoryImpl({required this.apiService});

  @override
  Future<AppSettingsEntity> getSettings() async {
    return await apiService.getSettings();
  }
}
