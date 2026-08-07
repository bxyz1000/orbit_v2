import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../domain/entities/strava_auth_token.dart';
import '../../domain/services/i_strava_auth_service.dart';
import '../../domain/services/i_strava_token_storage.dart';
import '../datasources/strava_api_client.dart';

class StravaAuthServiceImpl implements IStravaAuthService {
  final IStravaTokenStorage _tokenStorage;
  final http.Client _httpClient;
  final String clientId;
  final String clientSecret;
  final String defaultRedirectUri;
  final String oauthBaseUrl;

  StravaAuthServiceImpl({
    required IStravaTokenStorage tokenStorage,
    http.Client? httpClient,
    String? clientId,
    String? clientSecret,
    String? defaultRedirectUri,
    this.oauthBaseUrl = 'https://www.strava.com/oauth',
  })  : _tokenStorage = tokenStorage,
        _httpClient = httpClient ?? http.Client(),
        clientId = clientId ?? const String.fromEnvironment('STRAVA_CLIENT_ID', defaultValue: ''),
        clientSecret = clientSecret ?? const String.fromEnvironment('STRAVA_CLIENT_SECRET', defaultValue: ''),
        defaultRedirectUri = defaultRedirectUri ?? const String.fromEnvironment('STRAVA_REDIRECT_URI', defaultValue: 'orbit://strava-auth');

  @override
  Uri getAuthorizationUrl({String? redirectUri}) {
    final redirect = redirectUri ?? defaultRedirectUri;
    return Uri.parse('$oauthBaseUrl/mobile/authorize').replace(queryParameters: {
      'client_id': clientId,
      'redirect_uri': redirect,
      'response_type': 'code',
      'approval_prompt': 'auto',
      'scope': 'read,activity:read_all',
    });
  }

  @override
  Future<StravaAuthToken> authenticateWithCode(String code, {String? redirectUri}) async {
    final redirect = redirectUri ?? defaultRedirectUri;
    try {
      final response = await _httpClient.post(
        Uri.parse('$oauthBaseUrl/token'),
        body: {
          'client_id': clientId,
          'client_secret': clientSecret,
          'code': code,
          'grant_type': 'authorization_code',
          'redirect_uri': redirect,
        },
      );

      if (response.statusCode != 200) {
        throw StravaAuthException('OAuth authorization failed with code ${response.statusCode}');
      }

      final jsonMap = json.decode(response.body) as Map<String, dynamic>;
      final token = _parseTokenResponse(jsonMap);
      await _tokenStorage.saveToken(token);
      return token;
    } catch (e) {
      if (e is StravaException) rethrow;
      throw StravaAuthException('Failed to exchange authorization code: $e');
    }
  }

  @override
  Future<StravaAuthToken> refreshToken(StravaAuthToken currentToken) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$oauthBaseUrl/token'),
        body: {
          'client_id': clientId,
          'client_secret': clientSecret,
          'refresh_token': currentToken.refreshToken,
          'grant_type': 'refresh_token',
        },
      );

      if (response.statusCode != 200) {
        throw StravaAuthException('Token refresh failed with code ${response.statusCode}');
      }

      final jsonMap = json.decode(response.body) as Map<String, dynamic>;
      final updatedToken = _parseTokenResponse(jsonMap, fallbackAthleteId: currentToken.athleteId, fallbackAthleteName: currentToken.athleteName);
      await _tokenStorage.saveToken(updatedToken);
      return updatedToken;
    } catch (e) {
      if (e is StravaException) rethrow;
      throw StravaAuthException('Failed to refresh Strava token: $e');
    }
  }

  @override
  Future<StravaAuthToken?> getValidToken() async {
    final token = await _tokenStorage.getToken();
    if (token == null) return null;

    if (!token.isExpired) {
      return token;
    }

    try {
      debugPrint('[STRAVA_AUTH] Token expired, attempting automated refresh...');
      final refreshed = await refreshToken(token);
      return refreshed;
    } catch (e) {
      debugPrint('[STRAVA_AUTH] Token refresh failed: $e');
      throw StravaAuthException('Token expired and refresh failed: $e');
    }
  }

  @override
  Future<void> disconnect() async {
    final token = await _tokenStorage.getToken();
    if (token != null) {
      try {
        await _httpClient.post(
          Uri.parse('$oauthBaseUrl/deauthorize'),
          body: {
            'access_token': token.accessToken,
          },
        );
      } catch (e) {
        debugPrint('[STRAVA_AUTH] Deauthorization request failed (clearing local credentials anyway): $e');
      }
    }
    await _tokenStorage.clearToken();
  }

  StravaAuthToken _parseTokenResponse(Map<String, dynamic> jsonMap, {String? fallbackAthleteId, String? fallbackAthleteName}) {
    final accessToken = jsonMap['access_token'] as String?;
    final refreshToken = jsonMap['refresh_token'] as String?;
    final expiresAtNum = jsonMap['expires_at'] as num?;

    if (accessToken == null || refreshToken == null || expiresAtNum == null) {
      throw StravaParseException('Missing token fields in Strava response');
    }

    final expiresAt = DateTime.fromMillisecondsSinceEpoch(expiresAtNum.toInt() * 1000);

    String athleteId = fallbackAthleteId ?? '';
    String? athleteName = fallbackAthleteName;

    if (jsonMap.containsKey('athlete') && jsonMap['athlete'] is Map<String, dynamic>) {
      final athlete = jsonMap['athlete'] as Map<String, dynamic>;
      final rawId = athlete['id'];
      if (rawId != null) athleteId = rawId.toString();

      final firstname = (athlete['firstname'] as String?) ?? '';
      final lastname = (athlete['lastname'] as String?) ?? '';
      final name = '$firstname $lastname'.trim();
      if (name.isNotEmpty) athleteName = name;
    }

    return StravaAuthToken(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
      athleteId: athleteId,
      athleteName: athleteName,
    );
  }
}
