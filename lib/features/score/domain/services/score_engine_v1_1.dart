import 'dart:math';
import '../entities/daily_score.dart';
import '../entities/score_input_model.dart';
import 'package:orbit_v2/features/health/domain/calculators/health_score_calculator.dart';
import 'package:orbit_v2/features/health/domain/entities/health_snapshot.dart';

/// Legacy Score Engine v1.1 calculation logic preserved for historical score reproducibility.
class ScoreEngineV1_1 {
  static const String version = '1.1';

  static DailyScore calculate(ScoreInputModel input) {
    final startOfDay = DateTime(input.date.year, input.date.month, input.date.day);

    // 1. Tasks
    final completedTasksCount = input.completedTasks.length;
    final taskScore = completedTasksCount * 10;

    // 2. Habits
    final habitScore = input.completedHabitsCount * 15;

    // 3. Focus
    const maxDailyFocus = 120;
    final focusMinutes = input.focusMinutes;
    double focusPoints = (min(focusMinutes, maxDailyFocus) / 25) * 20;
    if (focusMinutes > maxDailyFocus) {
      focusPoints += ((focusMinutes - maxDailyFocus) / 25) * 20 * 0.5;
    }
    final focusScore = focusPoints.round();

    // 4. Health
    final healthSnapshot = HealthSnapshot(
      steps: input.steps,
      calories: 0,
      distance: 0,
      activeMinutes: 0,
      sleepMinutes: input.sleepMinutes,
      workoutMinutes: input.workoutMinutes,
      timestamp: input.date,
    );
    final healthScore = HealthScoreCalculator.calculateScore(healthSnapshot);
    final stepsPoints = (input.steps >= 10000) ? 15 : (input.steps >= 5000 ? 8 : 0);
    final workoutPoints = (input.workoutMinutes >= 30) ? 20 : (input.workoutMinutes >= 15 ? 10 : 0);
    const sleepGoalMins = 8 * 60;
    final sleepDiff = (input.sleepMinutes - sleepGoalMins).abs();
    final sleepPoints = input.sleepMinutes > 0 ? (sleepDiff <= 60 ? 15 : (sleepDiff <= 120 ? 8 : 0)) : 0;

    // 5. Planner
    final plannerScore = input.completedPlannerEvents.length * 10;

    // 6. Goals
    final goalScore = input.completedGoalsCount * 100;

    // 7. Penalties
    final penaltyScore = min(20, input.overdueTaskCount * 2);

    // 8. Streak & Multiplier
    int streak = _calculateStreak(input.historicalDailyScores, startOfDay);
    double multiplier = 1.0;
    if (streak >= 100) multiplier = 1.5;
    else if (streak >= 30) multiplier = 1.2;
    else if (streak >= 7) multiplier = 1.1;

    // 9. Bonuses
    int bonusScore = 0;
    final yesterdayDate = startOfDay.subtract(const Duration(days: 1));
    final yesterdayScore = input.historicalDailyScores.cast<DailyScore?>().firstWhere(
      (s) => s != null && s.date.year == yesterdayDate.year && s.date.month == yesterdayDate.month && s.date.day == yesterdayDate.day,
      orElse: () => null,
    );

    if (yesterdayScore != null && yesterdayScore.isFinalized) {
      int currentSubtotal = taskScore + habitScore + focusScore + healthScore + plannerScore + goalScore - penaltyScore;
      if (currentSubtotal > yesterdayScore.totalScore) bonusScore += 25;
    }

    if (streak == 7) bonusScore += 100;
    if (streak == 30) bonusScore += 500;
    if (streak == 100) bonusScore += 2000;

    bool isBalanced = completedTasksCount >= 3 && input.completedHabitsCount > 0 && focusMinutes >= 25 && stepsPoints >= 8;
    if (isBalanced) bonusScore += 75;

    int totalScore = (((taskScore + habitScore + focusScore + healthScore + plannerScore + goalScore + bonusScore - penaltyScore) * multiplier)).round();
    totalScore = max(0, totalScore);

    return DailyScore.create(
      date: startOfDay,
      totalScore: totalScore,
      taskScore: taskScore,
      plannerScore: plannerScore,
      habitScore: habitScore,
      focusScore: focusScore,
      stepsScore: stepsPoints,
      workoutScore: workoutPoints,
      sleepScore: sleepPoints,
      goalScore: goalScore,
      consistencyScore: (totalScore * (multiplier - 1.0)).round(),
      bonusScore: bonusScore,
      penaltyScore: penaltyScore,
      scoreVersion: version,
    );
  }

  static int _calculateStreak(List<DailyScore> history, DateTime today) {
    int streak = 0;
    int missedDays = 0;
    DateTime current = today.subtract(const Duration(days: 1));

    while (missedDays < 5) {
      final score = history.cast<DailyScore?>().firstWhere(
        (s) => s != null && s.date.year == current.year && s.date.month == current.month && s.date.day == current.day,
        orElse: () => null,
      );
      if (score != null && score.totalScore >= 50) {
        streak++;
        missedDays = 0;
      } else {
        missedDays++;
      }
      current = current.subtract(const Duration(days: 1));
      if (streak > 5000) break;
    }

    final todayScore = history.cast<DailyScore?>().firstWhere(
      (s) => s != null && s.date.year == today.year && s.date.month == today.month && s.date.day == today.day,
      orElse: () => null,
    );
    if (todayScore != null && todayScore.totalScore >= 50) streak++;

    return streak;
  }
}
