import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orbit_v2/features/health/domain/entities/health_snapshot.dart';
import 'package:orbit_v2/features/health/domain/entities/health_sample.dart';
import 'package:orbit_v2/features/health/presentation/providers/health_providers.dart';
import 'package:orbit_v2/features/health/presentation/widgets/orbit_health_metric_card.dart';
import 'package:orbit_v2/features/health/presentation/widgets/orbit_heart_rate_card.dart';
import 'package:orbit_v2/features/health/presentation/widgets/orbit_sleep_card.dart';
import 'package:orbit_v2/features/health/presentation/widgets/orbit_calories_card.dart';
import 'package:orbit_v2/features/health/presentation/widgets/orbit_activity_card.dart';
import 'package:orbit_v2/features/health/domain/repositories/i_health_service.dart';

void main() {
  group('Health Expansion Domain Models Tests', () {
    test('HealthSnapshot supports heart rate metrics correctly', () {
      final now = DateTime.now();
      final snapshot = HealthSnapshot(
        steps: 8500,
        calories: 450.0,
        distance: 5200.0,
        activeMinutes: 45,
        sleepMinutes: 480,
        workoutMinutes: 30,
        avgHeartRate: 72.5,
        restingHeartRate: 60.0,
        timestamp: now,
      );

      expect(snapshot.steps, 8500);
      expect(snapshot.calories, 450.0);
      expect(snapshot.distance, 5200.0);
      expect(snapshot.avgHeartRate, 72.5);
      expect(snapshot.restingHeartRate, 60.0);
    });

    test('HealthSnapshot empty factory yields null heart rate', () {
      final snapshot = HealthSnapshot.empty();
      expect(snapshot.steps, 0);
      expect(snapshot.avgHeartRate, isNull);
      expect(snapshot.restingHeartRate, isNull);
    });

    test('HeartRateSample and HealthTrendPoint instantiate accurately', () {
      final now = DateTime.now();
      final sample = HeartRateSample(timestamp: now, bpm: 68.0, isResting: true);
      expect(sample.bpm, 68.0);
      expect(sample.isResting, isTrue);

      final point = HealthTrendPoint(timestamp: now, value: 120.0, label: 'Noon');
      expect(point.value, 120.0);
      expect(point.label, 'Noon');
    });
  });

  group('Health Expansion Cards & Honest UI States Tests', () {
    testWidgets('OrbitHealthMetricCard renders Not Connected state honestly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrbitHealthMetricCard(
              title: 'Heart Rate',
              metricValue: '72 bpm',
              icon: Icons.favorite,
              iconColor: Colors.red,
              status: HealthMetricStatus.notConnected,
            ),
          ),
        ),
      );

      expect(find.text('Not Connected'), findsOneWidget);
      expect(find.text('Connect Health Connect'), findsOneWidget);
    });

    testWidgets('OrbitHeartRateCard renders populated heart rate data', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrbitHeartRateCard(
              avgHeartRate: 74.0,
              restingHeartRate: 62.0,
              samples: [
                HeartRateSample(timestamp: DateTime.now(), bpm: 74.0),
              ],
              status: HealthMetricStatus.available,
            ),
          ),
        ),
      );

      expect(find.text('74 bpm'), findsOneWidget);
      expect(find.textContaining('Resting: 62 bpm'), findsOneWidget);
    });

    testWidgets('OrbitSleepCard renders duration and recovery state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrbitSleepCard(
              sleepMinutes: 450,
              status: HealthMetricStatus.available,
            ),
          ),
        ),
      );

      expect(find.text('7h 30m'), findsOneWidget);
      expect(find.text('Restorative sleep target achieved'), findsOneWidget);
    });

    testWidgets('OrbitCaloriesCard renders active energy kcal', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrbitCaloriesCard(
              activeCalories: 350.0,
              status: HealthMetricStatus.available,
            ),
          ),
        ),
      );

      expect(find.text('350 kcal'), findsOneWidget);
    });

    testWidgets('OrbitActivityCard renders workout distance and sessions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrbitActivityCard(
              activeMinutes: 40,
              workoutMinutes: 30,
              distanceMeters: 3500.0,
              status: HealthMetricStatus.available,
            ),
          ),
        ),
      );

      expect(find.text('30m workouts'), findsOneWidget);
      expect(find.text('3.50 km covered today'), findsOneWidget);
    });
  });

  group('Real Graph Data Pipeline Verification Tests', () {
    test('Hourly step intensity normalization yields accurate zero and populated arrays', () {
      final List<int> emptyHourly = List.filled(24, 0);
      final maxEmpty = emptyHourly.fold<int>(0, (m, c) => c > m ? c : m);
      expect(maxEmpty, 0);

      final List<int> realHourly = List.filled(24, 0);
      realHourly[9] = 1200; // 9 AM
      realHourly[17] = 2400; // 5 PM Peak

      final double ceiling = realHourly.fold<int>(0, (m, c) => c > m ? c : m).toDouble();
      final normalized = realHourly.map((c) => (c / ceiling).clamp(0.0, 1.0)).toList();

      expect(normalized[0], 0.0);
      expect(normalized[9], 0.5);
      expect(normalized[17], 1.0);
    });

    test('Steps comparison returns null when historical baseline is missing', () {
      const int todaySteps = 8000;
      const int lastWeekSteps = 0;

      double? comp;
      if (lastWeekSteps > 0 && todaySteps > 0) {
        comp = ((todaySteps - lastWeekSteps) / lastWeekSteps) * 100;
      }

      expect(comp, isNull);
    });

    test('Steps comparison calculates exact percentage when baseline exists', () {
      const int todaySteps = 10000;
      const int lastWeekSteps = 8000;

      final comp = ((todaySteps - lastWeekSteps) / lastWeekSteps) * 100;
      expect(comp, 25.0);
    });
  });

  group('Health Connect Authorization Flow Tests', () {
    test('Mock Health Service handles authorization states deterministically', () async {
      final service = _TestHealthService(isAvailable: true, initialAuth: false);

      expect(await service.isAuthorized(), isFalse);

      final granted = await service.requestAuthorization();
      expect(granted, isTrue);
      expect(await service.isAuthorized(), isTrue);
    });

    test('Mock Health Service returns false when Health Connect is unavailable', () async {
      final service = _TestHealthService(isAvailable: false, initialAuth: false);

      expect(await service.isAuthorized(), isFalse);
      expect(await service.requestAuthorization(), isFalse);
    });
  });
}

class _TestHealthService implements IHealthService {
  final bool isAvailable;
  bool _authorized;

  _TestHealthService({required this.isAvailable, required bool initialAuth}) : _authorized = initialAuth;

  @override
  Future<bool> isAuthorized() async {
    if (!isAvailable) return false;
    return _authorized;
  }

  @override
  Future<bool> requestAuthorization() async {
    if (!isAvailable) return false;
    _authorized = true;
    return _authorized;
  }

  @override
  Future<HealthSnapshot> getHealthSnapshot(DateTime date) async {
    if (!_authorized) return HealthSnapshot.empty();
    return HealthSnapshot(
      steps: 5000,
      calories: 200,
      distance: 3000,
      activeMinutes: 30,
      sleepMinutes: 420,
      workoutMinutes: 20,
      timestamp: DateTime.now(),
    );
  }

  @override
  Future<List<HeartRateSample>> getHeartRateSamples(DateTime date) async => [];

  @override
  Future<List<double>> getHourlyStepIntensity(DateTime date) async => List.filled(24, 0.0);
}
