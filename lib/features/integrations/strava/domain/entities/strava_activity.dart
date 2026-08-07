class StravaActivity {
  final String id;
  final String name;
  final String type;
  final DateTime startDate;
  final int elapsedTimeSeconds;
  final int movingTimeSeconds;
  final double distanceMeters;
  final double elevationGainMeters;
  final double averageSpeed;
  final double maxSpeed;
  final double? calories;
  final DateTime syncedAt;

  const StravaActivity({
    required this.id,
    required this.name,
    required this.type,
    required this.startDate,
    required this.elapsedTimeSeconds,
    required this.movingTimeSeconds,
    required this.distanceMeters,
    required this.elevationGainMeters,
    required this.averageSpeed,
    required this.maxSpeed,
    this.calories,
    required this.syncedAt,
  });

  int get durationMinutes => (movingTimeSeconds / 60).round();
  double get distanceKm => distanceMeters / 1000.0;
}
