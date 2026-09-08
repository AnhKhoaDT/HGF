import 'package:flutter/foundation.dart';
import '../../../../core/api/api_client.dart';
import '../models/home_overview_model.dart';

class HomeApiService {
  final ApiClient _apiClient;

  HomeApiService({required ApiClient apiClient}) : _apiClient = apiClient;

  ApiClient get apiClient => _apiClient;

  Future<HomeOverviewModel> fetchHomeOverview() async {
    try {
      final response = await _apiClient.dio.get('/home/overview');
      if (response.data != null && response.data['data'] != null) {
        return HomeOverviewModel.fromJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return const HomeOverviewModel();
  }
}
