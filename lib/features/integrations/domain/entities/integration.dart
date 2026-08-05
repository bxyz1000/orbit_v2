enum IntegrationStatus { connected, syncing, error, notConnected }

class Integration {
  final String id;
  final String name;
  final IntegrationStatus status;
  final DateTime? lastSync;
  final Map<String, dynamic> metadata;
  final bool isSupported;

  Integration({
    required this.id,
    required this.name,
    required this.status,
    this.lastSync,
    this.metadata = const {},
    this.isSupported = true,
  });

  Integration copyWith({
    String? id,
    String? name,
    IntegrationStatus? status,
    DateTime? lastSync,
    Map<String, dynamic>? metadata,
    bool? isSupported,
  }) {
    return Integration(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      lastSync: lastSync ?? this.lastSync,
      metadata: metadata ?? this.metadata,
      isSupported: isSupported ?? this.isSupported,
    );
  }
}
