import '../entities/app_settings_entity.dart';
import '../repositories/settings_repository.dart';

class GetAppSettingsUseCase {
  final SettingsRepository repository;

  GetAppSettingsUseCase({required this.repository});

  Future<AppSettingsEntity> call() async {
    return await repository.getSettings();
  }
}
