import 'analytics_point.dart';

class HabitAnalytics {
  final double overallCompletionRate;
  final List<AnalyticsPoint<int>> dailyCompletions;
  final int currentStreak;
  final int bestStreak;

  const HabitAnalytics({
    required this.overallCompletionRate,
    required this.dailyCompletions,
    required this.currentStreak,
    required this.bestStreak,
  });

  static const empty = HabitAnalytics(
    overallCompletionRate: 0.0,
    dailyCompletions: [],
    currentStreak: 0,
    bestStreak: 0,
  );
}
