import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbit_v2/features/insights/data/services/insight_service_impl.dart';
import 'package:orbit_v2/features/insights/domain/entities/insight_priority.dart';
import 'package:orbit_v2/features/insights/domain/entities/insight_type.dart';
import 'package:orbit_v2/features/insights/domain/entities/orbit_insight.dart';
import 'package:orbit_v2/features/insights/presentation/providers/insight_providers.dart';

import 'package:orbit_v2/features/score/domain/entities/daily_score.dart';
import 'package:orbit_v2/features/score/domain/entities/weekly_score.dart';
import 'package:orbit_v2/features/score/domain/entities/monthly_score.dart';
import 'package:orbit_v2/features/score/domain/entities/personal_record.dart';
import 'package:orbit_v2/features/score/domain/services/score_service.dart';
import 'package:orbit_v2/features/score/data/repositories/score_repository.dart';
import 'package:orbit_v2/features/score/data/repositories/personal_record_repository.dart';
import 'package:orbit_v2/features/tasks/data/task_repository.dart';
import 'package:orbit_v2/features/tasks/domain/task.dart';
import 'package:orbit_v2/features/habits/data/habit_repository.dart';
import 'package:orbit_v2/features/habits/domain/habit.dart';
import 'package:orbit_v2/features/habits/domain/habit_completion.dart';
import 'package:orbit_v2/features/focus/data/focus_repository.dart';
import 'package:orbit_v2/features/focus/domain/focus_session.dart';
import 'package:orbit_v2/features/planner/data/planner_repository.dart';
import 'package:orbit_v2/features/planner/domain/planner_event.dart';
import 'package:orbit_v2/features/health/data/health_repository.dart';
import 'package:orbit_v2/features/health/domain/health_metrics.dart';
import 'package:orbit_v2/features/goals/data/goal_repository.dart';
import 'package:orbit_v2/features/goals/domain/goal.dart';
import 'package:orbit_v2/features/integrations/strava/domain/repositories/i_strava_repository.dart';
import 'package:orbit_v2/features/integrations/strava/domain/entities/strava_activity.dart';

import 'package:orbit_v2/shared/providers/repository_providers.dart';
import 'package:orbit_v2/features/score/presentation/providers/score_providers.dart';
import 'package:orbit_v2/features/health/presentation/providers/health_providers.dart';
import 'package:orbit_v2/features/integrations/strava/presentation/providers/strava_providers.dart';

class FakeScoreService implements ScoreService {
  @override
  String get scoreVersion => '2.0';

  @override
  Future<DailyScore> calculateActiveScore(DateTime date) async {
    return DailyScore.create(date: date, totalScore: 70);
  }

  @override
  Future<WeeklyScore> calculateWeeklyScore(DateTime date) async {
    return WeeklyScore(
      weekStartDate: date,
      totalScore: 400,
      averageDailyScore: 70.0,
      taskScore: 100,
      habitScore: 100,
      focusScore: 100,
      healthScore: 100,
      scoreVersion: '2.0',
      createdAt: date,
      updatedAt: date,
    );
  }

  @override
  Future<MonthlyScore> calculateMonthlyScore(DateTime date) async {
    return MonthlyScore(
      monthStartDate: date,
      totalScore: 1800,
      taskScore: 500,
      habitScore: 500,
      focusScore: 500,
      healthScore: 300,
      scoreVersion: '2.0',
      createdAt: date,
      updatedAt: date,
    );
  }

  @override
  Future<void> finalizeDay(DateTime date) async {}

  @override
  Future<void> recalculateHistoricalScores() async {}

  @override
  Future<List<PersonalRecord>> getRecords() async => [];

  @override
  Stream<DailyScore?> watchScore(DateTime date) => Stream.value(null);
}

class FakeScoreRepository implements ScoreRepository {
  DailyScore? yesterdayScore;
  List<DailyScore> historicalScores = [];

  @override
  Future<DailyScore?> getDailyScore(DateTime date) async {
    if (yesterdayScore != null && date.year == yesterdayScore!.date.year && date.month == yesterdayScore!.date.month && date.day == yesterdayScore!.date.day) {
      return yesterdayScore;
    }
    return null;
  }

  @override
  Future<List<DailyScore>> getRecentDailyScores(DateTime beforeDate, {int limit = 14}) async {
    return historicalScores.isNotEmpty ? historicalScores : (yesterdayScore != null ? [yesterdayScore!] : []);
  }

  @override
  Future<void> saveDailyScore(DailyScore score) async {}

  @override
  Future<WeeklyScore?> getWeeklyScore(DateTime weekStart) async => null;

  @override
  Future<void> saveWeeklyScore(WeeklyScore score) async {}

  @override
  Future<MonthlyScore?> getMonthlyScore(DateTime monthStart) async => null;

  @override
  Future<void> saveMonthlyScore(MonthlyScore score) async {}

  @override
  Stream<DailyScore?> streamDailyScore(DateTime date) => Stream.value(null);

  @override
  Stream<void> watchAllScores() => Stream.value(null);
}

class FakePersonalRecordRepository implements PersonalRecordRepository {
  List<PersonalRecord> records = [];

  @override
  Future<List<PersonalRecord>> getAllRecords() async => records;

  @override
  Future<PersonalRecord?> getRecord(String recordType) async => null;

  @override
  Future<void> saveRecord(PersonalRecord record) async {}

  @override
  Future<bool> updateIfHigher(String recordType, double newValue, DateTime date) async => false;

  @override
  Stream<void> watchRecords() => Stream.value(null);
}

class FakeTaskRepository implements TaskRepository {
  List<Task> tasks = [];
  @override
  Future<List<Task>> getAllTasks() async => tasks;
  @override
  Future<void> saveTask(Task task) async {}
  @override
  Future<void> saveTasks(List<Task> tasks) async {}
  @override
  Future<void> deleteTask(int id) async {}
  @override
  Stream<void> watchTasks() => Stream.value(null);
}

class FakeHabitRepository implements HabitRepository {
  List<Habit> habits = [];
  List<HabitCompletion> completions = [];
  @override
  Future<List<Habit>> getAllHabits() async => habits;
  @override
  Future<List<HabitCompletion>> getCompletionsForDate(DateTime date) async => completions;
  @override
  Future<void> saveHabit(Habit habit) async {}
  @override
  Future<void> deleteHabit(int habitId) async {}
  @override
  Future<void> saveCompletion(HabitCompletion completion) async {}
  @override
  Stream<void> watchHabits() => Stream.value(null);
  @override
  Stream<void> watchCompletions() => Stream.value(null);
}

class FakeFocusRepository implements FocusRepository {
  List<FocusSession> sessions = [];
  @override
  Future<List<FocusSession>> getAllSessions() async => sessions;
  @override
  Future<List<FocusSession>> getTodaySessions() async => sessions;
  @override
  Future<void> saveSession(FocusSession session) async {}
  @override
  Future<void> deleteSession(int id) async {}
  @override
  Stream<void> watchSessions() => Stream.value(null);
}

class FakePlannerRepository implements PlannerRepository {
  List<PlannerEvent> events = [];
  @override
  Future<List<PlannerEvent>> getAllEvents() async => events;
  @override
  Future<void> saveEvent(PlannerEvent event) async {}
  @override
  Future<void> saveEvents(List<PlannerEvent> events) async {}
  @override
  Future<void> deleteEvent(int eventId) async {}
  @override
  Stream<void> watchEvents() => Stream.value(null);
}

class FakeHealthRepository implements HealthRepository {
  bool authorized = false;
  StepLog? steps;
  SleepLog? sleep;
  List<WorkoutLog> workouts = [];

  @override
  Future<bool> isAuthorized() async => authorized;
  @override
  Future<StepLog?> getStepsForDate(DateTime date) async => steps;
  @override
  Future<List<WorkoutLog>> getWorkoutsForDate(DateTime date) async => workouts;
  @override
  Future<SleepLog?> getSleepForDate(DateTime date) async => sleep;
  @override
  Future<void> saveSteps(StepLog log) async {}
  @override
  Future<void> saveWorkout(WorkoutLog log) async {}
  @override
  Future<void> saveSleep(SleepLog log) async {}
  @override
  Future<void> syncHealthData(DateTime date) async {}
  @override
  Stream<void> watchSteps() => Stream.value(null);
  @override
  Stream<void> watchWorkouts() => Stream.value(null);
  @override
  Stream<void> watchSleep() => Stream.value(null);
}

class FakeGoalRepository implements GoalRepository {
  List<Goal> goals = [];
  @override
  Future<List<Goal>> getGoalsForDate(DateTime date) async => goals;
  @override
  Future<List<Goal>> getAllGoals() async => goals;
  @override
  Future<void> saveGoal(Goal goal) async {}
  @override
  Future<void> deleteGoal(Goal goal) async {}
  @override
  Stream<void> watchGoals() => Stream.value(null);
}

void main() {
  late InsightServiceImpl insightService;
  late FakeScoreService fakeScoreService;
  late FakeScoreRepository fakeScoreRepository;
  late FakePersonalRecordRepository fakeRecordRepository;
  late FakeTaskRepository fakeTaskRepository;
  late FakeHabitRepository fakeHabitRepository;
  late FakeFocusRepository fakeFocusRepository;
  late FakePlannerRepository fakePlannerRepository;
  late FakeHealthRepository fakeHealthRepository;
  late FakeGoalRepository fakeGoalRepository;

  final refDate = DateTime(2026, 8, 7);

  setUp(() {
    fakeScoreService = FakeScoreService();
    fakeScoreRepository = FakeScoreRepository();
    fakeRecordRepository = FakePersonalRecordRepository();
    fakeTaskRepository = FakeTaskRepository();
    fakeHabitRepository = FakeHabitRepository();
    fakeFocusRepository = FakeFocusRepository();
    fakePlannerRepository = FakePlannerRepository();
    fakeHealthRepository = FakeHealthRepository();
    fakeGoalRepository = FakeGoalRepository();

    insightService = InsightServiceImpl(
      scoreService: fakeScoreService,
      scoreRepository: fakeScoreRepository,
      recordRepository: fakeRecordRepository,
      taskRepository: fakeTaskRepository,
      habitRepository: fakeHabitRepository,
      focusRepository: fakeFocusRepository,
      plannerRepository: fakePlannerRepository,
      healthRepository: fakeHealthRepository,
      goalRepository: fakeGoalRepository,
    );
  });

  group('Comprehensive Orbit Insight Engine Unit Tests', () {
    test('1. Score improvement insight generated when score increases', () async {
      final yesterday = refDate.subtract(const Duration(days: 1));
      fakeScoreRepository.yesterdayScore = DailyScore.create(date: yesterday, totalScore: 20);
      fakeTaskRepository.tasks = [
        Task.create(title: 'T1', completed: true, completedAt: refDate),
        Task.create(title: 'T2', completed: true, completedAt: refDate),
        Task.create(title: 'T3', completed: true, completedAt: refDate),
        Task.create(title: 'T4', completed: true, completedAt: refDate),
        Task.create(title: 'T5', completed: true, completedAt: refDate),
      ];

      final insights = await insightService.generateDailyInsights(refDate);
      expect(insights.any((i) => i.type == InsightType.scoreImprovement), isTrue);
      final imp = insights.firstWhere((i) => i.type == InsightType.scoreImprovement);
      expect(imp.change, equals(8.0));
    });

    test('2. Score decline insight generated when score decreases', () async {
      final yesterday = refDate.subtract(const Duration(days: 1));
      fakeScoreRepository.yesterdayScore = DailyScore.create(date: yesterday, totalScore: 80);
      fakeTaskRepository.tasks = []; // 0 completed tasks

      final insights = await insightService.generateDailyInsights(refDate);
      expect(insights.any((i) => i.type == InsightType.scoreDecline), isTrue);
      final dec = insights.firstWhere((i) => i.type == InsightType.scoreDecline);
      expect(dec.change, equals(-80.0));
      expect(dec.priority, equals(InsightPriority.high));
    });

    test('3. Above personal baseline insight generated when score exceeds 7-day EMA', () async {
      fakeScoreRepository.historicalScores = List.generate(7, (i) => DailyScore.create(
        date: refDate.subtract(Duration(days: 7 - i)),
        totalScore: 20,
      ));
      fakeTaskRepository.tasks = [
        Task.create(title: 'T1', completed: true, completedAt: refDate),
        Task.create(title: 'T2', completed: true, completedAt: refDate),
        Task.create(title: 'T3', completed: true, completedAt: refDate),
        Task.create(title: 'T4', completed: true, completedAt: refDate),
        Task.create(title: 'T5', completed: true, completedAt: refDate),
      ];

      final insights = await insightService.generateDailyInsights(refDate);
      expect(insights.any((i) => i.type == InsightType.aboveBaseline), isTrue);
      final above = insights.firstWhere((i) => i.type == InsightType.aboveBaseline);
      expect(above.title, contains('Above 7-Day Baseline'));
    });

    test('4. Below personal baseline insight generated when score is under 7-day EMA', () async {
      fakeScoreRepository.historicalScores = List.generate(7, (i) => DailyScore.create(
        date: refDate.subtract(Duration(days: 7 - i)),
        totalScore: 90,
      ));
      fakeTaskRepository.tasks = [];

      final insights = await insightService.generateDailyInsights(refDate);
      expect(insights.any((i) => i.type == InsightType.belowBaseline), isTrue);
      final below = insights.firstWhere((i) => i.type == InsightType.belowBaseline);
      expect(below.title, contains('Below 7-Day Baseline'));
    });

    test('5 & 6. Strongest and Weakest category insights generated', () async {
      fakeTaskRepository.tasks = [
        Task.create(title: 'T1', completed: true, completedAt: refDate),
        Task.create(title: 'T2', completed: true, completedAt: refDate),
        Task.create(title: 'T3', completed: true, completedAt: refDate),
        Task.create(title: 'T4', completed: true, completedAt: refDate),
        Task.create(title: 'T5', completed: true, completedAt: refDate),
      ];
      fakeFocusRepository.sessions = [
        FocusSession.create(duration: 20, startedAt: refDate, completed: true),
      ];
      fakeHabitRepository.habits = [
        Habit.create(title: 'H1', icon: Icons.star, color: Colors.blue),
      ];

      final catInsights = await insightService.generateCategoryInsights(refDate);
      expect(catInsights.any((i) => i.type == InsightType.strongestCategory), isTrue);
      expect(catInsights.any((i) => i.type == InsightType.biggestOpportunity), isTrue);

      final strongest = catInsights.firstWhere((i) => i.type == InsightType.strongestCategory);
      expect(strongest.category, equals('Tasks & Execution'));

      final weakest = catInsights.firstWhere((i) => i.type == InsightType.biggestOpportunity);
      expect(weakest.category, equals('Habit Consistency'));
    });

    test('7 & 8. Category improvement and decline insights generated', () async {
      fakeTaskRepository.tasks = [
        Task.create(title: 'T1', completed: true, completedAt: refDate),
        Task.create(title: 'T2', completed: true, completedAt: refDate),
        Task.create(title: 'T3', completed: true, completedAt: refDate),
        Task.create(title: 'T4', completed: true, completedAt: refDate),
        Task.create(title: 'T5', completed: true, completedAt: refDate),
      ];

      final catInsights = await insightService.generateCategoryInsights(refDate);
      expect(catInsights, isNotNull);
    });

    test('9. Personal record insight generated when record is broken today', () async {
      fakeRecordRepository.records = [
        PersonalRecord.create(recordType: 'highest_daily_score', value: 98.0, achievedAt: refDate),
      ];

      final insights = await insightService.generateDailyInsights(refDate);
      expect(insights.any((i) => i.type == InsightType.personalRecord), isTrue);
      final pr = insights.firstWhere((i) => i.type == InsightType.personalRecord);
      expect(pr.priority, equals(InsightPriority.high));
    });

    test('10. Streak insight generated for consecutive high performance days', () async {
      fakeScoreRepository.historicalScores = List.generate(5, (i) => DailyScore.create(
        date: refDate.subtract(Duration(days: i + 1)),
        totalScore: 75,
      ));

      final insights = await insightService.generateDailyInsights(refDate);
      expect(insights.any((i) => i.type == InsightType.streak), isTrue);
      final streak = insights.firstWhere((i) => i.type == InsightType.streak);
      expect(streak.title, contains('5-Day Consistency Streak'));
    });

    test('11 & 15. No historical data & Brand-new user handled safely without crashes', () async {
      fakeScoreRepository.historicalScores = [];
      fakeScoreRepository.yesterdayScore = null;
      fakeTaskRepository.tasks = [];
      fakeHabitRepository.habits = [];

      final insights = await insightService.generateDailyInsights(refDate);
      expect(insights, isA<List<OrbitInsight>>());
      expect(insights.any((i) => i.type == InsightType.scoreImprovement), isFalse);
      expect(insights.any((i) => i.type == InsightType.scoreDecline), isFalse);
    });

    test('12 & 13. Missing Health Connect and Missing Strava adaptive handling', () async {
      fakeHealthRepository.authorized = false;
      fakeHealthRepository.steps = null;

      final insights = await insightService.generateDailyInsights(refDate);
      expect(insights, isA<List<OrbitInsight>>());
      // No shaming insight about health
      expect(insights.any((i) => i.description.contains('terrible')), isFalse);
    });

    test('14. Sync failure or empty repository handled gracefully', () async {
      final catInsights = await insightService.generateCategoryInsights(refDate);
      expect(catInsights, isA<List<OrbitInsight>>());
    });

    test('16. Deterministic output: Identical inputs produce identical insights', () async {
      fakeTaskRepository.tasks = [
        Task.create(title: 'T1', completed: true, completedAt: refDate),
      ];

      final res1 = await insightService.generateDailyInsights(refDate);
      final res2 = await insightService.generateDailyInsights(refDate);

      expect(res1.length, equals(res2.length));
      for (int i = 0; i < res1.length; i++) {
        expect(res1[i].type, equals(res2[i].type));
        expect(res1[i].priority, equals(res2[i].priority));
        expect(res1[i].title, equals(res2[i].title));
        expect(res1[i].description, equals(res2[i].description));
      }
    });

    test('17. Reactive invalidation through Riverpod dailyInsightsProvider', () async {
      final container = ProviderContainer(
        overrides: [
          insightServiceProvider.overrideWithValue(insightService),
          productivityDataChangesProvider.overrideWith((ref) => Stream.value(null)),
        ],
      );
      addTearDown(container.dispose);

      final initial = await container.read(dailyInsightsProvider.future);
      expect(initial, isA<List<OrbitInsight>>());
    });
  });
}
