import 'package:isar_community/isar_community.dart';

part 'personal_record.g.dart';

/// Tracks the highest achievements for the user across different metrics.
/// Supports: Highest Daily/Weekly/Monthly Score, Longest Streak, 
/// Most Steps, Longest Workout, Longest Focus, Best Week/Month.
@collection
class PersonalRecord {
  Id id = Isar.autoIncrement;

  /// The type of record. 
  /// Supported types: 'highest_daily_score', 'highest_weekly_score', 
  /// 'highest_monthly_score', 'longest_streak', 'most_steps', 
  /// 'longest_workout', 'longest_focus', 'best_week', 'best_month'.
  @Index(unique: true, replace: true)
  late String recordType;

  /// The value achieved.
  late double value;

  /// When this record was achieved.
  late DateTime achievedAt;

  late DateTime updatedAt;

  PersonalRecord();

  PersonalRecord.create({
    required this.recordType,
    required this.value,
    required this.achievedAt,
  }) {
    updatedAt = DateTime.now();
  }
}
