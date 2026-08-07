import '../entities/strava_auth_token.dart';

abstract class IStravaTokenStorage {
  Future<void> saveToken(StravaAuthToken token);
  Future<StravaAuthToken?> getToken();
  Future<void> clearToken();
}
