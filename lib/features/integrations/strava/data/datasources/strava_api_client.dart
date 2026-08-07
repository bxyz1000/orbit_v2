import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/strava_activity_dto.dart';

class StravaException implements Exception {
  final String message;
  final int? statusCode;
  StravaException(this.message, [this.statusCode]);

  @override
  String toString() => 'StravaException: $message ${statusCode != null ? '($statusCode)' : ''}';
}

class StravaAuthException extends StravaException {
  StravaAuthException(super.message, [super.statusCode]);
}

class StravaRateLimitException extends StravaException {
  StravaRateLimitException(super.message, [super.statusCode]);
}

class StravaNetworkException extends StravaException {
  StravaNetworkException(super.message, [super.statusCode]);
}

class StravaParseException extends StravaException {
  StravaParseException(super.message, [super.statusCode]);
}

class StravaApiClient {
  final http.Client _httpClient;
  final String baseUrl;

  StravaApiClient({
    http.Client? httpClient,
    this.baseUrl = 'https://www.strava.com/api/v3',
  }) : _httpClient = httpClient ?? http.Client();

  /// Fetch authenticated athlete details.
  Future<Map<String, dynamic>> getAthleteProfile(String accessToken) async {
    final uri = Uri.parse('$baseUrl/athlete');
    final response = await _sendGet(uri, accessToken);
    return _parseJsonObject(response.body);
  }

  /// Fetch athlete activities with support for timestamp bounds and pagination.
  Future<List<StravaActivityDto>> getActivities({
    required String accessToken,
    int? after,
    int? before,
    int page = 1,
    int perPage = 30,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'per_page': perPage.toString(),
    };
    if (after != null) queryParams['after'] = after.toString();
    if (before != null) queryParams['before'] = before.toString();

    final uri = Uri.parse('$baseUrl/athlete/activities').replace(queryParameters: queryParams);
    final response = await _sendGet(uri, accessToken);
    final listJson = _parseJsonList(response.body);

    return listJson.map((json) => StravaActivityDto.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<http.Response> _sendGet(Uri uri, String accessToken) async {
    try {
      final response = await _httpClient.get(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          HttpHeaders.acceptHeader: 'application/json',
        },
      );

      _handleStatusCode(response);
      return response;
    } on SocketException catch (e) {
      throw StravaNetworkException('Network connection failed: ${e.message}');
    } on http.ClientException catch (e) {
      throw StravaNetworkException('HTTP client error: ${e.message}');
    }
  }

  void _handleStatusCode(http.Response response) {
    final code = response.statusCode;
    if (code >= 200 && code < 300) return;

    if (code == 401) {
      throw StravaAuthException('Authorization failed or token expired', code);
    } else if (code == 429) {
      throw StravaRateLimitException('Strava API rate limit exceeded', code);
    } else if (code >= 500) {
      throw StravaNetworkException('Strava server error', code);
    } else {
      throw StravaException('Strava API request failed: ${response.reasonPhrase}', code);
    }
  }

  Map<String, dynamic> _parseJsonObject(String body) {
    try {
      final decoded = json.decode(body);
      if (decoded is Map<String, dynamic>) return decoded;
      throw StravaParseException('Expected JSON object, got ${decoded.runtimeType}');
    } catch (e) {
      if (e is StravaException) rethrow;
      throw StravaParseException('Failed to parse Strava API response JSON: $e');
    }
  }

  List<dynamic> _parseJsonList(String body) {
    try {
      final decoded = json.decode(body);
      if (decoded is List<dynamic>) return decoded;
      throw StravaParseException('Expected JSON array, got ${decoded.runtimeType}');
    } catch (e) {
      if (e is StravaException) rethrow;
      throw StravaParseException('Failed to parse Strava API activities response JSON: $e');
    }
  }
}
