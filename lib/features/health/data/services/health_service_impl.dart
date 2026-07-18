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
    return await _health.hasPermissions(_types) ?? false;
  }

  @override
  Future<bool> requestAuthorization() async {
    return await _health.requestAuthorization(_types);
  }

  @override
  Future<HealthSnapshot> getHealthSnapshot(DateTime date) async {
    final midnight = DateTime(date.year, date.month, date.day);
    final tomorrow = midnight.add(const Duration(days: 1));

    int steps = 0;
    double calories = 0;
    double distance = 0;
    int activeMinutes = 0;
    int sleepMinutes = 0;
    int workoutMinutes = 0;

    try {
      // Steps
      final stepsCount = await _health.getTotalStepsInInterval(midnight, tomorrow);
      steps = stepsCount ?? 0;

      // Others via getHealthDataFromTypes (Named parameters in v11)
      final data = await _health.getHealthDataFromTypes(
        startTime: midnight,
        endTime: tomorrow,
        types: _types,
      );

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
      // Log or handle error
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
