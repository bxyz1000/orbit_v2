import '../../domain/entities/strava_activity.dart';
import '../../domain/repositories/i_strava_repository.dart';

class StravaDailyAnalytics {
  final DateTime date;
  final int activityCount;
  final int totalDurationMinutes;
  final double totalDistanceKm;
  final double totalElevationGainMeters;
  final double totalCalories;

  const StravaDailyAnalytics({
    required this.date,
    required this.activityCount,
    required this.totalDurationMinutes,
    required this.totalDistanceKm,
    required this.totalElevationGainMeters,
    required this.totalCalories,
  });

  factory StravaDailyAnalytics.empty(DateTime date) {
    return StravaDailyAnalytics(
      date: date,
      activityCount: 0,
      totalDurationMinutes: 0,
      totalDistanceKm: 0.0,
      totalElevationGainMeters: 0.0,
      totalCalories: 0.0,
    );
  }
}

class StravaAnalyticsAdapter {
  final IStravaRepository _stravaRepository;

  StravaAnalyticsAdapter(this._stravaRepository);

  /// Aggregates Strava activity data for a specific logical date.
  Future<StravaDailyAnalytics> getDailySummary(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    final activities = await _stravaRepository.getActivitiesForDateRange(startOfDay, endOfDay);
    return aggregateActivities(date, activities);
  }

  /// Aggregates a list of activities into a daily analytics summary.
  static StravaDailyAnalytics aggregateActivities(DateTime date, List<StravaActivity> activities) {
    if (activities.isEmpty) {
      return StravaDailyAnalytics.empty(date);
    }

    int durationSeconds = 0;
    double distanceMeters = 0.0;
    double elevationGainMeters = 0.0;
    double calories = 0.0;

    for (final act in activities) {
      durationSeconds += act.movingTimeSeconds;
      distanceMeters += act.distanceMeters;
      elevationGainMeters += act.elevationGainMeters;
      calories += act.calories ?? 0.0;
    }

    return StravaDailyAnalytics(
      date: date,
      activityCount: activities.length,
      totalDurationMinutes: (durationSeconds / 60).round(),
      totalDistanceKm: distanceMeters / 1000.0,
      totalElevationGainMeters: elevationGainMeters,
      totalCalories: calories,
    );
  }
}
