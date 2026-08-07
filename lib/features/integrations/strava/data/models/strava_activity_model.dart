import 'package:isar_community/isar.dart';
import '../../domain/entities/strava_activity.dart';

part 'strava_activity_model.g.dart';

@collection
class StravaActivityModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String stravaId;

  late String name;
  late String type;
  late DateTime startDate;
  late int elapsedTimeSeconds;
  late int movingTimeSeconds;
  late double distanceMeters;
  late double elevationGainMeters;
  late double averageSpeed;
  late double maxSpeed;
  double? calories;
  late DateTime syncedAt;

  StravaActivityModel();

  factory StravaActivityModel.fromEntity(StravaActivity activity) {
    return StravaActivityModel()
      ..id = activity.id.hashCode
      ..stravaId = activity.id
      ..name = activity.name
      ..type = activity.type
      ..startDate = activity.startDate
      ..elapsedTimeSeconds = activity.elapsedTimeSeconds
      ..movingTimeSeconds = activity.movingTimeSeconds
      ..distanceMeters = activity.distanceMeters
      ..elevationGainMeters = activity.elevationGainMeters
      ..averageSpeed = activity.averageSpeed
      ..maxSpeed = activity.maxSpeed
      ..calories = activity.calories
      ..syncedAt = activity.syncedAt;
  }

  StravaActivity toEntity() {
    return StravaActivity(
      id: stravaId,
      name: name,
      type: type,
      startDate: startDate,
      elapsedTimeSeconds: elapsedTimeSeconds,
      movingTimeSeconds: movingTimeSeconds,
      distanceMeters: distanceMeters,
      elevationGainMeters: elevationGainMeters,
      averageSpeed: averageSpeed,
      maxSpeed: maxSpeed,
      calories: calories,
      syncedAt: syncedAt,
    );
  }
}
