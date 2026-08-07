import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:orbit_v2/features/analytics/data/services/analytics_service_impl.dart';
import 'package:orbit_v2/features/analytics/domain/analytics_period.dart';
import 'package:orbit_v2/features/focus/data/focus_repository.dart';
import 'package:orbit_v2/features/goals/data/goal_repository.dart';
import 'package:orbit_v2/features/habits/data/habit_repository.dart';
import 'package:orbit_v2/features/health/data/health_repository.dart';
import 'package:orbit_v2/features/health/domain/health_metrics.dart';
import 'package:orbit_v2/features/integrations/data/models/integration_model.dart';
import 'package:orbit_v2/features/integrations/data/repositories/integration_repository_impl.dart';
import 'package:orbit_v2/features/integrations/strava/data/datasources/strava_api_client.dart';
import 'package:orbit_v2/features/integrations/strava/data/models/strava_activity_model.dart';
import 'package:orbit_v2/features/integrations/strava/data/repositories/strava_repository_impl.dart';
import 'package:orbit_v2/features/integrations/strava/domain/entities/strava_activity.dart';
import 'package:orbit_v2/features/integrations/strava/domain/services/i_strava_auth_service.dart';
import 'package:orbit_v2/features/planner/data/planner_repository.dart';
import 'package:orbit_v2/features/score/data/repositories/personal_record_repository.dart';
import 'package:orbit_v2/features/score/data/repositories/score_repository.dart';
import 'package:orbit_v2/features/score/data/score_service_impl.dart';
import 'package:orbit_v2/features/tasks/data/task_repository.dart';

import 'package:orbit_v2/features/tasks/domain/task.dart';
import 'package:orbit_v2/features/notes/domain/note.dart';
import 'package:orbit_v2/features/planner/domain/planner_event.dart';
import 'package:orbit_v2/features/habits/domain/habit.dart';
import 'package:orbit_v2/features/focus/domain/focus_session.dart';
import 'package:orbit_v2/features/goals/domain/goal.dart';
import 'package:orbit_v2/features/score/data/models/daily_score_model.dart';
import 'package:orbit_v2/features/score/data/models/weekly_score_model.dart';
import 'package:orbit_v2/features/score/data/models/monthly_score_model.dart';
import 'package:orbit_v2/features/score/data/models/personal_record_model.dart';
import 'package:orbit_v2/features/score/data/models/achievement_model.dart';
import 'package:orbit_v2/features/settings/domain/user_preferences.dart';

import 'package:orbit_v2/features/habits/domain/habit_completion.dart';

void main() {
  group('Strava Analytics Data Pipeline Tests', () {
    late Isar isar;
    late TaskRepository taskRepo;
    late FocusRepository focusRepo;
    late HabitRepository habitRepo;
    late PlannerRepository plannerRepo;
    late HealthRepository healthRepo;
    late GoalRepository goalRepo;
    late ScoreRepository scoreRepo;
    late PersonalRecordRepository recordRepo;
    late IntegrationRepositoryImpl integrationRepo;
    late StravaRepositoryImpl stravaRepo;
    late ScoreServiceImpl scoreService;
    late AnalyticsServiceImpl analyticsService;

    setUpAll(() async {
      await Isar.initializeIsarCore(download: true);
      isar = await Isar.open(
        [
          TaskSchema,
          NoteSchema,
          PlannerEventSchema,
          HabitSchema,
          HabitCompletionSchema,
          FocusSessionSchema,
          StepLogSchema,
          WorkoutLogSchema,
          SleepLogSchema,
          GoalSchema,
          DailyScoreModelSchema,
          WeeklyScoreModelSchema,
          MonthlyScoreModelSchema,
          PersonalRecordModelSchema,
          AchievementModelSchema,
          UserPreferencesSchema,
          IntegrationModelSchema,
          StravaActivityModelSchema,
        ],
        directory: '.',
        name: 'strava_pipeline_db',
      );

      taskRepo = TaskRepository(isar);
      focusRepo = FocusRepository(isar);
      habitRepo = HabitRepository(isar);
      plannerRepo = PlannerRepository(isar);
      healthRepo = HealthRepository(isar, null);
      goalRepo = GoalRepository(isar);
      scoreRepo = ScoreRepository(isar);
      recordRepo = PersonalRecordRepository(isar);
      integrationRepo = IntegrationRepositoryImpl(isar);

      stravaRepo = StravaRepositoryImpl(
        isar: isar,
        authService: _MockAuthService(),
        apiClient: StravaApiClient(),
        integrationRepo: integrationRepo,
      );

      scoreService = ScoreServiceImpl(
        scoreRepo,
        recordRepo,
        taskRepo,
        habitRepo,
        focusRepo,
        plannerRepo,
        healthRepo,
        goalRepo,
        stravaRepo,
      );

      analyticsService = AnalyticsServiceImpl(
        scoreService: scoreService,
        scoreRepository: scoreRepo,
        taskRepository: taskRepo,
        focusRepository: focusRepo,
        healthRepository: healthRepo,
        habitRepository: habitRepo,
        goalRepository: goalRepo,
        personalRecordRepository: recordRepo,
        stravaRepository: stravaRepo,
      );
    });

    setUp(() async {
      await isar.writeTxn(() async => await isar.clear());
    });

    tearDownAll(() async {
      await isar.close(deleteFromDisk: true);
    });


    test('handles empty Strava history gracefully in analytics', () async {
      final now = DateTime(2026, 8, 7);
      final analytics = await analyticsService.getAnalytics(AnalyticsPeriod.last7Days, now);

      expect(analytics.strava, isNotNull);
      expect(analytics.strava!.totalActivities, equals(0));
      expect(analytics.strava!.totalWorkoutMinutes, equals(0));
      expect(analytics.strava!.totalDistanceKm, equals(0.0));
      expect(analytics.strava!.totalElevationGainMeters, equals(0.0));
      expect(analytics.strava!.totalCalories, equals(0.0));
    }, timeout: const Timeout(Duration(minutes: 2)));


    test('aggregates Strava activities for 7-day, 30-day, and 90-day periods', () async {
      final refDate = DateTime(2026, 8, 7);

      final act1 = StravaActivity(
        id: 'STRAVA_1',
        name: 'Morning Run',
        type: 'Run',
        startDate: DateTime(2026, 8, 7, 7, 0),
        elapsedTimeSeconds: 1800,
        movingTimeSeconds: 1800,
        distanceMeters: 5000,
        elevationGainMeters: 50,
        averageSpeed: 2.77,
        maxSpeed: 3.5,
        calories: 350,
        syncedAt: refDate,
      );

      final act2 = StravaActivity(
        id: 'STRAVA_2',
        name: 'Evening Cycling',
        type: 'Ride',
        startDate: DateTime(2026, 8, 7, 18, 0),
        elapsedTimeSeconds: 3600,
        movingTimeSeconds: 3600,
        distanceMeters: 25000,
        elevationGainMeters: 150,
        averageSpeed: 6.94,
        maxSpeed: 10.0,
        calories: 600,
        syncedAt: refDate,
      );

      final actOld30 = StravaActivity(
        id: 'STRAVA_3',
        name: 'Long Hike',
        type: 'Hike',
        startDate: DateTime(2026, 7, 20, 10, 0), // 18 days ago
        elapsedTimeSeconds: 7200,
        movingTimeSeconds: 7200,
        distanceMeters: 12000,
        elevationGainMeters: 400,
        averageSpeed: 1.66,
        maxSpeed: 2.5,
        calories: 900,
        syncedAt: refDate,
      );

      await isar.writeTxn(() async {
        await isar.stravaActivityModels.putAll([
          StravaActivityModel.fromEntity(act1),
          StravaActivityModel.fromEntity(act2),
          StravaActivityModel.fromEntity(actOld30),
        ]);
      });

      // 7-day analytics
      final analytics7 = await analyticsService.getAnalytics(AnalyticsPeriod.last7Days, refDate);
      expect(analytics7.strava!.totalActivities, equals(2));
      expect(analytics7.strava!.totalWorkoutMinutes, equals(90)); // 30m + 60m
      expect(analytics7.strava!.totalDistanceKm, equals(30.0)); // 5km + 25km
      expect(analytics7.strava!.totalElevationGainMeters, equals(200.0));
      expect(analytics7.strava!.totalCalories, equals(950.0));

      // 30-day analytics
      final analytics30 = await analyticsService.getAnalytics(AnalyticsPeriod.last30Days, refDate);
      expect(analytics30.strava!.totalActivities, equals(3));
      expect(analytics30.strava!.totalWorkoutMinutes, equals(210)); // 30m + 60m + 120m
      expect(analytics30.strava!.totalDistanceKm, equals(42.0)); // 30km + 12km
      expect(analytics30.strava!.totalElevationGainMeters, equals(600.0));
    }, timeout: const Timeout(Duration(minutes: 2)));

    test('de-duplicates workouts coexisting between Health Connect and Strava on the same day', () async {
      final refDate = DateTime(2026, 8, 7);

      // Health Connect workout
      await isar.writeTxn(() async {
        await isar.workoutLogs.put(WorkoutLog.create(
          date: DateTime(2026, 8, 7, 7, 2),
          durationMinutes: 30,
          type: 'Running',
        ));
      });

      // Strava workout (same workout!)
      final stravaAct = StravaActivity(
        id: 'STRAVA_DUP',
        name: 'Morning Run',
        type: 'Run',
        startDate: DateTime(2026, 8, 7, 7, 0),
        elapsedTimeSeconds: 1800,
        movingTimeSeconds: 1800, // 30 mins
        distanceMeters: 5000,
        elevationGainMeters: 40,
        averageSpeed: 2.77,
        maxSpeed: 3.5,
        calories: 350,
        syncedAt: refDate,
      );

      await isar.writeTxn(() async {
        await isar.stravaActivityModels.put(StravaActivityModel.fromEntity(stravaAct));
      });

      final activeScore = await scoreService.calculateActiveScore(refDate);

      // Should count 30 minutes total, NOT 60 minutes!
      expect(activeScore.workoutScore, equals(20)); // >= 30m gives 20 pts
    });

    test('emits stream updates when Strava activity model collection changes in Isar', () async {
      final expectation = expectLater(
        stravaRepo.watchActivities(),
        emits(isA<List<StravaActivity>>()),
      );

      await isar.writeTxn(() async {
        await isar.stravaActivityModels.put(
          StravaActivityModel.fromEntity(
            StravaActivity(
              id: 'STRAVA_STREAM_TEST',
              name: 'Stream Test Run',
              type: 'Run',
              startDate: DateTime.now(),
              elapsedTimeSeconds: 600,
              movingTimeSeconds: 600,
              distanceMeters: 2000,
              elevationGainMeters: 10,
              averageSpeed: 3.3,
              maxSpeed: 4.0,
              syncedAt: DateTime.now(),
            ),
          ),
        );
      });

      await expectation;
    });

  });
}

class _MockAuthService implements IStravaAuthService {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

