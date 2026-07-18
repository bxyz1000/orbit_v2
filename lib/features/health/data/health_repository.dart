import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';
import '../domain/health_metrics.dart';
import '../domain/repositories/i_health_service.dart';
import '../domain/entities/health_snapshot.dart';

class HealthRepository {
  final Isar _isar;
  final IHealthService? _healthService;

  HealthRepository(this._isar, [this._healthService]);

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
      debugPrint('HealthRepo: [WARN] Sync skipped - HealthService is null');
      return;
    }
    
    debugPrint('HealthRepo: [1] Starting sync for $date');
    final isAuthorized = await _healthService!.isAuthorized();
    if (!isAuthorized) {
      debugPrint('HealthRepo: [WARN] Sync skipped - Not authorized');
      return;
    }

    final snapshot = await _healthService!.getHealthSnapshot(date);
    debugPrint('HealthRepo: [2] Snapshot received from service: steps=${snapshot.steps}');
    
    await _isar.writeTxn(() async {
      debugPrint('HealthRepo: [3] Writing StepLog to Isar (Count: ${snapshot.steps})');
      final stepLog = StepLog.create(
        date: DateTime(date.year, date.month, date.day), 
        count: snapshot.steps,
        calories: snapshot.calories,
        distance: snapshot.distance,
      );
      await _isar.stepLogs.put(stepLog);

      if (snapshot.sleepMinutes > 0) {
        debugPrint('HealthRepo: [4] Writing SleepLog to Isar (${snapshot.sleepMinutes} min)');
        final sleepLog = SleepLog.create(
          date: DateTime(date.year, date.month, date.day), 
          durationMinutes: snapshot.sleepMinutes
        );
        await _isar.sleepLogs.put(sleepLog);
      }

      if (snapshot.workoutMinutes > 0) {
        debugPrint('HealthRepo: [5] Writing WorkoutLog to Isar (${snapshot.workoutMinutes} min)');
        final workoutLog = WorkoutLog.create(
          date: date, 
          durationMinutes: snapshot.workoutMinutes,
          type: 'Synced from Health Connect'
        );
        await _isar.workoutLogs.put(workoutLog);
      }
    });
    debugPrint('HealthRepo: [6] Sync transaction successfully committed');
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
