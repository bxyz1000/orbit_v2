import 'package:isar_community/isar_community.dart';

part 'daily_score.g.dart';

/// Represents the finalized Orbit Score for a specific day.
@collection
class DailyScore {
  Id id = Isar.autoIncrement;

  /// The date this score belongs to (normalized to 00:00:00).
  @Index(unique: true, replace: true)
  late DateTime date;

  /// Total combined score for the day.
  late int totalScore;

  // Breakdown fields as per v1.1 documentation
  late int taskScore;
  late int plannerScore;
  late int habitScore;
  late int focusScore;
  late int stepsScore;
  late int workoutScore;
  late int sleepScore;
  late int goalScore;
  late int consistencyScore;
  late int bonusScore;
  late int penaltyScore;

  /// The version of the scoring engine used to calculate this score.
  late String scoreVersion;

  /// Whether the score has been finalized (locked at 11:59:59 PM).
  late bool isFinalized;

  late DateTime createdAt;
  late DateTime updatedAt;

  DailyScore();

  DailyScore.create({
    required this.date,
    this.totalScore = 0,
    this.taskScore = 0,
    this.plannerScore = 0,
    this.habitScore = 0,
    this.focusScore = 0,
    this.stepsScore = 0,
    this.workoutScore = 0,
    this.sleepScore = 0,
    this.goalScore = 0,
    this.consistencyScore = 0,
    this.bonusScore = 0,
    this.penaltyScore = 0,
    this.scoreVersion = '1.1',
    this.isFinalized = false,
  }) {
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }
}
