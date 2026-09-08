import 'package:flutter/foundation.dart';
import '../../domain/entities/home_overview_entity.dart';
import '../../domain/usecases/get_home_overview_usecase.dart';

class HomeController extends ChangeNotifier {
  final GetHomeOverviewUseCase getHomeOverviewUseCase;

  HomeOverviewEntity _overview = const HomeOverviewEntity();
  bool _isLoading = false;
  String? _errorMessage;

  HomeController({
    required this.getHomeOverviewUseCase,
  });

  HomeOverviewEntity get overview => _overview;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchHomeOverview() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _overview = await getHomeOverviewUseCase();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
