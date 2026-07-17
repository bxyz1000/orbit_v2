import 'package:isar_community/isar_community.dart';
import '../domain/health_metrics.dart';

class HealthRepository {
  final Isar _isar;

  HealthRepository(this._isar);

  Future<StepLog?> getStepsForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    return await _isar.stepLogs.filter().dateEqualTo(startOfDay).findFirst();
  }

  Future<List<WorkoutLog>> getWorkoutsForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return await _isar.workoutLogs
        .filter()
        .dateGreaterThan(startOfDay.subtract(const Duration(seconds: 1)))
        .and()
        .dateLessThan(endOfDay)
        .findAll();
  }

  Future<SleepLog?> getSleepForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    return await _isar.sleepLogs.filter().dateEqualTo(startOfDay).findFirst();
  }

  Future<void> saveSteps(StepLog log) async {
    await _isar.writeTxn(() async {
      await _isar.stepLogs.put(log);
    });
  }

  Future<void> saveWorkout(WorkoutLog log) async {
    await _isar.writeTxn(() async {
      await _isar.workoutLogs.put(log);
    });
  }

  Future<void> saveSleep(SleepLog log) async {
    await _isar.writeTxn(() async {
      await _isar.sleepLogs.put(log);
    });
  }

  Stream<void> watchSteps() => _isar.stepLogs.watchLazy();
  Stream<void> watchWorkouts() => _isar.workoutLogs.watchLazy();
  Stream<void> watchSleep() => _isar.sleepLogs.watchLazy();
}
