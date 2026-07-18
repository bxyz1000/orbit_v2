import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../domain/services/score_service.dart';
import '../../domain/services/motivation_service.dart';
import '../../data/score_service_impl.dart';
import '../../data/motivation_service_impl.dart';
import '../../../../shared/providers/repository_providers.dart';
import 'package:orbit_v2/features/score/domain/entities/daily_score.dart';
import 'package:orbit_v2/features/score/domain/entities/weekly_score.dart';
import 'package:orbit_v2/features/score/domain/entities/monthly_score.dart';
import 'package:orbit_v2/features/score/domain/entities/personal_record.dart';
import 'package:orbit_v2/features/score/domain/entities/achievement.dart';

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

/// Provider for yesterday's daily score value.
final yesterdayScoreProvider = FutureProvider<DailyScore?>((ref) async {
  final service = ref.watch(scoreServiceProvider);
  return service.calculateActiveScore(DateTime.now().subtract(const Duration(days: 1)));
});

/// Provider for the last 7 days of daily scores.
final lastSevenDaysScoresProvider = FutureProvider<List<DailyScore>>((ref) async {
  final service = ref.watch(scoreServiceProvider);
  ref.watch(productivityDataChangesProvider);
  
  final List<DailyScore> scores = [];
  for (int i = 6; i >= 0; i--) {
    final date = DateTime.now().subtract(Duration(days: i));
    scores.add(await service.calculateActiveScore(date));
  }
  return scores;
});

/// Provider for the last 30 days of daily scores.
final lastThirtyDaysScoresProvider = FutureProvider<List<DailyScore>>((ref) async {
  final service = ref.watch(scoreServiceProvider);
  ref.watch(productivityDataChangesProvider);
  
  final List<DailyScore> scores = [];
  for (int i = 29; i >= 0; i--) {
    final date = DateTime.now().subtract(Duration(days: i));
    scores.add(await service.calculateActiveScore(date));
  }
  return scores;
});

/// Provider for the current weekly score value.
final currentWeeklyScoreProvider = FutureProvider<WeeklyScore>((ref) async {
  final service = ref.watch(scoreServiceProvider);
  ref.watch(productivityDataChangesProvider);
  return service.calculateWeeklyScore(DateTime.now());
});

/// Provider for the current monthly score value.
final currentMonthlyScoreProvider = FutureProvider<MonthlyScore>((ref) async {
  final service = ref.watch(scoreServiceProvider);
  ref.watch(productivityDataChangesProvider);
  return service.calculateMonthlyScore(DateTime.now());
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

/// Provider for today's focus sessions.
final todaySessionsProvider = FutureProvider((ref) async {
  final repo = ref.watch(focusRepositoryProvider);
  ref.watch(productivityDataChangesProvider);
  return repo.getTodaySessions();
});
