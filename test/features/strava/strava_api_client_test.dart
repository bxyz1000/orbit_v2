import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:orbit_v2/features/integrations/strava/data/datasources/strava_api_client.dart';

void main() {
  group('StravaApiClient Tests', () {
    test('fetches athlete activities and maps correctly', () async {
      final mockClient = MockClient((request) async {
        expect(request.headers['Authorization'], equals('Bearer valid_access_token'));
        expect(request.url.queryParameters['page'], equals('1'));
        expect(request.url.queryParameters['per_page'], equals('30'));

        return http.Response(
          json.encode([
            {
              'id': 101,
              'name': 'Trail Run',
              'type': 'Run',
              'start_date_local': '2026-08-07T06:00:00Z',
              'elapsed_time': 2400,
              'moving_time': 2200,
              'distance': 6000.0,
              'total_elevation_gain': 120.0,
              'average_speed': 2.72,
              'max_speed': 3.9,
              'calories': 450.0,
            }
          ]),
          200,
        );
      });

      final apiClient = StravaApiClient(httpClient: mockClient);
      final activities = await apiClient.getActivities(accessToken: 'valid_access_token');

      expect(activities.length, equals(1));
      expect(activities.first.id, equals('101'));
      expect(activities.first.name, equals('Trail Run'));
      expect(activities.first.distance, equals(6000.0));
    });

    test('handles empty activity history gracefully without errors', () async {
      final mockClient = MockClient((request) async {
        return http.Response('[]', 200);
      });

      final apiClient = StravaApiClient(httpClient: mockClient);
      final activities = await apiClient.getActivities(accessToken: 'valid_access_token');

      expect(activities, isEmpty);
    });

    test('throws StravaAuthException on HTTP 401 Unauthorized', () async {
      final mockClient = MockClient((request) async {
        return http.Response('{"message": "Authorization Error"}', 401);
      });

      final apiClient = StravaApiClient(httpClient: mockClient);

      expect(
        () async => await apiClient.getActivities(accessToken: 'invalid_token'),
        throwsA(isA<StravaAuthException>()),
      );
    });

    test('throws StravaRateLimitException on HTTP 429 Rate Limit', () async {
      final mockClient = MockClient((request) async {
        return http.Response('{"message": "Rate Limit Exceeded"}', 429);
      });

      final apiClient = StravaApiClient(httpClient: mockClient);

      expect(
        () async => await apiClient.getActivities(accessToken: 'valid_token'),
        throwsA(isA<StravaRateLimitException>()),
      );
    });

    test('throws StravaParseException on malformed JSON response', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Invalid Non-JSON Content', 200);
      });

      final apiClient = StravaApiClient(httpClient: mockClient);

      expect(
        () async => await apiClient.getActivities(accessToken: 'valid_token'),
        throwsA(isA<StravaParseException>()),
      );
    });
  });
}
