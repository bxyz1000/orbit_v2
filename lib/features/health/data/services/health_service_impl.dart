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
    HealthDataType.SLEEP_SESSION,
    HealthDataType.WORKOUT,
  ];

  @override
  Future<bool> isAuthorized() async {
    try {
      debugPrint('[HEALTH] configure started');
      await _health.configure();
      debugPrint('[HEALTH] configure completed');

      final hasPermissions = await _health.hasPermissions(_types);
      debugPrint('[HEALTH] hasPermissions result: $hasPermissions');
      return hasPermissions ?? false;
    } catch (e, stack) {
      debugPrint('[HEALTH] ERR Error checking authorization: $e');
      debugPrint('[HEALTH] Stack: $stack');
      return false;
    }
  }

  @override
  Future<bool> requestAuthorization() async {
    try {
      debugPrint('[HEALTH] connect started');
      debugPrint('[HEALTH] configure started');
      await _health.configure();
      debugPrint('[HEALTH] configure completed');

      final hcAvailable = await _health.isHealthConnectAvailable();
      debugPrint('[HEALTH] Health Connect Available: $hcAvailable');

      debugPrint('[HEALTH] requestAuthorization started');
      debugPrint('[HEALTH] requested types: $_types');
      final result = await _health.requestAuthorization(_types);
      debugPrint('[HEALTH] requestAuthorization result: $result');

      return result;
    } catch (e, stack) {
      debugPrint('[HEALTH] ERR Exception during requestAuthorization: $e');
      debugPrint('[HEALTH] Stack: $stack');
      rethrow;
    }
  }

  @override
  Future<HealthSnapshot> getHealthSnapshot(DateTime date) async {
    final now = DateTime.now();
    final midnight = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final isToday = date.day == now.day && date.month == now.month && date.year == now.year;
    final endTime = isToday ? now : midnight.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));

    debugPrint('[HEALTH] sync started for range: $midnight to $endTime');
    debugPrint('[HEALTH] requested types: $_types');

    int steps = 0;
    double calories = 0;
    double distance = 0;
    int activeMinutes = 0;
    int sleepMinutes = 0;
    int workoutMinutes = 0;

    try {
      debugPrint('[HEALTH] configure started');
      await _health.configure();
      debugPrint('[HEALTH] configure completed');

      // 1. Total Steps
      try {
        final stepsCount = await _health.getTotalStepsInInterval(midnight, endTime);
        steps = stepsCount ?? 0;
        debugPrint('[HEALTH] getTotalStepsInInterval result: $steps');
      } catch (e, stack) {
        debugPrint('[HEALTH] ERR getTotalStepsInInterval failed: $e');
        debugPrint('[HEALTH] Stack: $stack');
      }

      // 2. Raw Data Points
      final List<HealthDataPoint> data;
      try {
        data = await _health.getHealthDataFromTypes(
          startTime: midnight,
          endTime: endTime,
          types: _types,
        );
      } catch (e, stack) {
        debugPrint('[HEALTH] ERR getHealthDataFromTypes failed: $e');
        debugPrint('[HEALTH] Stack: $stack');
        rethrow;
      }

      
      debugPrint('[HEALTH] health records returned: ${data.length}');

      if (data.isEmpty) {
        debugPrint('[HEALTH] NO RECORDS RETURNED for specified types and range ($midnight to $endTime)');
      }

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
        debugPrint('[HEALTH] getTotalStepsInInterval was 0, using sum of points: $stepsFromPoints');
        steps = stepsFromPoints;
      }

      debugPrint('[HEALTH] steps returned: $steps');
      debugPrint('[HEALTH] snapshot details: calories=$calories, distance=$distance, activeMins=$activeMinutes, sleepMins=$sleepMinutes, workoutMins=$workoutMinutes');

    } catch (e, stack) {
      debugPrint('[HEALTH] FATAL Retrieval failed: $e');
      debugPrint('[HEALTH] Stack: $stack');
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
