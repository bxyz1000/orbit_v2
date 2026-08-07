enum StravaConnectionStatus {
  notConnected,
  connecting,
  connected,
  syncing,
  error,
}

class StravaAuthState {
  final StravaConnectionStatus status;
  final String? athleteName;
  final int activityCount;
  final DateTime? lastSyncedAt;
  final String? errorMessage;

  const StravaAuthState({
    this.status = StravaConnectionStatus.notConnected,
    this.athleteName,
    this.activityCount = 0,
    this.lastSyncedAt,
    this.errorMessage,
  });

  StravaAuthState copyWith({
    StravaConnectionStatus? status,
    String? athleteName,
    int? activityCount,
    DateTime? lastSyncedAt,
    String? errorMessage,
  }) {
    return StravaAuthState(
      status: status ?? this.status,
      athleteName: athleteName ?? this.athleteName,
      activityCount: activityCount ?? this.activityCount,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
