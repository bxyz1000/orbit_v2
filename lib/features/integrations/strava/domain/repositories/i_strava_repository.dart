import '../entities/strava_activity.dart';
import '../entities/strava_auth_state.dart';

abstract class IStravaRepository {
  Future<List<StravaActivity>> getActivities();
  Future<List<StravaActivity>> getActivitiesForDateRange(DateTime start, DateTime end);
  Stream<List<StravaActivity>> watchActivities();
  Future<int> syncActivities();
  Future<StravaAuthState> getIntegrationState();
  Stream<StravaAuthState> watchIntegrationState();
  Future<void> disconnect();
}

