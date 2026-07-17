import 'package:isar_community/isar_community.dart';
import '../../domain/entities/daily_score.dart';
import '../../domain/entities/weekly_score.dart';
import '../../domain/entities/monthly_score.dart';

/// Data layer for persisting and retrieving Orbit Scores.
class ScoreRepository {
  final Isar _isar;

  ScoreRepository(this._isar);

  /// Retrieves the DailyScore for a specific date.
  Future<DailyScore?> getDailyScore(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    return await _isar.dailyScores.filter().dateEqualTo(startOfDay).findFirst();
  }

  /// Saves or updates a DailyScore. 
  /// Note: Business logic in Service layer ensures finalized scores remain immutable.
  Future<void> saveDailyScore(DailyScore score) async {
    await _isar.writeTxn(() async {
      await _isar.dailyScores.put(score);
    });
  }

  /// Retrieves the WeeklyScore for a given week start date.
  Future<WeeklyScore?> getWeeklyScore(DateTime weekStart) async {
    final normalized = DateTime(weekStart.year, weekStart.month, weekStart.day);
    return await _isar.weeklyScores.filter().weekStartDateEqualTo(normalized).findFirst();
  }

  /// Retrieves the MonthlyScore for a given month start date.
  Future<MonthlyScore?> getMonthlyScore(DateTime monthStart) async {
    final normalized = DateTime(monthStart.year, monthStart.month, 1);
    return await _isar.monthlyScores.filter().monthStartDateEqualTo(normalized).findFirst();
  }

  /// Streams updates for a specific day's score.
  Stream<DailyScore?> streamDailyScore(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    return _isar.dailyScores
        .filter()
        .dateEqualTo(startOfDay)
        .watch(fireImmediately: true)
        .map((scores) => scores.isNotEmpty ? scores.first : null);
  }

  /// Watches for any changes in the daily scores collection.
  Stream<void> watchAllScores() => _isar.dailyScores.watchLazy();
}
