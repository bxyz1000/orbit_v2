import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../data/repositories/score_repository.dart';
import '../../data/repositories/personal_record_repository.dart';
import '../../data/repositories/achievement_repository.dart';
import '../../domain/services/score_service.dart';
import '../../domain/services/motivation_service.dart';
import '../../data/score_service_impl.dart';
import '../../data/motivation_service_impl.dart';
import '../../../../core/database/isar_database.dart';
import '../../../tasks/data/task_repository.dart';
import '../../../habits/data/habit_repository.dart';
import '../../../focus/data/focus_repository.dart';
import '../../../planner/data/planner_repository.dart';
import '../../../health/data/health_repository.dart';
import '../../../goals/data/goal_repository.dart';
import '../../domain/entities/daily_score.dart';
import '../../domain/entities/personal_record.dart';
import '../../domain/entities/achievement.dart';

// Repositories
final scoreRepositoryProvider = Provider<ScoreRepository>((ref) => ScoreRepository(IsarDatabase.instance));
final personalRecordRepositoryProvider = Provider<PersonalRecordRepository>((ref) => PersonalRecordRepository(IsarDatabase.instance));
final achievementRepositoryProvider = Provider<AchievementRepository>((ref) => AchievementRepository(IsarDatabase.instance));
final taskRepositoryProvider = Provider<TaskRepository>((ref) => TaskRepository(IsarDatabase.instance));
final habitRepositoryProvider = Provider<HabitRepository>((ref) => HabitRepository(IsarDatabase.instance));
final focusRepositoryProvider = Provider<FocusRepository>((ref) => FocusRepository(IsarDatabase.instance));
final plannerRepositoryProvider = Provider<PlannerRepository>((ref) => PlannerRepository(IsarDatabase.instance));
final healthRepositoryProvider = Provider<HealthRepository>((ref) => HealthRepository(IsarDatabase.instance));
final goalRepositoryProvider = Provider<GoalRepository>((ref) => GoalRepository(IsarDatabase.instance));

/// Provider for the [ScoreService].
final scoreServiceProvider = Provider<ScoreService>((ref) {
  return ScoreServiceImpl(
    ref.watch(scoreRepositoryProvider),
    ref.watch(personalRecordRepositoryProvider),
    ref.watch(taskRepositoryProvider),
    ref.watch(habitRepositoryProvider),
    ref.watch(focusRepositoryProvider),
    ref.watch(plannerRepositoryProvider),
    ref.watch(healthRepositoryProvider),
    ref.watch(goalRepositoryProvider),
  );
});

/// Provider for the [MotivationService].
final motivationServiceProvider = Provider<MotivationService>((ref) {
  return MotivationServiceImpl(
    ref.watch(scoreServiceProvider),
    ref.watch(scoreRepositoryProvider),
    ref.watch(personalRecordRepositoryProvider),
    ref.watch(achievementRepositoryProvider),
    ref.watch(taskRepositoryProvider),
    ref.watch(focusRepositoryProvider),
    ref.watch(habitRepositoryProvider),
  );
});

/// Reactive provider for a specific date's score.
final scoreForDateProvider = StreamProvider.family<DailyScore?, DateTime>((ref, date) {
  final service = ref.watch(scoreServiceProvider);
  return service.watchScore(date);
});

/// Stream that emits whenever any productivity data changes.
final productivityDataChangesProvider = StreamProvider<void>((ref) async* {
  final taskRepo = ref.watch(taskRepositoryProvider);
  final habitRepo = ref.watch(habitRepositoryProvider);
  final focusRepo = ref.watch(focusRepositoryProvider);
  final plannerRepo = ref.watch(plannerRepositoryProvider);
  final healthRepo = ref.watch(healthRepositoryProvider);
  final goalRepo = ref.watch(goalRepositoryProvider);

  final streams = [
    taskRepo.watchTasks(),
    habitRepo.watchHabits(),
    habitRepo.watchCompletions(),
    focusRepo.watchSessions(),
    plannerRepo.watchEvents(),
    healthRepo.watchSteps(),
    healthRepo.watchWorkouts(),
    healthRepo.watchSleep(),
    goalRepo.watchGoals(),
  ];

  for (final stream in streams) {
    yield* stream;
  }
});

/// Provider for the current daily score value.
final currentDailyScoreProvider = FutureProvider<DailyScore>((ref) async {
  final service = ref.watch(scoreServiceProvider);
  final motivation = ref.watch(motivationServiceProvider);
  
  ref.watch(productivityDataChangesProvider);

  final score = await service.calculateActiveScore(DateTime.now());
  
  unawaited(motivation.checkPersonalRecords(score.date));
  unawaited(motivation.evaluateAchievements());
  
  return score;
});

/// Provider for the current streak.
final currentStreakProvider = FutureProvider<int>((ref) async {
  final motivation = ref.watch(motivationServiceProvider);
  ref.watch(productivityDataChangesProvider);
  return motivation.calculateCurrentStreak();
});

/// Provider for all personal records.
final personalRecordsProvider = FutureProvider<List<PersonalRecord>>((ref) async {
  final motivation = ref.watch(motivationServiceProvider);
  ref.watch(productivityDataChangesProvider);
  return motivation.getPersonalRecords();
});

/// Provider for unlocked achievements.
final unlockedAchievementsProvider = FutureProvider<List<Achievement>>((ref) async {
  final motivation = ref.watch(motivationServiceProvider);
  ref.watch(productivityDataChangesProvider);
  return motivation.getUnlockedAchievements();
});

/// Provider for motivation events stream.
final motivationEventsProvider = StreamProvider<MotivationEvent>((ref) {
  return ref.watch(motivationServiceProvider).watchMotivationEvents();
});

/// Provider for current score version.
final scoreVersionProvider = Provider<String>((ref) => ref.watch(scoreServiceProvider).scoreVersion);
