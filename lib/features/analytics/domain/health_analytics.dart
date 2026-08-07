import 'analytics_point.dart';
import 'period_comparison.dart';

class HealthAnalytics {
  final List<AnalyticsPoint<int>> stepsPerDay;
  final double averageSteps;
  final DateTime? highestStepsDay;
  final List<AnalyticsPoint<double>> caloriesPerDay;
  final double averageCalories;
  final List<AnalyticsPoint<int>> sleepDurationPerDay;
  final double averageSleepMinutes;
  final List<AnalyticsPoint<int>> workoutsPerDay;
  final int totalWorkouts;
  final PeriodComparison<num>? stepsComparison;

  const HealthAnalytics({
    required this.stepsPerDay,
    required this.averageSteps,
    this.highestStepsDay,
    required this.caloriesPerDay,
    required this.averageCalories,
    required this.sleepDurationPerDay,
    required this.averageSleepMinutes,
    required this.workoutsPerDay,
    required this.totalWorkouts,
    this.stepsComparison,
  });

  static const empty = HealthAnalytics(
    stepsPerDay: [],
    averageSteps: 0.0,
    highestStepsDay: null,
    caloriesPerDay: [],
    averageCalories: 0.0,
    sleepDurationPerDay: [],
    averageSleepMinutes: 0.0,
    workoutsPerDay: [],
    totalWorkouts: 0,
    stepsComparison: null,
  );
}
