import 'analytics_point.dart';
import 'period_comparison.dart';

class FocusAnalytics {
  final List<AnalyticsPoint<int>> minutesPerDay;
  final int totalMinutes;
  final double averageDailyMinutes;
  final DateTime? longestFocusDay;
  final int totalSessions;
  final PeriodComparison<num>? minutesComparison;

  const FocusAnalytics({
    required this.minutesPerDay,
    required this.totalMinutes,
    required this.averageDailyMinutes,
    this.longestFocusDay,
    required this.totalSessions,
    this.minutesComparison,
  });

  static const empty = FocusAnalytics(
    minutesPerDay: [],
    totalMinutes: 0,
    averageDailyMinutes: 0.0,
    longestFocusDay: null,
    totalSessions: 0,
    minutesComparison: null,
  );
}
