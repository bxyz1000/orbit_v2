import 'package:flutter_test/flutter_test.dart';
import 'package:orbit_v2/features/integrations/strava/data/models/strava_activity_dto.dart';
import 'package:orbit_v2/features/integrations/strava/data/models/strava_activity_model.dart';

void main() {
  group('StravaActivityDto & Model Mapping Tests', () {
    test('maps raw JSON response to StravaActivityDto correctly', () {
      final json = {
        'id': 123456789,
        'name': 'Morning Run',
        'sport_type': 'Run',
        'start_date_local': '2026-08-07T07:30:00Z',
        'elapsed_time': 1800,
        'moving_time': 1750,
        'distance': 5000.5,
        'total_elevation_gain': 45.2,
        'average_speed': 2.85,
        'max_speed': 4.10,
        'calories': 350.0,
      };

      final dto = StravaActivityDto.fromJson(json);

      expect(dto.id, equals('123456789'));
      expect(dto.name, equals('Morning Run'));
      expect(dto.type, equals('Run'));
      expect(dto.startDate, equals(DateTime.parse('2026-08-07T07:30:00Z')));
      expect(dto.elapsedTime, equals(1800));
      expect(dto.movingTime, equals(1750));
      expect(dto.distance, equals(5000.5));
      expect(dto.totalElevationGain, equals(45.2));
      expect(dto.averageSpeed, equals(2.85));
      expect(dto.maxSpeed, equals(4.10));
      expect(dto.calories, equals(350.0));
    });

    test('converts DTO to domain entity and Isar model accurately', () {
      final json = {
        'id': '987654321',
        'name': 'Evening Ride',
        'type': 'Ride',
        'start_date': '2026-08-06T18:00:00Z',
        'elapsed_time': 3600,
        'moving_time': 3300,
        'distance': 25000.0,
        'total_elevation_gain': 200.0,
        'average_speed': 7.58,
        'max_speed': 11.2,
        'kilojoules': 500.0,
      };

      final dto = StravaActivityDto.fromJson(json);
      final entity = dto.toEntity(syncedAt: DateTime.parse('2026-08-07T10:00:00Z'));

      expect(entity.id, equals('987654321'));
      expect(entity.durationMinutes, equals(55));
      expect(entity.distanceKm, equals(25.0));

      final isarModel = StravaActivityModel.fromEntity(entity);
      expect(isarModel.stravaId, equals('987654321'));
      expect(isarModel.name, equals('Evening Ride'));
      expect(isarModel.movingTimeSeconds, equals(3300));
      expect(isarModel.calories, equals(500.0));

      final convertedBack = isarModel.toEntity();
      expect(convertedBack.id, equals(entity.id));
      expect(convertedBack.name, equals(entity.name));
      expect(convertedBack.distanceMeters, equals(entity.distanceMeters));
    });
  });
}
