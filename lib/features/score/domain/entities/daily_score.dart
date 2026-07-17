class DailyScore {
  final DateTime date;
  final int totalScore;
  final int taskScore;
  final int plannerScore;
  final int habitScore;
  final int focusScore;
  final int stepsScore;
  final int workoutScore;
  final int sleepScore;
  final int goalScore;
  final int consistencyScore;
  final int bonusScore;
  final int penaltyScore;
  final String scoreVersion;
  final bool isFinalized;
  final DateTime createdAt;
  final DateTime updatedAt;

  DailyScore({
    required this.date,
    required this.totalScore,
    required this.taskScore,
    required this.plannerScore,
    required this.habitScore,
    required this.focusScore,
    required this.stepsScore,
    required this.workoutScore,
    required this.sleepScore,
    required this.goalScore,
    required this.consistencyScore,
    required this.bonusScore,
    required this.penaltyScore,
    required this.scoreVersion,
    required this.isFinalized,
    required this.createdAt,
    required this.updatedAt,
  });

  DailyScore copyWith({
    bool? isFinalized,
    DateTime? updatedAt,
  }) {
    return DailyScore(
      date: date,
      totalScore: totalScore,
      taskScore: taskScore,
      plannerScore: plannerScore,
      habitScore: habitScore,
      focusScore: focusScore,
      stepsScore: stepsScore,
      workoutScore: workoutScore,
      sleepScore: sleepScore,
      goalScore: goalScore,
      consistencyScore: consistencyScore,
      bonusScore: bonusScore,
      penaltyScore: penaltyScore,
      scoreVersion: scoreVersion,
      isFinalized: isFinalized ?? this.isFinalized,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DailyScore create({
    required DateTime date,
    int totalScore = 0,
    int taskScore = 0,
    int plannerScore = 0,
    int habitScore = 0,
    int focusScore = 0,
    int stepsScore = 0,
    int workoutScore = 0,
    int sleepScore = 0,
    int goalScore = 0,
    int consistencyScore = 0,
    int bonusScore = 0,
    int penaltyScore = 0,
    String scoreVersion = '1.1',
    bool isFinalized = false,
  }) {
    final now = DateTime.now();
    return DailyScore(
      date: date,
      totalScore: totalScore,
      taskScore: taskScore,
      plannerScore: plannerScore,
      habitScore: habitScore,
      focusScore: focusScore,
      stepsScore: stepsScore,
      workoutScore: workoutScore,
      sleepScore: sleepScore,
      goalScore: goalScore,
      consistencyScore: consistencyScore,
      bonusScore: bonusScore,
      penaltyScore: penaltyScore,
      scoreVersion: scoreVersion,
      isFinalized: isFinalized,
      createdAt: now,
      updatedAt: now,
    );
  }
}
