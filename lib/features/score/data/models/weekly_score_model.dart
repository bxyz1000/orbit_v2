import 'package:isar_community/isar.dart';
import '../../domain/entities/weekly_score.dart';

part 'weekly_score_model.g.dart';

@collection
class WeeklyScoreModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late DateTime weekStartDate;

  late int totalScore;
  late double averageDailyScore;
  late int taskScore;
  late int habitScore;
  late int focusScore;
  late int healthScore;
  late String scoreVersion;
  late DateTime createdAt;
  late DateTime updatedAt;

  WeeklyScoreModel();

  factory WeeklyScoreModel.fromEntity(WeeklyScore score) {
    return WeeklyScoreModel()
      ..weekStartDate = score.weekStartDate
      ..totalScore = score.totalScore
      ..averageDailyScore = score.averageDailyScore
      ..taskScore = score.taskScore
      ..habitScore = score.habitScore
      ..focusScore = score.focusScore
      ..healthScore = score.healthScore
      ..scoreVersion = score.scoreVersion
      ..createdAt = score.createdAt
      ..updatedAt = score.updatedAt;
  }

  WeeklyScore toEntity() {
    return WeeklyScore(
      weekStartDate: weekStartDate,
      totalScore: totalScore,
      averageDailyScore: averageDailyScore,
      taskScore: taskScore,
      habitScore: habitScore,
      focusScore: focusScore,
      healthScore: healthScore,
      scoreVersion: scoreVersion,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
