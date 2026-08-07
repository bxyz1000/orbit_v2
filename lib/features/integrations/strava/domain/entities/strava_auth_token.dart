class StravaAuthToken {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final String athleteId;
  final String? athleteName;

  const StravaAuthToken({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.athleteId,
    this.athleteName,
  });

  bool get isExpired {
    // Add a 5 minute safety buffer before actual expiration
    return DateTime.now().isAfter(expiresAt.subtract(const Duration(minutes: 5)));
  }

  StravaAuthToken copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    String? athleteId,
    String? athleteName,
  }) {
    return StravaAuthToken(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      athleteId: athleteId ?? this.athleteId,
      athleteName: athleteName ?? this.athleteName,
    );
  }
}
