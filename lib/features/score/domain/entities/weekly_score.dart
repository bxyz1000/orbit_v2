import 'package:isar_community/isar_community.dart';

part 'weekly_score.g.dart';

/// Aggregated performance metrics for a specific week.
@collection
class WeeklyScore {
  Id id = Isar.autoIncrement;

  /// Start date of the week (normalized).
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

  WeeklyScore();
}
