import '../entities/daily_score.dart';
import '../entities/personal_record.dart';

/// Business logic interface for the Orbit Score Engine.
/// Implements Score Engine v1.1.
abstract class ScoreService {
  /// Calculates the current active score for a given date by aggregating 
  /// data from all repositories.
  Future<DailyScore> calculateActiveScore(DateTime date);

  /// Calculates the weekly score aggregate for the week containing [date].
  Future<WeeklyScore> calculateWeeklyScore(DateTime date);

  /// Calculates the monthly score aggregate for the month containing [date].
  Future<MonthlyScore> calculateMonthlyScore(DateTime date);

  /// Finalizes the day's score. Locked scores become immutable.
  /// Typically called at 11:59:59 PM.
  Future<void> finalizeDay(DateTime date);

  /// Recalculates all historical scores. 
  /// Only performed when explicitly requested by the user.
  Future<void> recalculateHistoricalScores();

  /// Retrieves all personal records.
  Future<List<PersonalRecord>> getRecords();

  /// Watches the score for a specific date reactively.
  Stream<DailyScore?> watchScore(DateTime date);

  /// Get score version
  String get scoreVersion;
}
