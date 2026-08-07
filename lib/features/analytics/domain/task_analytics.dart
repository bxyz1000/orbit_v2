import 'analytics_point.dart';
import 'period_comparison.dart';

class TaskAnalytics {
  final List<AnalyticsPoint<int>> completedPerDay;
  final List<AnalyticsPoint<int>> totalPerDay;
  final double overallCompletionRate;
  final double averageDailyCompletionRate;
  final DateTime? bestDay;
  final int totalCompleted;
  final int totalTasks;
  final PeriodComparison<num>? completionComparison;

  const TaskAnalytics({
    required this.completedPerDay,
    required this.totalPerDay,
    required this.overallCompletionRate,
    required this.averageDailyCompletionRate,
    this.bestDay,
    required this.totalCompleted,
    required this.totalTasks,
    this.completionComparison,
  });

  static const empty = TaskAnalytics(
    completedPerDay: [],
    totalPerDay: [],
    overallCompletionRate: 0.0,
    averageDailyCompletionRate: 0.0,
    bestDay: null,
    totalCompleted: 0,
    totalTasks: 0,
    completionComparison: null,
  );
}
