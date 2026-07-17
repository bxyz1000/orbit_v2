class WeeklyScore {
  final DateTime weekStartDate;
  final int totalScore;
  final double averageDailyScore;
  final int taskScore;
  final int habitScore;
  final int focusScore;
  final int healthScore;
  final String scoreVersion;
  final DateTime createdAt;
  final DateTime updatedAt;

  WeeklyScore({
    required this.weekStartDate,
    required this.totalScore,
    required this.averageDailyScore,
    required this.taskScore,
    required this.habitScore,
    required this.focusScore,
    required this.healthScore,
    required this.scoreVersion,
    required this.createdAt,
    required this.updatedAt,
  });
}
