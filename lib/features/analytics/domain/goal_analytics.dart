class GoalAnalytics {
  final int totalCompleted;
  final int totalRemaining;
  final double completionRate;

  const GoalAnalytics({
    required this.totalCompleted,
    required this.totalRemaining,
    required this.completionRate,
  });

  static const empty = GoalAnalytics(
    totalCompleted: 0,
    totalRemaining: 0,
    completionRate: 0.0,
  );
}
