import 'package:isar_community/isar.dart';
import '../../domain/entities/daily_score.dart';

part 'daily_score_model.g.dart';

@collection
class DailyScoreModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late DateTime date;

  late int totalScore;
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
  late String scoreVersion;
  late bool isFinalized;
  late DateTime createdAt;
  late DateTime updatedAt;

  DailyScoreModel();

  factory DailyScoreModel.fromEntity(DailyScore score) {
    return DailyScoreModel()
      ..date = score.date
      ..totalScore = score.totalScore
      ..taskScore = score.taskScore
      ..plannerScore = score.plannerScore
      ..habitScore = score.habitScore
      ..focusScore = score.focusScore
      ..stepsScore = score.stepsScore
      ..workoutScore = score.workoutScore
      ..sleepScore = score.sleepScore
      ..goalScore = score.goalScore
      ..consistencyScore = score.consistencyScore
      ..bonusScore = score.bonusScore
      ..penaltyScore = score.penaltyScore
      ..scoreVersion = score.scoreVersion
      ..isFinalized = score.isFinalized
      ..createdAt = score.createdAt
      ..updatedAt = score.updatedAt;
  }

  DailyScore toEntity() {
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
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
