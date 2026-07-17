class MonthlyScore {
  final DateTime monthStartDate;
  final int totalScore;
  final int taskScore;
  final int habitScore;
  final int focusScore;
  final int healthScore;
  final String scoreVersion;
  final DateTime createdAt;
  final DateTime updatedAt;

  MonthlyScore({
    required this.monthStartDate,
    required this.totalScore,
    required this.taskScore,
    required this.habitScore,
    required this.focusScore,
    required this.healthScore,
    required this.scoreVersion,
    required this.createdAt,
    required this.updatedAt,
  });
}
