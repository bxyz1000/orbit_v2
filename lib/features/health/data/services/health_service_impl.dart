import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import '../../domain/entities/health_snapshot.dart';
import '../../domain/entities/health_sample.dart';
import '../../domain/repositories/i_health_service.dart';

class HealthServiceImpl implements IHealthService {
  final Health _health = Health();

  final List<HealthDataType> _types = [
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.TOTAL_CALORIES_BURNED,
    HealthDataType.DISTANCE_DELTA,
    HealthDataType.SLEEP_SESSION,
    HealthDataType.WORKOUT,
    HealthDataType.HEART_RATE,
    HealthDataType.RESTING_HEART_RATE,
    HealthDataType.EXERCISE_TIME,
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

    int steps = 0;
    double calories = 0;
    double? totalCalories;
    double distance = 0;
    int activeMinutes = 0;
    int sleepMinutes = 0;
    int workoutMinutes = 0;

    double heartRateSum = 0;
    int heartRateCount = 0;
    double? restingHeartRate;

    try {
      await _health.configure();

      // 1. Total Steps
      try {
        final stepsCount = await _health.getTotalStepsInInterval(midnight, endTime);
        steps = stepsCount ?? 0;
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
          case HealthDataType.TOTAL_CALORIES_BURNED:
            totalCalories = (totalCalories ?? 0.0) + (double.tryParse(value.toString()) ?? 0.0);
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
          case HealthDataType.HEART_RATE:
            final bpm = double.tryParse(value.toString()) ?? 0.0;
            if (bpm > 0) {
              heartRateSum += bpm;
              heartRateCount++;
            }
            break;
          case HealthDataType.RESTING_HEART_RATE:
            final rBpm = double.tryParse(value.toString()) ?? 0.0;
            if (rBpm > 0) {
              restingHeartRate = rBpm;
            }
            break;
          default:
            break;
        }
      }

      if (steps == 0 && stepsFromPoints > 0) {
        steps = stepsFromPoints;
      }
    } catch (e, stack) {
      debugPrint('[HEALTH] FATAL Retrieval failed: $e');
      debugPrint('[HEALTH] Stack: $stack');
    }

    final double? avgHeartRate = heartRateCount > 0 ? (heartRateSum / heartRateCount) : null;

    return HealthSnapshot(
      steps: steps,
      calories: calories,
      totalCalories: totalCalories != null && totalCalories > 0 ? totalCalories : (calories > 0 ? calories : null),
      distance: distance,
      activeMinutes: activeMinutes,
      sleepMinutes: sleepMinutes,
      workoutMinutes: workoutMinutes,
      avgHeartRate: avgHeartRate,
      restingHeartRate: restingHeartRate,
      timestamp: now,
    );
  }

  @override
  Future<List<HeartRateSample>> getHeartRateSamples(DateTime date) async {
    final midnight = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final endTime = midnight.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));

    final List<HeartRateSample> samples = [];

    try {
      await _health.configure();
      final data = await _health.getHealthDataFromTypes(
        startTime: midnight,
        endTime: endTime,
        types: [HealthDataType.HEART_RATE, HealthDataType.RESTING_HEART_RATE],
      );

      for (var point in data) {
        final bpm = double.tryParse(point.value.toString()) ?? 0.0;
        if (bpm > 0) {
          samples.add(HeartRateSample(
            timestamp: point.dateFrom,
            bpm: bpm,
            isResting: point.type == HealthDataType.RESTING_HEART_RATE,
          ));
        }
      }
      samples.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    } catch (e) {
      debugPrint('[HEALTH] getHeartRateSamples error: $e');
    }

    return samples;
  }

  @override
  Future<List<double>> getHourlyStepIntensity(DateTime date) async {
    final midnight = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final now = DateTime.now();
    final isToday = date.day == now.day && date.month == now.month && date.year == now.year;
    final endTime = isToday ? now : midnight.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));

    final List<int> hourlySteps = List.filled(24, 0);

    try {
      await _health.configure();
      final data = await _health.getHealthDataFromTypes(
        startTime: midnight,
        endTime: endTime,
        types: [HealthDataType.STEPS],
      );

      for (var point in data) {
        final hour = point.dateFrom.hour;
        if (hour >= 0 && hour < 24) {
          final count = int.tryParse(point.value.toString()) ?? 0;
          hourlySteps[hour] += count;
        }
      }
    } catch (e) {
      debugPrint('[HEALTH] getHourlyStepIntensity error: $e');
    }

    final maxHourly = hourlySteps.fold<int>(0, (max, count) => count > max ? count : max);
    if (maxHourly == 0) {
      return List.filled(24, 0.0);
    }

    final double ceiling = math.max(maxHourly.toDouble(), 1000.0);
    return hourlySteps.map((count) => (count / ceiling).clamp(0.0, 1.0)).toList();
  }
}
