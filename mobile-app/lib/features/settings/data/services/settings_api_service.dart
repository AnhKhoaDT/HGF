import '../../../../core/api/api_client.dart';
import '../models/app_settings_model.dart';

class SettingsApiService {
  final ApiClient apiClient;

  SettingsApiService({required this.apiClient});

  Future<AppSettingsModel> getSettings() async {
    try {
      final response = await apiClient.dio.get('/settings');
      if (response.data != null && response.data['data'] != null) {
        return AppSettingsModel.fromJson(response.data['data']);
      }
      return AppSettingsModel.fromJson({});
    } catch (_) {
      return AppSettingsModel.fromJson({});
    }
  }
}
