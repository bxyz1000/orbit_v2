import 'analytics_point.dart';
import 'period_comparison.dart';

class StravaAnalytics {
  final List<AnalyticsPoint<int>> activitiesPerDay;
  final int totalActivities;
  final List<AnalyticsPoint<int>> workoutMinutesPerDay;
  final int totalWorkoutMinutes;
  final List<AnalyticsPoint<double>> distancePerDay;
  final double totalDistanceKm;
  final List<AnalyticsPoint<double>> elevationPerDay;
  final double totalElevationGainMeters;
  final List<AnalyticsPoint<double>> caloriesPerDay;
  final double totalCalories;
  final DateTime? longestActivityDay;
  final PeriodComparison<num>? workoutMinutesComparison;

  const StravaAnalytics({
    required this.activitiesPerDay,
    required this.totalActivities,
    required this.workoutMinutesPerDay,
    required this.totalWorkoutMinutes,
    required this.distancePerDay,
    required this.totalDistanceKm,
    required this.elevationPerDay,
    required this.totalElevationGainMeters,
    required this.caloriesPerDay,
    required this.totalCalories,
    this.longestActivityDay,
    this.workoutMinutesComparison,
  });

  static const empty = StravaAnalytics(
    activitiesPerDay: [],
    totalActivities: 0,
    workoutMinutesPerDay: [],
    totalWorkoutMinutes: 0,
    distancePerDay: [],
    totalDistanceKm: 0.0,
    elevationPerDay: [],
    totalElevationGainMeters: 0.0,
    caloriesPerDay: [],
    totalCalories: 0.0,
    longestActivityDay: null,
    workoutMinutesComparison: null,
  );
}
