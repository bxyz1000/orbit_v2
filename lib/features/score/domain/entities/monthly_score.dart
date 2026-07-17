import 'package:isar_community/isar_community.dart';

part 'monthly_score.g.dart';

/// Aggregated performance metrics for a specific month.
@collection
class MonthlyScore {
  Id id = Isar.autoIncrement;

  /// Month identifier (normalized to start of month).
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

  MonthlyScore();
}
