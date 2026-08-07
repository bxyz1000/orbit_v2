import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:orbit_v2/features/integrations/strava/data/services/strava_auth_service_impl.dart';
import 'package:orbit_v2/features/integrations/strava/domain/entities/strava_auth_token.dart';
import 'package:orbit_v2/features/integrations/strava/domain/services/i_strava_token_storage.dart';

class MockTokenStorage implements IStravaTokenStorage {
  StravaAuthToken? _token;

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
  group('Strava Token Manager & Auth Service Tests', () {
    late MockTokenStorage mockStorage;

    setUp(() {
      mockStorage = MockTokenStorage();
    });

    test('detects expired token correctly based on safety buffer', () {
      final validToken = StravaAuthToken(
        accessToken: 'access_123',
        refreshToken: 'refresh_123',
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
        athleteId: '1111',
      );

      final expiringSoonToken = StravaAuthToken(
        accessToken: 'access_123',
        refreshToken: 'refresh_123',
        expiresAt: DateTime.now().add(const Duration(minutes: 3)), // within 5m buffer
        athleteId: '1111',
      );

      final expiredToken = StravaAuthToken(
        accessToken: 'access_123',
        refreshToken: 'refresh_123',
        expiresAt: DateTime.now().subtract(const Duration(minutes: 10)),
        athleteId: '1111',
      );

      expect(validToken.isExpired, isFalse);
      expect(expiringSoonToken.isExpired, isTrue);
      expect(expiredToken.isExpired, isTrue);
    });

    test('exchanges authorization code for token successfully', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, endsWith('/token'));
        expect(request.bodyFields['code'], equals('auth_code_999'));
        expect(request.bodyFields['grant_type'], equals('authorization_code'));

        return http.Response(
          json.encode({
            'access_token': 'new_access_token_123',
            'refresh_token': 'new_refresh_token_456',
            'expires_at': DateTime.now().add(const Duration(hours: 6)).millisecondsSinceEpoch ~/ 1000,
            'athlete': {
              'id': 12345,
              'firstname': 'Orbit',
              'lastname': 'User',
            },
          }),
          200,
        );
      });

      final authService = StravaAuthServiceImpl(
        tokenStorage: mockStorage,
        httpClient: mockClient,
        clientId: 'test_client_id',
        clientSecret: 'test_client_secret',
      );

      final token = await authService.authenticateWithCode('auth_code_999');

      expect(token.accessToken, equals('new_access_token_123'));
      expect(token.refreshToken, equals('new_refresh_token_456'));
      expect(token.athleteId, equals('12345'));
      expect(token.athleteName, equals('Orbit User'));

      final storedToken = await mockStorage.getToken();
      expect(storedToken?.accessToken, equals('new_access_token_123'));
    });

    test('refreshes expired token automatically when getValidToken is called', () async {
      final oldExpiredToken = StravaAuthToken(
        accessToken: 'old_access',
        refreshToken: 'old_refresh',
        expiresAt: DateTime.now().subtract(const Duration(hours: 1)),
        athleteId: '5555',
        athleteName: 'Athlete',
      );
      await mockStorage.saveToken(oldExpiredToken);

      final mockClient = MockClient((request) async {
        expect(request.bodyFields['grant_type'], equals('refresh_token'));
        expect(request.bodyFields['refresh_token'], equals('old_refresh'));

        return http.Response(
          json.encode({
            'access_token': 'refreshed_access_789',
            'refresh_token': 'refreshed_refresh_000',
            'expires_at': DateTime.now().add(const Duration(hours: 6)).millisecondsSinceEpoch ~/ 1000,
          }),
          200,
        );
      });

      final authService = StravaAuthServiceImpl(
        tokenStorage: mockStorage,
        httpClient: mockClient,
        clientId: 'test_client_id',
        clientSecret: 'test_client_secret',
      );

      final validToken = await authService.getValidToken();

      expect(validToken, isNotNull);
      expect(validToken!.accessToken, equals('refreshed_access_789'));
      expect(validToken.refreshToken, equals('refreshed_refresh_000'));
      expect(validToken.athleteId, equals('5555'));

      final stored = await mockStorage.getToken();
      expect(stored?.accessToken, equals('refreshed_access_789'));
    });

    test('clears stored credentials on disconnect', () async {
      final token = StravaAuthToken(
        accessToken: 'active_access',
        refreshToken: 'active_refresh',
        expiresAt: DateTime.now().add(const Duration(hours: 2)),
        athleteId: '777',
      );
      await mockStorage.saveToken(token);

      final mockClient = MockClient((request) async {
        expect(request.url.path, endsWith('/deauthorize'));
        return http.Response('', 200);
      });

      final authService = StravaAuthServiceImpl(
        tokenStorage: mockStorage,
        httpClient: mockClient,
      );

      await authService.disconnect();

      final stored = await mockStorage.getToken();
      expect(stored, isNull);
    });
  });
}
