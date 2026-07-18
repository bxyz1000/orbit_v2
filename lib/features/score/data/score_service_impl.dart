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

class ScoreServiceImpl implements ScoreService {
  final ScoreRepository _scoreRepository;
  final PersonalRecordRepository _recordRepository;
  final TaskRepository _taskRepository;
  final HabitRepository _habitRepository;
  final FocusRepository _focusRepository;
  final PlannerRepository _plannerRepository;
  final HealthRepository _healthRepository;
  final GoalRepository _goalRepository;

  ScoreServiceImpl(
    this._scoreRepository,
    this._recordRepository,
    this._taskRepository,
    this._habitRepository,
    this._focusRepository,
    this._plannerRepository,
    this._healthRepository,
    this._goalRepository,
  );

  @override
  String get scoreVersion => '1.1';

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
      return (await _scoreRepository.getDailyScore(startOfDay))!;
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

      final score = await calculateActiveScore(currentDay);
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

      final score = await calculateActiveScore(currentDay);
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
    
    // We re-calculate one last time to get the absolute latest state
    // But we avoid the check to prevent loop
    final score = (await _calculateRawScore(startOfDay)).copyWith(
      isFinalized: true,
      updatedAt: DateTime.now(),
    );
    await _scoreRepository.saveDailyScore(score);

    // Update PRs
    await _recordRepository.updateIfHigher('highest_daily_score', score.totalScore.toDouble(), score.date);
    
    final streak = await _calculateStreak(score.date);
    await _recordRepository.updateIfHigher('longest_streak', streak.toDouble(), score.date);
    
    // Trigger aggregate updates
    await calculateWeeklyScore(date);
    await calculateMonthlyScore(date);
  }

  /// Calculates score without finalization checks to avoid recursion.
  Future<DailyScore> _calculateRawScore(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    
    // 1. Task Score
    final tasks = await _taskRepository.getAllTasks();
    final completedTasks = tasks.where((t) => 
        t.completed && t.completedAt != null && _isSameDay(t.completedAt!, startOfDay)).length;
    final taskScore = completedTasks * 10;

    // 2. Habit Score
    final completions = await _habitRepository.getCompletionsForDate(startOfDay);
    final habitScore = completions.length * 15;

    // 3. Focus Score
    final focusSessions = await _focusRepository.getAllSessions();
    final todaySessions = focusSessions.where((s) => s.completed && _isSameDay(s.startedAt, startOfDay));
    final focusMinutes = todaySessions.fold<int>(0, (sum, s) => sum + s.duration);
    
    const maxDailyFocus = 120;
    double focusPoints = (min(focusMinutes, maxDailyFocus) / 25) * 20;
    if (focusMinutes > maxDailyFocus) {
      focusPoints += ((focusMinutes - maxDailyFocus) / 25) * 20 * 0.5;
    }
    final focusScore = focusPoints.round();

    // 4. Health Score
    final steps = await _healthRepository.getStepsForDate(startOfDay);
    int stepsPoints = 0;
    if (steps != null) {
      const stepGoal = 10000;
      if (steps.count >= stepGoal) {
        stepsPoints += 50;
        final bonusSteps = max(0, steps.count - stepGoal);
        stepsPoints += min(20, (bonusSteps ~/ 1000) * 2);
      }
    }

    final workouts = await _healthRepository.getWorkoutsForDate(startOfDay);
    final workoutMins = workouts.fold<int>(0, (sum, w) => sum + w.durationMinutes);
    int workoutPoints = 0;
    if (workoutMins >= 10) {
      workoutPoints = (workoutMins * 1.5).round();
    }

    final sleep = await _healthRepository.getSleepForDate(startOfDay);
    int sleepPoints = 0;
    if (sleep != null) {
      const sleepGoalMins = 8 * 60;
      if ((sleep.durationMinutes - sleepGoalMins).abs() <= 60) {
        sleepPoints = 40;
      }
    }
    final healthScore = stepsPoints + workoutPoints + sleepPoints;

    // 5. Planner Score
    final plannerEvents = await _plannerRepository.getAllEvents();
    final completedEvents = plannerEvents.where((e) => e.isCompleted && _isSameDay(e.date, startOfDay)).length;
    final plannerScore = completedEvents * 10;

    // 6. Goal Score
    final goals = await _goalRepository.getGoalsForDate(startOfDay);
    final completedGoals = goals.where((g) => g.completed && !g.isLongTerm).length;
    final goalScore = completedGoals * 100;

    // 7. Penalties
    final overdueTasks = tasks.where((t) => !t.completed && t.dueDate != null && t.dueDate!.isBefore(startOfDay)).length;
    final penaltyScore = min(20, overdueTasks * 2);

    // 8. Consistency Multiplier (Streak)
    final streak = await _calculateStreak(startOfDay);
    double multiplier = 1.0;
    if (streak >= 100) {
      multiplier = 1.5;
    } else if (streak >= 30) {
      multiplier = 1.2;
    } else if (streak >= 7) {
      multiplier = 1.1;
    }

    // 9. Bonuses
    int bonusScore = 0;
    final yesterdayScore = await _scoreRepository.getDailyScore(startOfDay.subtract(const Duration(days: 1)));
    if (yesterdayScore != null && yesterdayScore.isFinalized) {
      int currentSubtotal = taskScore + habitScore + focusScore + healthScore + plannerScore + goalScore - penaltyScore;
      if (currentSubtotal > yesterdayScore.totalScore) {
        bonusScore += 25;
      }
    }

    if (streak == 7) bonusScore += 100;
    if (streak == 30) bonusScore += 500;
    if (streak == 100) bonusScore += 2000;

    bool isBalanced = completedTasks >= 3 && completions.isNotEmpty && focusMinutes >= 25 && stepsPoints >= 50;
    if (isBalanced) bonusScore += 75;

    int totalScore = (((taskScore + habitScore + focusScore + healthScore + plannerScore + goalScore + bonusScore - penaltyScore) * multiplier)).round();
    totalScore = max(0, totalScore);

    return DailyScore.create(
      date: startOfDay,
      totalScore: totalScore,
      taskScore: taskScore,
      habitScore: habitScore,
      focusScore: focusScore,
      stepsScore: stepsPoints,
      workoutScore: workoutPoints,
      sleepScore: sleepPoints,
      goalScore: goalScore,
      consistencyScore: (totalScore * (multiplier - 1.0)).round(),
      bonusScore: bonusScore,
      penaltyScore: penaltyScore,
      scoreVersion: scoreVersion,
    );
  }

  @override
  Future<void> recalculateHistoricalScores() async {
    // Logic to iterate through history and re-run calculateActiveScore
  }

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
      // Safety break
      if (streak > 5000) break;
    }
    
    // If today is active, it counts
    final todayScore = await _scoreRepository.getDailyScore(today);
    if (todayScore != null && todayScore.totalScore >= 50) {
      streak++;
    }
    
    return streak;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
