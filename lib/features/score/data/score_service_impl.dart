import 'dart:async';
import 'dart:math';

import '../../tasks/data/task_repository.dart';
import '../../habits/data/habit_repository.dart';
import '../../focus/data/focus_repository.dart';
import '../../planner/data/planner_repository.dart';
import '../../health/data/health_repository.dart';
import '../../goals/data/goal_repository.dart';
import 'package:orbit_v2/features/score/domain/entities/daily_score.dart';
import 'package:orbit_v2/features/score/domain/entities/weekly_score.dart';
import 'package:orbit_v2/features/score/domain/entities/monthly_score.dart';
import 'package:orbit_v2/features/score/domain/entities/personal_record.dart';
import 'package:orbit_v2/features/score/domain/services/score_service.dart';
import 'repositories/score_repository.dart';
import 'repositories/personal_record_repository.dart';
import 'package:orbit_v2/features/integrations/strava/domain/repositories/i_strava_repository.dart';
import 'package:orbit_v2/features/score/domain/entities/score_input_model.dart';
import 'package:orbit_v2/features/score/domain/services/score_engine_v2.dart';

class ScoreServiceImpl implements ScoreService {
  final ScoreRepository _scoreRepository;
  final PersonalRecordRepository _recordRepository;
  final TaskRepository _taskRepository;
  final HabitRepository _habitRepository;
  final FocusRepository _focusRepository;
  final PlannerRepository _plannerRepository;
  final HealthRepository _healthRepository;
  final GoalRepository _goalRepository;
  final IStravaRepository? _stravaRepository;

  ScoreServiceImpl(
    this._scoreRepository,
    this._recordRepository,
    this._taskRepository,
    this._habitRepository,
    this._focusRepository,
    this._plannerRepository,
    this._healthRepository,
    this._goalRepository, [
    this._stravaRepository,
  ]);


  @override
  String get scoreVersion => '2.0';


  @override
  Future<DailyScore> calculateActiveScore(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);

    // Check if score is already finalized in DB
    final existing = await _scoreRepository.getDailyScore(startOfDay);
    if (existing != null && existing.isFinalized) {
      return existing;
    }

    // Check if we should finalize now (it's past 11:55 PM today or it's a previous day)
    if (_isPastFinalizationTime(date)) {
      await finalizeDay(date);
      final finalized = await _scoreRepository.getDailyScore(startOfDay);
      if (finalized != null) return finalized;
    }
    
    return await _calculateRawScore(date);

  }

  @override
  Future<WeeklyScore> calculateWeeklyScore(DateTime date) async {
    final weekStart = _getWeekStart(date);
    int total = 0;
    int tasks = 0;
    int habits = 0;
    int focus = 0;
    int health = 0;
    int daysCount = 0;

    for (int i = 0; i < 7; i++) {
      final currentDay = weekStart.add(Duration(days: i));
      if (currentDay.isAfter(DateTime.now())) break;

      final score = await _scoreRepository.getDailyScore(currentDay) ?? await _calculateRawScore(currentDay);
      total += score.totalScore;
      tasks += score.taskScore;
      habits += score.habitScore;
      focus += score.focusScore;
      health += (score.stepsScore + score.workoutScore + score.sleepScore);
      daysCount++;
    }


    final weeklyScore = WeeklyScore(
      weekStartDate: weekStart,
      totalScore: total,
      averageDailyScore: daysCount > 0 ? total / daysCount : 0.0,
      taskScore: tasks,
      habitScore: habits,
      focusScore: focus,
      healthScore: health,
      scoreVersion: scoreVersion,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _scoreRepository.saveWeeklyScore(weeklyScore);
    return weeklyScore;
  }

  @override
  Future<MonthlyScore> calculateMonthlyScore(DateTime date) async {
    final monthStart = _getMonthStart(date);
    final monthEnd = DateTime(monthStart.year, monthStart.month + 1, 0);
    int total = 0;
    int tasks = 0;
    int habits = 0;
    int focus = 0;
    int health = 0;

    final daysInMonth = monthEnd.day;
    for (int i = 0; i < daysInMonth; i++) {
      final currentDay = monthStart.add(Duration(days: i));
      if (currentDay.isAfter(DateTime.now())) break;

      final score = await _scoreRepository.getDailyScore(currentDay) ?? await _calculateRawScore(currentDay);
      total += score.totalScore;
      tasks += score.taskScore;
      habits += score.habitScore;
      focus += score.focusScore;
      health += (score.stepsScore + score.workoutScore + score.sleepScore);
    }


    final monthlyScore = MonthlyScore(
      monthStartDate: monthStart,
      totalScore: total,
      taskScore: tasks,
      habitScore: habits,
      focusScore: focus,
      healthScore: health,
      scoreVersion: scoreVersion,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _scoreRepository.saveMonthlyScore(monthlyScore);
    return monthlyScore;
  }

  DateTime _getWeekStart(DateTime date) {
    return DateTime(date.year, date.month, date.day).subtract(Duration(days: date.weekday - 1));
  }

  DateTime _getMonthStart(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  bool _isPastFinalizationTime(DateTime date) {
    final now = DateTime.now();
    final startOfDate = DateTime(date.year, date.month, date.day);
    final startOfToday = DateTime(now.year, now.month, now.day);

    if (startOfDate.isBefore(startOfToday)) return true;
    if (startOfDate.isAtSameMomentAs(startOfToday)) {
      if (now.hour > 23 || (now.hour == 23 && now.minute >= 55)) return true;
    }
    return false;
  }

  @override
  Future<void> finalizeDay(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    
    final score = (await _calculateRawScore(startOfDay)).copyWith(
      isFinalized: true,
      updatedAt: DateTime.now(),
    );
    await _scoreRepository.saveDailyScore(score);

    await _recordRepository.updateIfHigher('highest_daily_score', score.totalScore.toDouble(), score.date);
    
    final streak = await _calculateStreak(score.date);
    await _recordRepository.updateIfHigher('longest_streak', streak.toDouble(), score.date);

    if (_stravaRepository != null) {
      final endOfDay = DateTime(startOfDay.year, startOfDay.month, startOfDay.day, 23, 59, 59, 999);
      final stravaActivities = await _stravaRepository.getActivitiesForDateRange(startOfDay, endOfDay);
      for (final sa in stravaActivities) {
        await _recordRepository.updateIfHigher('longest_strava_distance', sa.distanceKm, sa.startDate);
        await _recordRepository.updateIfHigher('highest_strava_elevation', sa.elevationGainMeters, sa.startDate);
        await _recordRepository.updateIfHigher('longest_strava_workout', sa.durationMinutes.toDouble(), sa.startDate);
      }
    }
    
    await calculateWeeklyScore(date);
    await calculateMonthlyScore(date);
  }


  Future<DailyScore> _calculateRawScore(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    
    // 1. Task & Execution Inputs
    final tasks = await _taskRepository.getAllTasks();
    final completedTasks = tasks.where((t) => 
        t.completed && t.completedAt != null && _isSameDay(t.completedAt!, startOfDay)).toList();
    final overdueTaskCount = tasks.where((t) => !t.completed && t.dueDate != null && t.dueDate!.isBefore(startOfDay)).length;
    final plannerEvents = await _plannerRepository.getAllEvents();
    final completedPlannerEvents = plannerEvents.where((e) => e.isCompleted && _isSameDay(e.date, startOfDay)).toList();

    // 2. Habit Inputs
    final allHabits = await _habitRepository.getAllHabits();
    final completions = await _habitRepository.getCompletionsForDate(startOfDay);

    // 3. Focus Inputs
    final focusSessions = await _focusRepository.getAllSessions();
    final todaySessions = focusSessions.where((s) => s.completed && _isSameDay(s.startedAt, startOfDay));
    final focusMinutes = todaySessions.fold<int>(0, (sum, s) => sum + s.duration);

    // 4. Health Inputs
    final stepLog = await _healthRepository.getStepsForDate(startOfDay);
    final sleepLog = await _healthRepository.getSleepForDate(startOfDay);
    final workoutLogs = await _healthRepository.getWorkoutsForDate(startOfDay);

    int workoutMinutes = 0;
    if (_stravaRepository != null) {
      final endOfDay = DateTime(startOfDay.year, startOfDay.month, startOfDay.day, 23, 59, 59, 999);
      final stravaActivities = await _stravaRepository.getActivitiesForDateRange(startOfDay, endOfDay);
      for (final w in workoutLogs) {
        final isDuplicate = stravaActivities.any((sa) =>
            sa.startDate.difference(w.date).abs() <= const Duration(minutes: 15) &&
            (sa.durationMinutes - w.durationMinutes).abs() <= 15);
        if (!isDuplicate) {
          workoutMinutes += w.durationMinutes;
        }
      }
      for (final sa in stravaActivities) {
        workoutMinutes += sa.durationMinutes;
      }
    } else {
      workoutMinutes = workoutLogs.fold<int>(0, (sum, w) => sum + w.durationMinutes);
    }

    // 5. Goals & Integrations
    final goals = await _goalRepository.getGoalsForDate(startOfDay);
    final completedGoalsCount = goals.where((g) => g.completed && !g.isLongTerm).length;
    final isAuthorizedHealth = await _healthRepository.isAuthorized();
    final isHealthConnected = isAuthorizedHealth || stepLog != null || workoutLogs.isNotEmpty || sleepLog != null;
    final isStravaConnected = _stravaRepository != null;


    // 6. Historical Scores for 7-day EMA
    final historicalDailyScores = await _scoreRepository.getRecentDailyScores(startOfDay, limit: 14);

    final input = ScoreInputModel(
      date: startOfDay,
      completedTasks: completedTasks,
      overdueTaskCount: overdueTaskCount,
      completedPlannerEvents: completedPlannerEvents,
      activeHabitsCount: max(1, allHabits.length),
      completedHabitsCount: completions.length,
      focusMinutes: focusMinutes,
      steps: stepLog?.count ?? 0,
      workoutMinutes: workoutMinutes,
      sleepMinutes: sleepLog?.durationMinutes ?? 0,
      completedGoalsCount: completedGoalsCount,
      isHealthConnected: isHealthConnected,
      isStravaConnected: isStravaConnected,
      historicalDailyScores: historicalDailyScores,
    );

    final result = ScoreEngineV2.calculate(input);
    return result.score;
  }

  @override
  Future<void> recalculateHistoricalScores() async {}

  @override
  Future<List<PersonalRecord>> getRecords() async {
    return await _recordRepository.getAllRecords();
  }

  @override
  Stream<DailyScore?> watchScore(DateTime date) {
    return _scoreRepository.streamDailyScore(date);
  }

  Future<int> _calculateStreak(DateTime today) async {
    int streak = 0;
    int missedDays = 0;
    DateTime current = today.subtract(const Duration(days: 1));
    
    while (missedDays < 5) {
      final score = await _scoreRepository.getDailyScore(current);
      if (score != null && score.totalScore >= 50) {
        streak++;
        missedDays = 0;
      } else {
        missedDays++;
      }
      current = current.subtract(const Duration(days: 1));
      if (streak > 5000) break;
    }
    
    final todayScore = await _scoreRepository.getDailyScore(today);
    if (todayScore != null && todayScore.totalScore >= 50) streak++;
    
    return streak;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
