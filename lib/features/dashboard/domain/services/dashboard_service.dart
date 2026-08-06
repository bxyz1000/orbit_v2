import '../entities/dashboard_state.dart';

abstract class DashboardService {
  Future<DashboardState> getDashboardState([DateTime? date]);
}
