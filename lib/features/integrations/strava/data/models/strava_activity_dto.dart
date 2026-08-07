import '../../domain/entities/strava_activity.dart';

class StravaActivityDto {
  final String id;
  final String name;
  final String type;
  final DateTime startDate;
  final int elapsedTime;
  final int movingTime;
  final double distance;
  final double totalElevationGain;
  final double averageSpeed;
  final double maxSpeed;
  final double? calories;

  const StravaActivityDto({
    required this.id,
    required this.name,
    required this.type,
    required this.startDate,
    required this.elapsedTime,
    required this.movingTime,
    required this.distance,
    required this.totalElevationGain,
    required this.averageSpeed,
    required this.maxSpeed,
    this.calories,
  });

  factory StravaActivityDto.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final idString = rawId != null ? rawId.toString() : '';

    final startDateRaw = json['start_date_local'] ?? json['start_date'];
    final parsedDate = startDateRaw != null ? DateTime.parse(startDateRaw.toString()) : DateTime.now();

    return StravaActivityDto(
      id: idString,
      name: (json['name'] as String?) ?? 'Workout',
      type: (json['sport_type'] as String?) ?? (json['type'] as String?) ?? 'Workout',
      startDate: parsedDate,
      elapsedTime: (json['elapsed_time'] as num?)?.toInt() ?? 0,
      movingTime: (json['moving_time'] as num?)?.toInt() ?? 0,
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      totalElevationGain: (json['total_elevation_gain'] as num?)?.toDouble() ?? 0.0,
      averageSpeed: (json['average_speed'] as num?)?.toDouble() ?? 0.0,
      maxSpeed: (json['max_speed'] as num?)?.toDouble() ?? 0.0,
      calories: (json['calories'] as num?)?.toDouble() ?? (json['kilojoules'] as num?)?.toDouble(),
    );
  }

  StravaActivity toEntity({DateTime? syncedAt}) {
    return StravaActivity(
      id: id,
      name: name,
      type: type,
      startDate: startDate,
      elapsedTimeSeconds: elapsedTime,
      movingTimeSeconds: movingTime,
      distanceMeters: distance,
      elevationGainMeters: totalElevationGain,
      averageSpeed: averageSpeed,
      maxSpeed: maxSpeed,
      calories: calories,
      syncedAt: syncedAt ?? DateTime.now(),
    );
  }
}
