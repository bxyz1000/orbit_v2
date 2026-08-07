import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orbit_v2/features/analytics/domain/analytics_period.dart';
import 'package:orbit_v2/features/analytics/domain/period_comparison.dart';
import 'package:orbit_v2/features/analytics/data/services/analytics_service_impl.dart';
import 'package:orbit_v2/features/score/domain/entities/daily_score.dart';
import 'package:orbit_v2/features/score/domain/services/score_service.dart';
import 'package:orbit_v2/features/score/data/repositories/score_repository.dart';
import 'package:orbit_v2/features/score/data/repositories/personal_record_repository.dart';
import 'package:orbit_v2/features/score/domain/entities/personal_record.dart';
import 'package:orbit_v2/features/tasks/data/task_repository.dart';
import 'package:orbit_v2/features/tasks/domain/task.dart';
import 'package:orbit_v2/features/focus/data/focus_repository.dart';
import 'package:orbit_v2/features/focus/domain/focus_session.dart';
import 'package:orbit_v2/features/health/data/health_repository.dart';
import 'package:orbit_v2/features/health/domain/health_metrics.dart';
import 'package:orbit_v2/features/habits/data/habit_repository.dart';
import 'package:orbit_v2/features/habits/domain/habit.dart';
import 'package:orbit_v2/features/habits/domain/habit_completion.dart';
import 'package:orbit_v2/features/goals/data/goal_repository.dart';
import 'package:orbit_v2/features/goals/domain/goal.dart';

class FakeScoreService implements ScoreService {
  final Map<String, int> scores;
  FakeScoreService(this.scores);

  @override
  String get scoreVersion => '1.1';

  @override
  Future<DailyScore> calculateActiveScore(DateTime date) async {
    final key = '${date.year}-${date.month}-${date.day}';
    final val = scores[key] ?? 0;
    return DailyScore.create(date: date, totalScore: val);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeScoreRepository implements ScoreRepository {
  @override
  Future<DailyScore?> getDailyScore(DateTime date) async => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeTaskRepository implements TaskRepository {
  final List<Task> tasks;
  FakeTaskRepository(this.tasks);

  @override
  Future<List<Task>> getAllTasks() async => tasks;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeFocusRepository implements FocusRepository {
  final List<FocusSession> sessions;
  FakeFocusRepository(this.sessions);

  @override
  Future<List<FocusSession>> getAllSessions() async => sessions;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeHealthRepository implements HealthRepository {
  final Map<String, StepLog> stepsMap;
  final Map<String, SleepLog> sleepMap;
  final Map<String, List<WorkoutLog>> workoutsMap;

  FakeHealthRepository({
    this.stepsMap = const {},
    this.sleepMap = const {},
    this.workoutsMap = const {},
  });

  @override
  Future<StepLog?> getStepsForDate(DateTime date) async {
    final key = '${date.year}-${date.month}-${date.day}';
    return stepsMap[key];
  }

  @override
  Future<SleepLog?> getSleepForDate(DateTime date) async {
    final key = '${date.year}-${date.month}-${date.day}';
    return sleepMap[key];
  }

  @override
  Future<List<WorkoutLog>> getWorkoutsForDate(DateTime date) async {
    final key = '${date.year}-${date.month}-${date.day}';
    return workoutsMap[key] ?? [];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeHabitRepository implements HabitRepository {
  final List<Habit> habits;
  final Map<String, List<HabitCompletion>> completionsMap;

  FakeHabitRepository({this.habits = const [], this.completionsMap = const {}});

  @override
  Future<List<Habit>> getAllHabits() async => habits;

  @override
  Future<List<HabitCompletion>> getCompletionsForDate(DateTime date) async {
    final key = '${date.year}-${date.month}-${date.day}';
    return completionsMap[key] ?? [];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeGoalRepository implements GoalRepository {
  final Map<String, List<Goal>> goalsMap;
  FakeGoalRepository(this.goalsMap);

  @override
  Future<List<Goal>> getGoalsForDate(DateTime date) async {
    final key = '${date.year}-${date.month}-${date.day}';
    return goalsMap[key] ?? [];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakePersonalRecordRepository implements PersonalRecordRepository {
  final List<PersonalRecord> records;
  FakePersonalRecordRepository(this.records);

  @override
  Future<List<PersonalRecord>> getAllRecords() async => records;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('AnalyticsPeriod Extensions', () {
    test('period days count', () {
      expect(AnalyticsPeriod.today.days, equals(1));
      expect(AnalyticsPeriod.last7Days.days, equals(7));
      expect(AnalyticsPeriod.last30Days.days, equals(30));
      expect(AnalyticsPeriod.last90Days.days, equals(90));
    });

    test('getStartDate returns correct date', () {
      final ref = DateTime(2026, 8, 7);
      expect(AnalyticsPeriod.today.getStartDate(ref), equals(DateTime(2026, 8, 7)));
      expect(AnalyticsPeriod.last7Days.getStartDate(ref), equals(DateTime(2026, 8, 1)));
    });
  });

  group('PeriodComparison Calculation', () {
    test('calculates increase correctly', () {
      final comp = PeriodComparison.calculate(150, 100);
      expect(comp.difference, equals(50));
      expect(comp.percentageChange, equals(50.0));
      expect(comp.trend, equals(TrendDirection.up));
    });

    test('calculates decrease correctly', () {
      final comp = PeriodComparison.calculate(50, 100);
      expect(comp.difference, equals(-50));
      expect(comp.percentageChange, equals(-50.0));
      expect(comp.trend, equals(TrendDirection.down));
    });

    test('handles division by zero safely', () {
      final comp = PeriodComparison.calculate(100, 0);
      expect(comp.difference, equals(100));
      expect(comp.percentageChange, equals(100.0));
      expect(comp.trend, equals(TrendDirection.up));

      final compZeroBoth = PeriodComparison.calculate(0, 0);
      expect(compZeroBoth.difference, equals(0));
      expect(compZeroBoth.percentageChange, equals(0.0));
      expect(compZeroBoth.trend, equals(TrendDirection.neutral));
    });
  });

  group('AnalyticsServiceImpl Integration', () {
    final refDate = DateTime(2026, 8, 7);
    final keyToday = '2026-8-7';

    late AnalyticsServiceImpl service;

    setUp(() {
      final stepLogToday = StepLog.create(
        date: refDate,
        count: 8500,
        calories: 350.0,
        distance: 6.2,
        activeMinutes: 45,
      );

      service = AnalyticsServiceImpl(
        scoreService: FakeScoreService({keyToday: 85}),
        scoreRepository: FakeScoreRepository(),
        taskRepository: FakeTaskRepository([
          Task.create(title: 'Task 1', completed: true, completedAt: refDate),
          Task.create(title: 'Task 2', completed: false),
        ]),
        focusRepository: FakeFocusRepository([
          FocusSession.create(duration: 45, completed: true, startedAt: refDate),
        ]),
        healthRepository: FakeHealthRepository(
          stepsMap: {keyToday: stepLogToday},
          sleepMap: {
            keyToday: SleepLog.create(date: refDate, durationMinutes: 480),
          },
          workoutsMap: {
            keyToday: [WorkoutLog.create(date: refDate, durationMinutes: 30, type: 'Running')],
          },
        ),
        habitRepository: FakeHabitRepository(
          habits: [Habit.create(title: 'Water', icon: Icons.water_drop, color: Colors.blue)],
          completionsMap: {
            keyToday: [HabitCompletion.create(habitId: 1, date: refDate)],
          },
        ),
        goalRepository: FakeGoalRepository({
          keyToday: [Goal.create(title: 'Read 20 pages', date: refDate, completed: true)],
        }),
        personalRecordRepository: FakePersonalRecordRepository([
          PersonalRecord.create(recordType: 'highest_daily_score', value: 95.0, achievedAt: refDate),
        ]),
      );
    });

    test('aggregates today analytics correctly', () async {
      final analytics = await service.getAnalytics(AnalyticsPeriod.today, refDate);

      expect(analytics.period, equals(AnalyticsPeriod.today));
      expect(analytics.score.averageScore, equals(85.0));
      expect(analytics.tasks.totalCompleted, equals(1));
      expect(analytics.focus.totalMinutes, equals(45));
      expect(analytics.health.averageSteps, equals(8500.0));
      expect(analytics.health.averageCalories, equals(350.0));
      expect(analytics.health.averageSleepMinutes, equals(480.0));
      expect(analytics.health.totalWorkouts, equals(1));
      expect(analytics.goals.totalCompleted, equals(1));
      expect(analytics.personalRecords['highest_daily_score'], equals(95.0));
    });

    test('handles empty dataset gracefully without errors', () async {
      final emptyService = AnalyticsServiceImpl(
        scoreService: FakeScoreService({}),
        scoreRepository: FakeScoreRepository(),
        taskRepository: FakeTaskRepository([]),
        focusRepository: FakeFocusRepository([]),
        healthRepository: FakeHealthRepository(),
        habitRepository: FakeHabitRepository(),
        goalRepository: FakeGoalRepository({}),
        personalRecordRepository: FakePersonalRecordRepository([]),
      );

      final analytics = await emptyService.getAnalytics(AnalyticsPeriod.last7Days, refDate);

      expect(analytics.score.averageScore, equals(0.0));
      expect(analytics.tasks.totalCompleted, equals(0));
      expect(analytics.focus.totalMinutes, equals(0));
      expect(analytics.health.averageSteps, equals(0.0));
      expect(analytics.goals.totalCompleted, equals(0));
      expect(analytics.personalRecords.isEmpty, isTrue);
    });
  });
}
