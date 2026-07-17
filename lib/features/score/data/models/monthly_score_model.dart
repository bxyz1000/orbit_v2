import 'package:isar_community/isar.dart';
import '../../domain/entities/monthly_score.dart';

part 'monthly_score_model.g.dart';

@collection
class MonthlyScoreModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late DateTime monthStartDate;

  late int totalScore;
  late int taskScore;
  late int habitScore;
  late int focusScore;
  late int healthScore;
  late String scoreVersion;
  late DateTime createdAt;
  late DateTime updatedAt;

  MonthlyScoreModel();

  factory MonthlyScoreModel.fromEntity(MonthlyScore score) {
    return MonthlyScoreModel()
      ..monthStartDate = score.monthStartDate
      ..totalScore = score.totalScore
      ..taskScore = score.taskScore
      ..habitScore = score.habitScore
      ..focusScore = score.focusScore
      ..healthScore = score.healthScore
      ..scoreVersion = score.scoreVersion
      ..createdAt = score.createdAt
      ..updatedAt = score.updatedAt;
  }

  MonthlyScore toEntity() {
    return MonthlyScore(
      monthStartDate: monthStartDate,
      totalScore: totalScore,
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
