import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import '../../domain/entities/health_snapshot.dart';
import '../../domain/repositories/i_health_service.dart';

class HealthServiceImpl implements IHealthService {
  final Health _health = Health();

  final List<HealthDataType> _types = [
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.DISTANCE_DELTA,
    HealthDataType.EXERCISE_TIME,
    HealthDataType.SLEEP_SESSION,
    HealthDataType.WORKOUT,
  ];

  @override
  Future<bool> isAuthorized() async {
    try {
      debugPrint('HealthService: [1] Checking authorization...');
      final hasPermissions = await _health.hasPermissions(_types);
      debugPrint('HealthService: [2] Has permissions result: $hasPermissions');
      return hasPermissions ?? false;
    } catch (e) {
      debugPrint('HealthService: [ERR] Error checking authorization: $e');
      return false;
    }
  }

  @override
  Future<bool> requestAuthorization() async {
    try {
      debugPrint('HealthService: [1] Configuring client for auth...');
      await _health.configure();
      
      debugPrint('HealthService: [2] Requesting authorization for types: $_types');
      final result = await _health.requestAuthorization(_types);
      debugPrint('HealthService: [3] Authorization request result: $result');
      
      return result;
    } catch (e) {
      debugPrint('HealthService: [ERR] Exception during requestAuthorization: $e');
      rethrow;
    }
  }

  @override
  Future<HealthSnapshot> getHealthSnapshot(DateTime date) async {
    final now = DateTime.now();
    final midnight = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final isToday = date.day == now.day && date.month == now.month && date.year == now.year;
    final endTime = isToday ? now : midnight.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));

    debugPrint('HealthService: [1] BEGIN snapshot query for $date');
    debugPrint('HealthService: [2] Range: $midnight to $endTime');

    int steps = 0;
    double calories = 0;
    double distance = 0;
    int activeMinutes = 0;
    int sleepMinutes = 0;
    int workoutMinutes = 0;

    try {
      debugPrint('HealthService: [4] Calling health.configure()...');
      await _health.configure();

      // 1. Total Steps
      debugPrint('HealthService: [5] Querying getTotalStepsInInterval...');
      try {
        final stepsCount = await _health.getTotalStepsInInterval(midnight, endTime);
        steps = stepsCount ?? 0;
        debugPrint('HealthService: [6] Aggregated steps result: $steps');
      } catch (e) {
        debugPrint('HealthService: [ERR] getTotalStepsInInterval failed: $e');
      }

      // 2. Raw Data Points
      debugPrint('HealthService: [7] Querying getHealthDataFromTypes for $_types');
      final data = await _health.getHealthDataFromTypes(
        startTime: midnight,
        endTime: endTime,
        types: _types,
      );
      
      debugPrint('HealthService: [8] Raw query completed. Count: ${data.length}');

      int stepsFromPoints = 0;
      for (var point in data) {
        final type = point.type;
        final value = point.value;
        
        switch (type) {
          case HealthDataType.STEPS:
            final s = int.tryParse(value.toString()) ?? 0;
            stepsFromPoints += s;
            break;
          case HealthDataType.ACTIVE_ENERGY_BURNED:
            calories += (double.tryParse(value.toString()) ?? 0.0);
            break;
          case HealthDataType.DISTANCE_DELTA:
            distance += (double.tryParse(value.toString()) ?? 0.0);
            break;
          case HealthDataType.EXERCISE_TIME:
            activeMinutes += (int.tryParse(value.toString()) ?? 0);
            break;
          case HealthDataType.SLEEP_SESSION:
            final dur = point.dateTo.difference(point.dateFrom).inMinutes;
            sleepMinutes += dur;
            break;
          case HealthDataType.WORKOUT:
            final dur = point.dateTo.difference(point.dateFrom).inMinutes;
            workoutMinutes += dur;
            break;
          default:
            break;
        }
      }

      if (steps == 0 && stepsFromPoints > 0) {
        debugPrint('HealthService: [9] getTotalStepsInInterval was 0, but found $stepsFromPoints steps in points. Using sum.');
        steps = stepsFromPoints;
      }
      
      debugPrint('HealthService: [10] MAPPING FINISHED');
      debugPrint('  - Steps: $steps');
      debugPrint('  - Calories: $calories');
      debugPrint('  - Distance: $distance');
      debugPrint('  - Active: $activeMinutes');
      debugPrint('  - Sleep: $sleepMinutes');
      debugPrint('  - Workout: $workoutMinutes');

    } catch (e, stack) {
      debugPrint('HealthService: [FATAL] Retrieval failed: $e');
      debugPrint('$stack');
    }

    return HealthSnapshot(
      steps: steps,
      calories: calories,
      distance: distance,
      activeMinutes: activeMinutes,
      sleepMinutes: sleepMinutes,
      workoutMinutes: workoutMinutes,
      timestamp: now,
    );
  }
}
