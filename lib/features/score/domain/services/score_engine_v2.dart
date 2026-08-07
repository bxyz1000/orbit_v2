import 'dart:math';
import '../entities/daily_score.dart';
import '../entities/daily_score_explanation.dart';
import '../entities/score_category_breakdown.dart';
import '../entities/score_input_model.dart';

/// Pure domain implementation of Orbit Score Engine V2.
/// Features:
/// - 0 to 100 strictly bounded score scale.
/// - 25% equal category weighting (with adaptive scaling if Health Connect is unavailable).
/// - Anti-gaming caps on tasks, habits, focus, and health.
/// - Rolling 7-day EMA baseline & self-improvement progress multiplier (1.0x to 1.1x).
/// - Full explainability breakdown.
/// - Version tag "2.0".
class ScoreEngineV2 {
  static const String version = '2.0';

  /// Calculates the complete V2 score and returns both the DailyScore entity and full explanation.
  static ({DailyScore score, DailyScoreExplanation explanation}) calculate(ScoreInputModel input) {
    final startOfDay = DateTime(input.date.year, input.date.month, input.date.day);

    // 1. Task & Execution Category (Max 25 pts)
    final completedTasksCount = input.completedTasks.length;
    final taskPoints = min(20.0, completedTasksCount * 4.0);
    final plannerPoints = min(5.0, input.completedPlannerEvents.length * 2.5);
    final penalty = min(5.0, input.overdueTaskCount * 1.0);
    final taskCategoryPts = max(0.0, min(25.0, taskPoints + plannerPoints - penalty));

    final taskBreakdown = ScoreCategoryBreakdown(
      categoryName: 'Tasks & Execution',
      rawValue: completedTasksCount.toDouble(),
      normalizedValue: (taskCategoryPts / 25.0) * 100.0,
      weightedContribution: taskCategoryPts,
      maxContribution: 25.0,
      isActive: true,
      explanation: '$completedTasksCount tasks completed, ${input.completedPlannerEvents.length} events (+${taskCategoryPts.toStringAsFixed(1)} pts)',
    );

    // 2. Habit Consistency Category (Max 25 pts)
    final double habitRatio = input.activeHabitsCount > 0 
        ? min(1.0, input.completedHabitsCount / input.activeHabitsCount) 
        : 0.0;
    final habitCategoryPts = habitRatio * 25.0;

    final habitBreakdown = ScoreCategoryBreakdown(
      categoryName: 'Habit Consistency',
      rawValue: input.completedHabitsCount.toDouble(),
      normalizedValue: habitRatio * 100.0,
      weightedContribution: habitCategoryPts,
      maxContribution: 25.0,
      isActive: true,
      explanation: '${input.completedHabitsCount}/${input.activeHabitsCount} habits completed (${(habitRatio * 100).round()}%)',
    );

    // 3. Focus Flow Category (Max 25 pts)
    final focusMins = input.focusMinutes;
    double focusCategoryPts = 0.0;
    if (focusMins >= 10) {
      if (focusMins <= 50) {
        focusCategoryPts = (focusMins / 25.0) * 10.0;
      } else {
        focusCategoryPts = 20.0 + (min(30.0, (focusMins - 50).toDouble()) / 30.0) * 5.0;
      }
    }
    focusCategoryPts = min(25.0, focusCategoryPts);


    final focusBreakdown = ScoreCategoryBreakdown(
      categoryName: 'Focus Flow',
      rawValue: focusMins.toDouble(),
      normalizedValue: (focusCategoryPts / 25.0) * 100.0,
      weightedContribution: focusCategoryPts,
      maxContribution: 25.0,
      isActive: true,
      explanation: '$focusMins focus minutes logged (+${focusCategoryPts.toStringAsFixed(1)} pts)',
    );

    // 4. Health & Vitality Category (Max 25 pts)
    final isHealthActive = input.isHealthConnected;
    double stepsPts = 0.0;
    double workoutPts = 0.0;
    double sleepPts = 0.0;

    if (isHealthActive) {
      stepsPts = min(10.0, (input.steps / 8000.0) * 10.0);
      workoutPts = min(10.0, (input.workoutMinutes / 30.0) * 10.0);

      if (input.sleepMinutes > 0) {
        final sleepDiff = (input.sleepMinutes - 480).abs();
        if (sleepDiff <= 60) {
          sleepPts = 5.0; // 7-9 hours
        } else if (sleepDiff <= 120) {
          sleepPts = 2.5; // 6-10 hours
        }
      }
    }
    final healthCategoryPts = isHealthActive ? min(25.0, stepsPts + workoutPts + sleepPts) : 0.0;

    final healthBreakdown = ScoreCategoryBreakdown(
      categoryName: 'Health & Vitality',
      rawValue: input.steps.toDouble(),
      normalizedValue: isHealthActive ? (healthCategoryPts / 25.0) * 100.0 : 0.0,
      weightedContribution: healthCategoryPts,
      maxContribution: isHealthActive ? 25.0 : 0.0,
      isActive: isHealthActive,
      explanation: isHealthActive 
          ? '${input.steps} steps, ${input.workoutMinutes}m workout, ${input.sleepMinutes}m sleep (+${healthCategoryPts.toStringAsFixed(1)} pts)'
          : 'Health Connect disconnected (Adaptive scaling applied)',
    );

    // 5. Adaptive Category Scaling (If Health Connect is disconnected)
    final categories = {
      'task': taskBreakdown,
      'habit': habitBreakdown,
      'focus': focusBreakdown,
      'health': healthBreakdown,
    };

    final activeCategories = categories.values.where((c) => c.isActive).toList();
    final double rawActivePtsSum = activeCategories.fold(0.0, (sum, c) => sum + c.weightedContribution);
    final double maxPossibleActivePts = activeCategories.fold(0.0, (sum, c) => sum + c.maxContribution);

    final double baseScore = maxPossibleActivePts > 0 
        ? min(100.0, (rawActivePtsSum / maxPossibleActivePts) * 100.0) 
        : 0.0;

    // 6. 7-Day Rolling EMA Baseline & Progress Multiplier
    final emaBaseline = calculate7DayEma(input.historicalDailyScores, startOfDay);
    double progressMultiplier = 1.0;

    if (emaBaseline > 0 && baseScore > emaBaseline) {
      final progress = (baseScore - emaBaseline) / emaBaseline;
      progressMultiplier = 1.0 + min(0.10, progress * 0.10);
    }

    // 7. Final Score (Bounded strictly 0 <= score <= 100)
    final int finalScore = max(0, min(100, (baseScore * progressMultiplier).round()));

    // Build DailyScore entity
    final dailyScore = DailyScore.create(
      date: startOfDay,
      totalScore: finalScore,
      taskScore: taskCategoryPts.round(),
      plannerScore: plannerPoints.round(),
      habitScore: habitCategoryPts.round(),
      focusScore: focusCategoryPts.round(),
      stepsScore: stepsPts.round(),
      workoutScore: (workoutPts * 2.0).round(), // 0-20 scale for workout score compatibility
      sleepScore: (sleepPts * 3.0).round(),   // 0-15 scale for sleep score compatibility
      goalScore: min(100, input.completedGoalsCount * 25),
      consistencyScore: ((progressMultiplier - 1.0) * 100).round(),
      bonusScore: (progressMultiplier > 1.0) ? ((finalScore - baseScore).round()) : 0,
      penaltyScore: penalty.round(),
      scoreVersion: version,
    );

    final explanation = DailyScoreExplanation(
      date: startOfDay,
      finalScore: finalScore,
      baseScore: baseScore,
      progressMultiplier: progressMultiplier,
      emaBaseline7d: emaBaseline,
      categories: categories,
      scoreVersion: version,
    );

    return (score: dailyScore, explanation: explanation);
  }

  /// Calculates 7-day Exponential Moving Average of historical scores prior to [targetDate].
  static double calculate7DayEma(List<DailyScore> history, DateTime targetDate) {
    final startOfTarget = DateTime(targetDate.year, targetDate.month, targetDate.day);

    final priorScores = history
        .where((s) => s.date.isBefore(startOfTarget))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Recent first

    final recent7 = priorScores.take(7).toList();
    if (recent7.isEmpty) return 0.0;

    // Calculate EMA with smoothing factor alpha = 2 / (N + 1)
    double ema = recent7.last.totalScore.toDouble();
    final double alpha = 2.0 / (recent7.length + 1.0);

    for (int i = recent7.length - 1; i >= 0; i--) {
      ema = (recent7[i].totalScore * alpha) + (ema * (1.0 - alpha));
    }

    return ema;
  }
}
