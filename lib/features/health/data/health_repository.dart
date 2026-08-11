import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';
import '../domain/health_metrics.dart';
import '../domain/entities/health_sample.dart';
import '../domain/repositories/i_health_service.dart';

class HealthRepository {
  final Isar _isar;
  final IHealthService? _healthService;

  HealthRepository(this._isar, [this._healthService]);

  Future<bool> isAuthorized() async {
    return await _healthService?.isAuthorized() ?? false;
  }


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

  Future<void> syncHealthData(DateTime date) async {
    if (_healthService == null) {
      debugPrint('[HEALTH] WARN Sync skipped - HealthService is null');
      return;
    }
    
    debugPrint('[HEALTH] sync started for $date');
    final isAuthorized = await _healthService.isAuthorized();
    if (!isAuthorized) {
      debugPrint('[HEALTH] WARN Sync skipped - Not authorized');
      return;
    }

    final snapshot = await _healthService.getHealthSnapshot(date);
    debugPrint('[HEALTH] snapshot received from service: steps=${snapshot.steps}');
    
    debugPrint('[HEALTH] repository write started');
    await _isar.writeTxn(() async {
      final stepLog = StepLog.create(
        date: DateTime(date.year, date.month, date.day), 
        count: snapshot.steps,
        calories: snapshot.calories,
        distance: snapshot.distance,
        activeMinutes: snapshot.activeMinutes,
      );
      await _isar.stepLogs.put(stepLog);

      if (snapshot.sleepMinutes > 0) {
        final sleepLog = SleepLog.create(
          date: DateTime(date.year, date.month, date.day), 
          durationMinutes: snapshot.sleepMinutes
        );
        await _isar.sleepLogs.put(sleepLog);
      }

      if (snapshot.workoutMinutes > 0) {
        final workoutLog = WorkoutLog.create(
          date: date, 
          durationMinutes: snapshot.workoutMinutes,
          type: 'Synced from Health Connect'
        );
        await _isar.workoutLogs.put(workoutLog);
      }
    });
    debugPrint('[HEALTH] repository write completed');
  }

  Future<List<StepLog>> getStepLogsForDateRange(DateTime start, DateTime end) async {
    final sDate = DateTime(start.year, start.month, start.day);
    final eDate = DateTime(end.year, end.month, end.day, 23, 59, 59, 999);
    final list = await _isar.stepLogs
        .filter()
        .dateGreaterThan(sDate.subtract(const Duration(milliseconds: 1)))
        .and()
        .dateLessThan(eDate)
        .findAll();
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  Future<List<SleepLog>> getSleepLogsForDateRange(DateTime start, DateTime end) async {
    final sDate = DateTime(start.year, start.month, start.day);
    final eDate = DateTime(end.year, end.month, end.day, 23, 59, 59, 999);
    final list = await _isar.sleepLogs
        .filter()
        .dateGreaterThan(sDate.subtract(const Duration(milliseconds: 1)))
        .and()
        .dateLessThan(eDate)
        .findAll();
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  Future<List<WorkoutLog>> getWorkoutLogsForDateRange(DateTime start, DateTime end) async {
    final sDate = DateTime(start.year, start.month, start.day);
    final eDate = DateTime(end.year, end.month, end.day, 23, 59, 59, 999);
    final list = await _isar.workoutLogs
        .filter()
        .dateGreaterThan(sDate.subtract(const Duration(milliseconds: 1)))
        .and()
        .dateLessThan(eDate)
        .findAll();
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  Future<List<HeartRateSample>> getHeartRateSamples(DateTime date) async {
    if (_healthService == null) return [];
    final isAuth = await _healthService.isAuthorized();
    if (!isAuth) return [];
    return await _healthService.getHeartRateSamples(date);
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
