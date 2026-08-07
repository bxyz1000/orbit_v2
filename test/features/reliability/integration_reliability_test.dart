import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:orbit_v2/features/focus/data/focus_repository.dart';
import 'package:orbit_v2/features/focus/domain/focus_session.dart';
import 'package:orbit_v2/features/goals/data/goal_repository.dart';
import 'package:orbit_v2/features/goals/domain/goal.dart';
import 'package:orbit_v2/features/habits/data/habit_repository.dart';
import 'package:orbit_v2/features/habits/domain/habit.dart';
import 'package:orbit_v2/features/habits/domain/habit_completion.dart';
import 'package:orbit_v2/features/health/data/health_repository.dart';
import 'package:orbit_v2/features/health/domain/entities/health_snapshot.dart';
import 'package:orbit_v2/features/health/domain/health_metrics.dart';
import 'package:orbit_v2/features/health/domain/repositories/i_health_service.dart';
import 'package:orbit_v2/features/integrations/data/models/integration_model.dart';
import 'package:orbit_v2/features/integrations/data/repositories/integration_repository_impl.dart';
import 'package:orbit_v2/features/integrations/domain/entities/integration.dart';
import 'package:orbit_v2/features/integrations/strava/data/datasources/strava_api_client.dart';
import 'package:orbit_v2/features/integrations/strava/data/models/strava_activity_model.dart';
import 'package:orbit_v2/features/integrations/strava/data/repositories/strava_repository_impl.dart';
import 'package:orbit_v2/features/integrations/strava/domain/entities/strava_activity.dart';
import 'package:orbit_v2/features/integrations/strava/domain/entities/strava_auth_state.dart';
import 'package:orbit_v2/features/integrations/strava/domain/entities/strava_auth_token.dart';
import 'package:orbit_v2/features/integrations/strava/domain/services/i_strava_auth_service.dart';
import 'package:orbit_v2/features/integrations/strava/domain/services/i_strava_token_storage.dart';
import 'package:orbit_v2/features/notes/domain/note.dart';
import 'package:orbit_v2/features/planner/data/planner_repository.dart';
import 'package:orbit_v2/features/planner/domain/planner_event.dart';
import 'package:orbit_v2/features/score/data/models/achievement_model.dart';
import 'package:orbit_v2/features/score/data/models/daily_score_model.dart';
import 'package:orbit_v2/features/score/data/models/monthly_score_model.dart';
import 'package:orbit_v2/features/score/data/models/personal_record_model.dart';
import 'package:orbit_v2/features/score/data/models/weekly_score_model.dart';
import 'package:orbit_v2/features/score/data/repositories/personal_record_repository.dart';
import 'package:orbit_v2/features/score/data/repositories/score_repository.dart';
import 'package:orbit_v2/features/score/data/score_service_impl.dart';
import 'package:orbit_v2/features/settings/domain/user_preferences.dart';
import 'package:orbit_v2/features/tasks/data/task_repository.dart';
import 'package:orbit_v2/features/tasks/domain/task.dart';

void main() {
  group('Real-World Integration Reliability Audit Tests', () {
    final schemas = [
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
    ];

    setUpAll(() async {
      await Isar.initializeIsarCore(download: true);
    });

    test('reloads all persisted state identically after simulated app restart', () async {
      const dbName = 'restart_test_db';

      // 1. First session - Write data to Isar and close
      Isar isar1 = await Isar.open(schemas, directory: '.', name: dbName);
      await isar1.writeTxn(() async => await isar1.clear());
      final taskRepo1 = TaskRepository(isar1);
      final healthRepo1 = HealthRepository(isar1, null);
      final integrationRepo1 = IntegrationRepositoryImpl(isar1);


      await taskRepo1.saveTask(Task.create(title: 'Survive App Restart', completed: true));
      await healthRepo1.saveSteps(StepLog.create(date: DateTime(2026, 8, 7), count: 8500, calories: 300));

      final stravaAct = StravaActivity(
        id: 'STRAVA_RESTART_1',
        name: 'Restart Run',
        type: 'Run',
        startDate: DateTime(2026, 8, 7, 8, 0),
        elapsedTimeSeconds: 1800,
        movingTimeSeconds: 1800,
        distanceMeters: 5000,
        elevationGainMeters: 20,
        averageSpeed: 2.7,
        maxSpeed: 3.5,
        syncedAt: DateTime.now(),
      );
      await isar1.writeTxn(() async {
        await isar1.stravaActivityModels.put(StravaActivityModel.fromEntity(stravaAct));
      });

      await integrationRepo1.updateIntegration(
        Integration(id: 'strava', name: 'Strava', status: IntegrationStatus.connected, lastSync: DateTime(2026, 8, 7, 8, 30)),
      );

      await isar1.close();

      // 2. Second session - Re-open Isar instance from disk (Simulate Cold Start)
      Isar isar2 = await Isar.open(schemas, directory: '.', name: dbName);
      final taskRepo2 = TaskRepository(isar2);
      final healthRepo2 = HealthRepository(isar2, null);
      final stravaRepo2 = StravaRepositoryImpl(
        isar: isar2,
        authService: _MockAuthService(),
        apiClient: StravaApiClient(),
        integrationRepo: IntegrationRepositoryImpl(isar2),
      );

      final tasks = await taskRepo2.getAllTasks();
      expect(tasks.length, equals(1));
      expect(tasks.first.title, equals('Survive App Restart'));

      final stepLog = await healthRepo2.getStepsForDate(DateTime(2026, 8, 7));
      expect(stepLog, isNotNull);
      expect(stepLog!.count, equals(8500));

      final stravaActivities = await stravaRepo2.getActivities();
      expect(stravaActivities.length, equals(1));
      expect(stravaActivities.first.id, equals('STRAVA_RESTART_1'));

      final stravaState = await stravaRepo2.getIntegrationState();
      expect(stravaState.status, equals(StravaConnectionStatus.connected));


      await isar2.writeTxn(() async => await isar2.clear());
      await isar2.close(deleteFromDisk: true);
    }, timeout: const Timeout(Duration(minutes: 2)));


    test('produces identical score regardless of sync order (Health first vs Strava first)', () async {
      const dbName1 = 'sync_order_1_db';
      const dbName2 = 'sync_order_2_db';

      final testDate = DateTime(2026, 8, 7);

      // Order A: Health Connect synced first, then Strava synced
      final isarA = await Isar.open(schemas, directory: '.', name: dbName1);
      final healthRepoA = HealthRepository(isarA, null);
      final integrationRepoA = IntegrationRepositoryImpl(isarA);
      final stravaRepoA = StravaRepositoryImpl(
        isar: isarA,
        authService: _MockAuthService(),
        apiClient: StravaApiClient(),
        integrationRepo: integrationRepoA,
      );
      final scoreServiceA = ScoreServiceImpl(
        ScoreRepository(isarA),
        PersonalRecordRepository(isarA),
        TaskRepository(isarA),
        HabitRepository(isarA),
        FocusRepository(isarA),
        PlannerRepository(isarA),
        healthRepoA,
        GoalRepository(isarA),
        stravaRepoA,
      );

      // Sync Health first
      await healthRepoA.saveWorkout(WorkoutLog.create(date: DateTime(2026, 8, 7, 7, 2), durationMinutes: 30, type: 'Workout'));
      // Sync Strava second (same workout overlap)
      await isarA.writeTxn(() async {
        await isarA.stravaActivityModels.put(StravaActivityModel.fromEntity(
          StravaActivity(
            id: 'S_ORDER_1',
            name: 'Run',
            type: 'Run',
            startDate: DateTime(2026, 8, 7, 7, 0),
            elapsedTimeSeconds: 1800,
            movingTimeSeconds: 1800,
            distanceMeters: 5000,
            elevationGainMeters: 10,
            averageSpeed: 2.7,
            maxSpeed: 3.5,
            syncedAt: testDate,
          ),
        ));
      });
      final scoreA = await scoreServiceA.calculateActiveScore(testDate);
      await isarA.close(deleteFromDisk: true);

      // Order B: Strava synced first, then Health Connect synced
      final isarB = await Isar.open(schemas, directory: '.', name: dbName2);
      final healthRepoB = HealthRepository(isarB, null);
      final integrationRepoB = IntegrationRepositoryImpl(isarB);
      final stravaRepoB = StravaRepositoryImpl(
        isar: isarB,
        authService: _MockAuthService(),
        apiClient: StravaApiClient(),
        integrationRepo: integrationRepoB,
      );
      final scoreServiceB = ScoreServiceImpl(
        ScoreRepository(isarB),
        PersonalRecordRepository(isarB),
        TaskRepository(isarB),
        HabitRepository(isarB),
        FocusRepository(isarB),
        PlannerRepository(isarB),
        healthRepoB,
        GoalRepository(isarB),
        stravaRepoB,
      );

      // Sync Strava first
      await isarB.writeTxn(() async {
        await isarB.stravaActivityModels.put(StravaActivityModel.fromEntity(
          StravaActivity(
            id: 'S_ORDER_1',
            name: 'Run',
            type: 'Run',
            startDate: DateTime(2026, 8, 7, 7, 0),
            elapsedTimeSeconds: 1800,
            movingTimeSeconds: 1800,
            distanceMeters: 5000,
            elevationGainMeters: 10,
            averageSpeed: 2.7,
            maxSpeed: 3.5,
            syncedAt: testDate,
          ),
        ));
      });
      // Sync Health second
      await healthRepoB.saveWorkout(WorkoutLog.create(date: DateTime(2026, 8, 7, 7, 2), durationMinutes: 30, type: 'Workout'));
      final scoreB = await scoreServiceB.calculateActiveScore(testDate);
      await isarB.close(deleteFromDisk: true);

      expect(scoreA.workoutScore, equals(scoreB.workoutScore));
      expect(scoreA.totalScore, equals(scoreB.totalScore));
    });

    test('preserves historical Strava activities when Strava integration is disconnected', () async {
      const dbName = 'disconnect_preservation_db';
      final isar = await Isar.open(schemas, directory: '.', name: dbName);
      final tokenStorage = _MockTokenStorage(StravaAuthToken(
        accessToken: 'acc_token',
        refreshToken: 'ref_token',
        expiresAt: DateTime.now().add(const Duration(hours: 2)),
        athleteId: '99',
      ));
      final authService = _MockAuthService(tokenStorage);
      final integrationRepo = IntegrationRepositoryImpl(isar);
      final stravaRepo = StravaRepositoryImpl(
        isar: isar,
        authService: authService,
        apiClient: StravaApiClient(),
        integrationRepo: integrationRepo,
      );

      // Seed activity
      await isar.writeTxn(() async {
        await isar.stravaActivityModels.put(StravaActivityModel.fromEntity(
          StravaActivity(
            id: 'HISTORICAL_1',
            name: 'Historical Ride',
            type: 'Ride',
            startDate: DateTime(2026, 8, 1),
            elapsedTimeSeconds: 3600,
            movingTimeSeconds: 3600,
            distanceMeters: 20000,
            elevationGainMeters: 100,
            averageSpeed: 5.5,
            maxSpeed: 8.0,
            syncedAt: DateTime.now(),
          ),
        ));
      });

      // User disconnects
      await stravaRepo.disconnect();

      final state = await stravaRepo.getIntegrationState();
      expect(state.status, equals(StravaConnectionStatus.notConnected));

      // Tokens cleared
      final token = await tokenStorage.getToken();
      expect(token, isNull);

      // Historical activities MUST remain preserved in Isar!
      final activities = await stravaRepo.getActivities();
      expect(activities.length, equals(1));
      expect(activities.first.id, equals('HISTORICAL_1'));

      await isar.close(deleteFromDisk: true);
    });

    test('does not overwrite existing Isar data with zeros when Health Connect retrieval fails', () async {
      const dbName = 'health_failure_test_db';
      final isar = await Isar.open(schemas, directory: '.', name: dbName);
      final healthService = _FailingHealthService();
      final healthRepo = HealthRepository(isar, healthService);

      // Seed valid existing health data
      await healthRepo.saveSteps(StepLog.create(date: DateTime(2026, 8, 7), count: 7500, calories: 250, distance: 5.2));

      // Attempt sync with failing Health Connect service
      expect(
        () async => await healthRepo.syncHealthData(DateTime(2026, 8, 7)),
        throwsA(isA<Exception>()),
      );

      // Verify Isar data was NOT overwritten with 0s!
      final stepLog = await healthRepo.getStepsForDate(DateTime(2026, 8, 7));
      expect(stepLog, isNotNull);
      expect(stepLog!.count, equals(7500));
      expect(stepLog.calories, equals(250.0));

      await isar.close(deleteFromDisk: true);
    });
  });
}

class _MockTokenStorage implements IStravaTokenStorage {
  StravaAuthToken? _token;
  _MockTokenStorage([this._token]);

  @override
  Future<void> clearToken() async => _token = null;

  @override
  Future<StravaAuthToken?> getToken() async => _token;

  @override
  Future<void> saveToken(StravaAuthToken token) async => _token = token;
}

class _MockAuthService implements IStravaAuthService {
  final IStravaTokenStorage? storage;
  _MockAuthService([this.storage]);

  @override
  Future<void> disconnect() async {
    await storage?.clearToken();
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FailingHealthService implements IHealthService {
  @override
  Future<bool> isAuthorized() async => true;

  @override
  Future<HealthSnapshot> getHealthSnapshot(DateTime date) async {
    throw Exception('Health Connect daemon unavailable');
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
