import '../entities/strava_auth_token.dart';

abstract class IStravaAuthService {
  Uri getAuthorizationUrl({String redirectUri = 'orbit://strava-auth'});
  Future<StravaAuthToken> authenticateWithCode(String code, {String redirectUri = 'orbit://strava-auth'});
  Future<StravaAuthToken> refreshToken(StravaAuthToken currentToken);
  Future<StravaAuthToken?> getValidToken();
  Future<void> disconnect();
}
