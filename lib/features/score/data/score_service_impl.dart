import 'dart:async';
import 'dart:math';

import '../../tasks/data/task_repository.dart';
import '../../habits/data/habit_repository.dart';
import '../../focus/data/focus_repository.dart';
import '../../planner/data/planner_repository.dart';
import '../../health/data/health_repository.dart';
import '../../goals/data/goal_repository.dart';
import '../domain/entities/daily_score.dart';
import '../domain/entities/personal_record.dart';
import '../domain/services/score_service.dart';
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
    
    // Algorithm: (Minutes / 25) * 20. Diminishing returns after cap (using 120m default).
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
      const stepGoal = 10000; // Default goal
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

    // 9. Bonuses (Calculated based on previous days)
    int bonusScore = 0;
    final yesterdayScore = await _scoreRepository.getDailyScore(startOfDay.subtract(const Duration(days: 1)));
    if (yesterdayScore != null && yesterdayScore.isFinalized) {
      // Beat Yesterday
      int currentSubtotal = taskScore + habitScore + focusScore + healthScore + plannerScore + goalScore - penaltyScore;
      if (currentSubtotal > yesterdayScore.totalScore) {
        bonusScore += 25;
      }
    }

    // Streak Milestones
    if (streak == 7) {
      bonusScore += 100;
    } else if (streak == 30) {
      bonusScore += 500;
    } else if (streak == 100) {
      bonusScore += 2000;
    }

    // Perfect Balance
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
  Future<void> finalizeDay(DateTime date) async {
    final score = await calculateActiveScore(date);
    score.isFinalized = true;
    score.updatedAt = DateTime.now();
    await _scoreRepository.saveDailyScore(score);

    // Update PRs
    await _recordRepository.updateIfHigher('highest_daily_score', score.totalScore.toDouble(), score.date);
    
    final streak = await _calculateStreak(score.date);
    await _recordRepository.updateIfHigher('longest_streak', streak.toDouble(), score.date);
    
    // Update Weekly/Monthly aggregates (simplified for engine implementation)
    // TODO: Implement full aggregation logic
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
