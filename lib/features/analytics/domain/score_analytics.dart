import 'analytics_point.dart';
import 'period_comparison.dart';

class ScoreAnalytics {
  final List<AnalyticsPoint<int>> dailyScores;
  final double averageScore;
  final int highestScore;
  final int lowestScore;
  final PeriodComparison<num>? comparison;

  const ScoreAnalytics({
    required this.dailyScores,
    required this.averageScore,
    required this.highestScore,
    required this.lowestScore,
    this.comparison,
  });

  static const empty = ScoreAnalytics(
    dailyScores: [],
    averageScore: 0.0,
    highestScore: 0,
    lowestScore: 0,
    comparison: null,
  );
}
