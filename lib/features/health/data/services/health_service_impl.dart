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
      debugPrint('HealthService: Checking authorization...');
      final hasPermissions = await _health.hasPermissions(_types);
      debugPrint('HealthService: Has permissions: $hasPermissions');
      return hasPermissions ?? false;
    } catch (e) {
      debugPrint('HealthService: Error checking authorization: $e');
      return false;
    }
  }

  @override
  Future<bool> requestAuthorization() async {
    try {
      debugPrint('HealthService: Initializing client (configure)...');
      // On Android, configure() is necessary to initialize Health Connect
      await _health.configure();
      
      debugPrint('HealthService: Checking if Health Connect is available...');
      // Note: The 'health' package doesn't have a direct 'isAvailable' for Health Connect in v11
      // but requestAuthorization will handle it.
      
      debugPrint('HealthService: Requesting authorization for types: $_types');
      final result = await _health.requestAuthorization(_types);
      debugPrint('HealthService: Authorization result: $result');
      
      return result;
    } catch (e) {
      debugPrint('HealthService: Exception during requestAuthorization: $e');
      // If it's a specific Health Connect error, we might see it here
      rethrow;
    }
  }

  @override
  Future<HealthSnapshot> getHealthSnapshot(DateTime date) async {
    debugPrint('HealthService: Fetching snapshot for $date');
    final midnight = DateTime(date.year, date.month, date.day);
    final tomorrow = midnight.add(const Duration(days: 1));

    int steps = 0;
    double calories = 0;
    double distance = 0;
    int activeMinutes = 0;
    int sleepMinutes = 0;
    int workoutMinutes = 0;

    try {
      // Ensure configured
      await _health.configure();

      // Steps
      debugPrint('HealthService: Fetching total steps...');
      final stepsCount = await _health.getTotalStepsInInterval(midnight, tomorrow);
      steps = stepsCount ?? 0;
      debugPrint('HealthService: Steps read: $steps');

      // Others via getHealthDataFromTypes (Named parameters in v11)
      debugPrint('HealthService: Fetching other health data types...');
      final data = await _health.getHealthDataFromTypes(
        startTime: midnight,
        endTime: tomorrow,
        types: _types,
      );
      debugPrint('HealthService: Data points received: ${data.length}');

      for (var point in data) {
        switch (point.type) {
          case HealthDataType.ACTIVE_ENERGY_BURNED:
            calories += (double.tryParse(point.value.toString()) ?? 0.0);
            break;
          case HealthDataType.DISTANCE_DELTA:
            distance += (double.tryParse(point.value.toString()) ?? 0.0);
            break;
          case HealthDataType.EXERCISE_TIME:
            activeMinutes += (int.tryParse(point.value.toString()) ?? 0);
            break;
          case HealthDataType.SLEEP_SESSION:
            final start = point.dateFrom;
            final end = point.dateTo;
            sleepMinutes += end.difference(start).inMinutes.toInt();
            break;
          case HealthDataType.WORKOUT:
            final start = point.dateFrom;
            final end = point.dateTo;
            workoutMinutes += end.difference(start).inMinutes.toInt();
            break;
          default:
            break;
        }
      }
    } catch (e) {
      debugPrint('HealthService: Error fetching health snapshot: $e');
    }

    return HealthSnapshot(
      steps: steps,
      calories: calories,
      distance: distance,
      activeMinutes: activeMinutes,
      sleepMinutes: sleepMinutes,
      workoutMinutes: workoutMinutes,
      timestamp: DateTime.now(),
    );
  }
}
