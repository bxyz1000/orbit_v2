import 'package:isar_community/isar.dart';
import '../../domain/entities/daily_score.dart';
import '../../domain/entities/weekly_score.dart';
import '../../domain/entities/monthly_score.dart';
import '../models/daily_score_model.dart';
import '../models/weekly_score_model.dart';
import '../models/monthly_score_model.dart';

/// Data layer for persisting and retrieving Orbit Scores.
class ScoreRepository {
  final Isar _isar;

  ScoreRepository(this._isar);

  /// Retrieves the DailyScore for a specific date.
  Future<DailyScore?> getDailyScore(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final model = await _isar.dailyScoreModels.filter().dateEqualTo(startOfDay).findFirst();
    return model?.toEntity();
  }

  /// Saves or updates a DailyScore. 
  Future<void> saveDailyScore(DailyScore score) async {
    final model = DailyScoreModel.fromEntity(score);
    await _isar.writeTxn(() async {
      await _isar.dailyScoreModels.put(model);
    });
  }

  /// Retrieves the WeeklyScore for a given week start date.
  Future<WeeklyScore?> getWeeklyScore(DateTime weekStart) async {
    final normalized = DateTime(weekStart.year, weekStart.month, weekStart.day);
    final model = await _isar.weeklyScoreModels.filter().weekStartDateEqualTo(normalized).findFirst();
    return model?.toEntity();
  }

  /// Saves or updates a WeeklyScore.
  Future<void> saveWeeklyScore(WeeklyScore score) async {
    final model = WeeklyScoreModel.fromEntity(score);
    await _isar.writeTxn(() async {
      await _isar.weeklyScoreModels.put(model);
    });
  }

  /// Retrieves the MonthlyScore for a given month start date.
  Future<MonthlyScore?> getMonthlyScore(DateTime monthStart) async {
    final normalized = DateTime(monthStart.year, monthStart.month, 1);
    final model = await _isar.monthlyScoreModels.filter().monthStartDateEqualTo(normalized).findFirst();
    return model?.toEntity();
  }

  /// Saves or updates a MonthlyScore.
  Future<void> saveMonthlyScore(MonthlyScore score) async {
    final model = MonthlyScoreModel.fromEntity(score);
    await _isar.writeTxn(() async {
      await _isar.monthlyScoreModels.put(model);
    });
  }

  /// Streams updates for a specific day's score.
  Stream<DailyScore?> streamDailyScore(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    return _isar.dailyScoreModels
        .filter()
        .dateEqualTo(startOfDay)
        .watch(fireImmediately: true)
        .map((models) => models.isNotEmpty ? models.first.toEntity() : null);
  }

  /// Watches for any changes in the daily scores collection.
  Stream<void> watchAllScores() => _isar.dailyScoreModels.watchLazy();
}
