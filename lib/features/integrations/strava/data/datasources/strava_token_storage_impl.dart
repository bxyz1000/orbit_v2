import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entities/strava_auth_token.dart';
import '../../domain/services/i_strava_token_storage.dart';

class StravaTokenStorageImpl implements IStravaTokenStorage {
  final FlutterSecureStorage _storage;

  static const _kAccessTokenKey = 'strava_access_token';
  static const _kRefreshTokenKey = 'strava_refresh_token';
  static const _kExpiresAtKey = 'strava_expires_at';
  static const _kAthleteIdKey = 'strava_athlete_id';
  static const _kAthleteNameKey = 'strava_athlete_name';

  StravaTokenStorageImpl([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<void> saveToken(StravaAuthToken token) async {
    await Future.wait([
      _storage.write(key: _kAccessTokenKey, value: token.accessToken),
      _storage.write(key: _kRefreshTokenKey, value: token.refreshToken),
      _storage.write(key: _kExpiresAtKey, value: token.expiresAt.millisecondsSinceEpoch.toString()),
      _storage.write(key: _kAthleteIdKey, value: token.athleteId),
      if (token.athleteName != null)
        _storage.write(key: _kAthleteNameKey, value: token.athleteName!),
    ]);
  }

  @override
  Future<StravaAuthToken?> getToken() async {
    final values = await Future.wait([
      _storage.read(key: _kAccessTokenKey),
      _storage.read(key: _kRefreshTokenKey),
      _storage.read(key: _kExpiresAtKey),
      _storage.read(key: _kAthleteIdKey),
      _storage.read(key: _kAthleteNameKey),
    ]);

    final accessToken = values[0];
    final refreshToken = values[1];
    final expiresAtStr = values[2];
    final athleteId = values[3];
    final athleteName = values[4];

    if (accessToken == null || refreshToken == null || expiresAtStr == null || athleteId == null) {
      return null;
    }

    final expiresAtMs = int.tryParse(expiresAtStr);
    if (expiresAtMs == null) return null;

    return StravaAuthToken(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: DateTime.fromMillisecondsSinceEpoch(expiresAtMs),
      athleteId: athleteId,
      athleteName: athleteName,
    );
  }

  @override
  Future<void> clearToken() async {
    await Future.wait([
      _storage.delete(key: _kAccessTokenKey),
      _storage.delete(key: _kRefreshTokenKey),
      _storage.delete(key: _kExpiresAtKey),
      _storage.delete(key: _kAthleteIdKey),
      _storage.delete(key: _kAthleteNameKey),
    ]);
  }
}
