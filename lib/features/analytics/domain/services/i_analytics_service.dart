import '../analytics_period.dart';
import '../orbit_analytics.dart';

abstract class IAnalyticsService {
  Future<OrbitAnalytics> getAnalytics(AnalyticsPeriod period, [DateTime? referenceDate]);
}
