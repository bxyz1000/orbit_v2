import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:isar_community/isar.dart';
import 'package:orbit_v2/features/integrations/data/models/integration_model.dart';
import 'package:orbit_v2/features/integrations/data/repositories/integration_repository_impl.dart';
import 'package:orbit_v2/features/integrations/strava/data/datasources/strava_api_client.dart';
import 'package:orbit_v2/features/integrations/strava/data/models/strava_activity_model.dart';
import 'package:orbit_v2/features/integrations/strava/data/repositories/strava_repository_impl.dart';
import 'package:orbit_v2/features/integrations/strava/data/services/strava_auth_service_impl.dart';
import 'package:orbit_v2/features/integrations/strava/domain/entities/strava_activity.dart';
import 'package:orbit_v2/features/integrations/strava/domain/entities/strava_auth_token.dart';
import 'package:orbit_v2/features/integrations/strava/domain/services/i_strava_token_storage.dart';
import 'package:orbit_v2/features/integrations/strava/domain/services/strava_analytics_adapter.dart';

class MockTokenStorage implements IStravaTokenStorage {
  StravaAuthToken? _token;

  MockTokenStorage(this._token);

  @override
  Future<void> clearToken() async {
    _token = null;
  }

  @override
  Future<StravaAuthToken?> getToken() async {
    return _token;
  }

  @override
  Future<void> saveToken(StravaAuthToken token) async {
    _token = token;
  }
}

void main() {
  group('Strava Sync & Repository Idempotency Tests', () {
    late Isar isar;

    setUpAll(() async {
      await Isar.initializeIsarCore(download: true);
    });

    setUp(() async {
      isar = await Isar.open(
        [IntegrationModelSchema, StravaActivityModelSchema],
        directory: '.',
        name: 'strava_sync_db',
      );

    });

    tearDown(() async {
      await isar.writeTxn(() async => await isar.clear());
      await isar.close(deleteFromDisk: true);
    });

    test('syncs activities and updates existing records without duplicates', () async {
      final tokenStorage = MockTokenStorage(
        StravaAuthToken(
          accessToken: 'valid_token_123',
          refreshToken: 'valid_refresh_123',
          expiresAt: DateTime.now().add(const Duration(hours: 5)),
          athleteId: '8888',
          athleteName: 'Athlete Tester',
        ),
      );

      int requestCount = 0;
      final mockHttpClient = MockClient((request) async {
        requestCount++;
        return http.Response(
          json.encode([
            {
              'id': 'ACT_1001',
              'name': requestCount == 1 ? 'First Sync Name' : 'Updated Sync Name',
              'type': 'Run',
              'start_date_local': '2026-08-07T08:00:00Z',
              'elapsed_time': 1800,
              'moving_time': 1800,
              'distance': 5000.0,
              'total_elevation_gain': 50.0,
              'average_speed': 2.77,
              'max_speed': 3.5,
              'calories': 400.0,
            }
          ]),
          200,
        );
      });

      final authService = StravaAuthServiceImpl(tokenStorage: tokenStorage, httpClient: mockHttpClient);
      final apiClient = StravaApiClient(httpClient: mockHttpClient);
      final integrationRepo = IntegrationRepositoryImpl(isar);

      final repo = StravaRepositoryImpl(
        isar: isar,
        authService: authService,
        apiClient: apiClient,
        integrationRepo: integrationRepo,
      );

      // First sync
      final syncedFirst = await repo.syncActivities();
      expect(syncedFirst, equals(1));

      final activitiesAfterFirst = await repo.getActivities();
      expect(activitiesAfterFirst.length, equals(1));
      expect(activitiesAfterFirst.first.name, equals('First Sync Name'));

      // Second sync (same activity ID, updated content)
      final syncedSecond = await repo.syncActivities();
      expect(syncedSecond, equals(1));

      final activitiesAfterSecond = await repo.getActivities();
      // Should NOT duplicate! Total length must still be 1.
      expect(activitiesAfterSecond.length, equals(1));
      expect(activitiesAfterSecond.first.name, equals('Updated Sync Name'));
    });

    test('calculates Strava daily analytics correctly', () {
      final now = DateTime(2026, 8, 7);
      final activities = [
        StravaActivity(
          id: '1',
          name: 'Morning Run',
          type: 'Run',
          startDate: now,
          elapsedTimeSeconds: 1800,
          movingTimeSeconds: 1800,
          distanceMeters: 5000,
          elevationGainMeters: 30,
          averageSpeed: 2.7,
          maxSpeed: 3.5,
          calories: 350,
          syncedAt: now,
        ),
        StravaActivity(
          id: '2',
          name: 'Evening Ride',
          type: 'Ride',
          startDate: now,
          elapsedTimeSeconds: 3600,
          movingTimeSeconds: 3300,
          distanceMeters: 20000,
          elevationGainMeters: 150,
          averageSpeed: 6.0,
          maxSpeed: 9.0,
          calories: 550,
          syncedAt: now,
        ),
      ];

      final aggregated = StravaAnalyticsAdapter.aggregateActivities(now, activities);

      expect(aggregated.activityCount, equals(2));
      expect(aggregated.totalDurationMinutes, equals(85)); // (1800+3300)/60
      expect(aggregated.totalDistanceKm, equals(25.0)); // 5000+20000
      expect(aggregated.totalElevationGainMeters, equals(180.0));
      expect(aggregated.totalCalories, equals(900.0));
    });
  });
}
