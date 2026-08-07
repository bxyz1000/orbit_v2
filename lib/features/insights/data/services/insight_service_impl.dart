import 'dart:math';
import 'package:orbit_v2/features/score/domain/entities/daily_score.dart';
import 'package:orbit_v2/features/score/domain/entities/score_category_breakdown.dart';
import 'package:orbit_v2/features/score/domain/entities/score_input_model.dart';
import 'package:orbit_v2/features/score/domain/services/score_engine_v2.dart';
import 'package:orbit_v2/features/score/domain/services/score_service.dart';
import 'package:orbit_v2/features/score/data/repositories/personal_record_repository.dart';
import 'package:orbit_v2/features/tasks/data/task_repository.dart';
import 'package:orbit_v2/features/habits/data/habit_repository.dart';
import 'package:orbit_v2/features/focus/data/focus_repository.dart';
import 'package:orbit_v2/features/planner/data/planner_repository.dart';
import 'package:orbit_v2/features/health/data/health_repository.dart';
import 'package:orbit_v2/features/goals/data/goal_repository.dart';
import 'package:orbit_v2/features/integrations/strava/domain/repositories/i_strava_repository.dart';
import 'package:orbit_v2/features/score/data/repositories/score_repository.dart';

import '../../domain/entities/insight_priority.dart';
import '../../domain/entities/insight_type.dart';
import '../../domain/entities/orbit_insight.dart';
import '../../domain/services/i_insight_service.dart';

/// Pure deterministic implementation of Orbit Insight Engine.
class InsightServiceImpl implements IInsightService {
  final ScoreService _scoreService;
  final ScoreRepository _scoreRepository;
  final PersonalRecordRepository _recordRepository;
  final TaskRepository _taskRepository;
  final HabitRepository _habitRepository;
  final FocusRepository _focusRepository;
  final PlannerRepository _plannerRepository;
  final HealthRepository _healthRepository;
  final GoalRepository _goalRepository;
  final IStravaRepository? _stravaRepository;

  InsightServiceImpl({
    required ScoreService scoreService,
    required ScoreRepository scoreRepository,
    required PersonalRecordRepository recordRepository,
    required TaskRepository taskRepository,
    required HabitRepository habitRepository,
    required FocusRepository focusRepository,
    required PlannerRepository plannerRepository,
    required HealthRepository healthRepository,
    required GoalRepository goalRepository,
    IStravaRepository? stravaRepository,
  })  : _scoreService = scoreService,
        _scoreRepository = scoreRepository,
        _recordRepository = recordRepository,
        _taskRepository = taskRepository,
        _habitRepository = habitRepository,
        _focusRepository = focusRepository,
        _plannerRepository = plannerRepository,
        _healthRepository = healthRepository,
        _goalRepository = goalRepository,
        _stravaRepository = stravaRepository;

  @override
  Future<List<OrbitInsight>> generateDailyInsights([DateTime? date]) async {
    final targetDate = date ?? DateTime.now();
    final startOfDay = DateTime(targetDate.year, targetDate.month, targetDate.day);
    final insights = <OrbitInsight>[];

    // 1. Gather raw data & calculate V2 explanation
    final input = await _buildScoreInputModel(startOfDay);
    final v2Result = ScoreEngineV2.calculate(input);
    final activeScore = v2Result.score;
    final explanation = v2Result.explanation;

    // 2. Score Comparisons (vs Yesterday & vs 7-day EMA)
    final yesterdayDate = startOfDay.subtract(const Duration(days: 1));
    final yesterdayScore = await _scoreRepository.getDailyScore(yesterdayDate);

    if (yesterdayScore != null && yesterdayScore.totalScore > 0) {
      final diff = activeScore.totalScore - yesterdayScore.totalScore;
      if (diff > 0) {
        insights.add(OrbitInsight(
          id: 'score_imp_${startOfDay.millisecondsSinceEpoch}',
          type: InsightType.scoreImprovement,
          priority: diff >= 15 ? InsightPriority.high : InsightPriority.medium,
          title: 'Score Improved Today',
          description: 'Your Orbit Score increased by $diff points compared to yesterday (${yesterdayScore.totalScore} pts -> ${activeScore.totalScore} pts).',
          currentValue: activeScore.totalScore.toDouble(),
          previousValue: yesterdayScore.totalScore.toDouble(),
          change: diff.toDouble(),
          date: startOfDay,
        ));
      } else if (diff < 0) {
        final absDiff = diff.abs();
        insights.add(OrbitInsight(
          id: 'score_dec_${startOfDay.millisecondsSinceEpoch}',
          type: InsightType.scoreDecline,
          priority: absDiff >= 15 ? InsightPriority.high : InsightPriority.medium,
          title: 'Score Opportunity',
          description: 'Your Orbit Score is $absDiff points lower than yesterday (${yesterdayScore.totalScore} pts -> ${activeScore.totalScore} pts). Focus on your top growth area to catch up.',
          currentValue: activeScore.totalScore.toDouble(),
          previousValue: yesterdayScore.totalScore.toDouble(),
          change: diff.toDouble(),
          date: startOfDay,
        ));
      }
    }

    // 7-day EMA Baseline comparison
    final ema = explanation.emaBaseline7d;
    if (ema > 0) {
      if (explanation.baseScore > ema) {
        final diff = (explanation.baseScore - ema).round();
        insights.add(OrbitInsight(
          id: 'above_ema_${startOfDay.millisecondsSinceEpoch}',
          type: InsightType.aboveBaseline,
          priority: InsightPriority.medium,
          title: 'Above 7-Day Baseline',
          description: 'Your performance today is $diff points above your 7-day personal baseline (${ema.round()} pts).',
          currentValue: explanation.baseScore,
          previousValue: ema,
          change: (explanation.baseScore - ema),
          date: startOfDay,
        ));
      } else if (explanation.baseScore < ema) {
        final diff = (ema - explanation.baseScore).round();
        insights.add(OrbitInsight(
          id: 'below_ema_${startOfDay.millisecondsSinceEpoch}',
          type: InsightType.belowBaseline,
          priority: InsightPriority.low,
          title: 'Below 7-Day Baseline',
          description: 'Your score is $diff points below your rolling baseline. Small actions in Focus or Habits will lift your baseline.',
          currentValue: explanation.baseScore,
          previousValue: ema,
          change: (explanation.baseScore - ema),
          date: startOfDay,
        ));
      }
    }

    // 3. Category Performance & Growth Opportunity & Category Changes
    final categoryInsights = await generateCategoryInsights(startOfDay);
    insights.addAll(categoryInsights);

    // 4. Streaks
    final recentScores = input.historicalDailyScores;
    int streakDays = 0;
    if (recentScores.isNotEmpty) {
      for (final s in recentScores) {
        if (s.totalScore >= 50) {
          streakDays++;
        } else {
          break;
        }
      }
    }
    if (streakDays >= 3) {
      insights.add(OrbitInsight(
        id: 'streak_${startOfDay.millisecondsSinceEpoch}',
        type: InsightType.streak,
        priority: InsightPriority.high,
        title: '$streakDays-Day Consistency Streak',
        description: 'You have achieved a solid Orbit score for $streakDays consecutive days!',
        currentValue: streakDays.toDouble(),
        date: startOfDay,
      ));
    }

    // 5. Personal Records
    final records = await _recordRepository.getAllRecords();
    for (final rec in records) {
      if (rec.achievedAt.year == startOfDay.year &&
          rec.achievedAt.month == startOfDay.month &&
          rec.achievedAt.day == startOfDay.day) {
        insights.add(OrbitInsight(
          id: 'pr_${rec.recordType}_${startOfDay.millisecondsSinceEpoch}',
          type: InsightType.personalRecord,
          priority: InsightPriority.high,
          title: 'New Personal Best!',
          description: 'Congratulations! You set a new personal record in ${_formatRecordType(rec.recordType)}: ${rec.value.toStringAsFixed(0)}.',
          currentValue: rec.value,
          date: startOfDay,
          supportingData: {'recordType': rec.recordType},
        ));
      }
    }

    // 6. Deterministic Priority Sorting (High -> Medium -> Low)
    insights.sort((a, b) => a.priority.index.compareTo(b.priority.index));

    return insights;
  }

  @override
  Future<List<OrbitInsight>> generateCategoryInsights([DateTime? date]) async {
    final targetDate = date ?? DateTime.now();
    final startOfDay = DateTime(targetDate.year, targetDate.month, targetDate.day);
    final insights = <OrbitInsight>[];

    final input = await _buildScoreInputModel(startOfDay);
    final explanation = ScoreEngineV2.calculate(input).explanation;

    final activeCategories = explanation.categories.values.where((c) => c.isActive).toList();
    if (activeCategories.isEmpty) return insights;

    // Sort active categories by normalized score (0-100)
    activeCategories.sort((a, b) => b.normalizedValue.compareTo(a.normalizedValue));

    // Strongest category
    final strongest = activeCategories.first;
    if (strongest.normalizedValue > 0) {
      insights.add(OrbitInsight(
        id: 'strongest_${startOfDay.millisecondsSinceEpoch}',
        type: InsightType.strongestCategory,
        priority: InsightPriority.medium,
        title: 'Top Performing Area: ${strongest.categoryName}',
        description: '${strongest.categoryName} is your leading category today (${strongest.normalizedValue.round()}% completion). ${strongest.explanation}',
        category: strongest.categoryName,
        currentValue: strongest.normalizedValue,
        date: startOfDay,
      ));
    }

    // Weakest / Primary Growth Opportunity category
    final weakest = activeCategories.last;
    if (weakest.categoryName != strongest.categoryName && weakest.normalizedValue < 100.0) {
      insights.add(OrbitInsight(
        id: 'opp_${startOfDay.millisecondsSinceEpoch}',
        type: InsightType.biggestOpportunity,
        priority: InsightPriority.medium,
        title: 'Primary Opportunity: ${weakest.categoryName}',
        description: 'Focusing on ${weakest.categoryName} (${weakest.normalizedValue.round()}% current level) offers your highest potential score gain today.',
        category: weakest.categoryName,
        currentValue: weakest.normalizedValue,
        date: startOfDay,
      ));
    }

    // Category day-over-day changes (if yesterday's raw data exists)
    final yesterdayDate = startOfDay.subtract(const Duration(days: 1));
    try {
      final yesterdayInput = await _buildScoreInputModel(yesterdayDate);
      final yesterdayExplanation = ScoreEngineV2.calculate(yesterdayInput).explanation;

      for (final cat in activeCategories) {
        final yesterdayCat = yesterdayExplanation.categories.values.firstWhere(
          (c) => c.categoryName == cat.categoryName && c.isActive,
          orElse: () => cat,
        );
        if (yesterdayCat != cat) {
          final catDiff = cat.normalizedValue - yesterdayCat.normalizedValue;
          if (catDiff >= 15.0) {
            insights.add(OrbitInsight(
              id: 'cat_imp_${cat.categoryName}_${startOfDay.millisecondsSinceEpoch}',
              type: InsightType.categoryImprovement,
              priority: InsightPriority.medium,
              title: '${cat.categoryName} Improved',
              description: 'Your ${cat.categoryName} score increased by ${catDiff.round()}% compared to yesterday.',
              category: cat.categoryName,
              currentValue: cat.normalizedValue,
              previousValue: yesterdayCat.normalizedValue,
              change: catDiff,
              date: startOfDay,
            ));
          } else if (catDiff <= -15.0) {
            insights.add(OrbitInsight(
              id: 'cat_dec_${cat.categoryName}_${startOfDay.millisecondsSinceEpoch}',
              type: InsightType.categoryDecline,
              priority: InsightPriority.medium,
              title: '${cat.categoryName} Lower Today',
              description: 'Your ${cat.categoryName} output dropped by ${catDiff.abs().round()}% compared to yesterday.',
              category: cat.categoryName,
              currentValue: cat.normalizedValue,
              previousValue: yesterdayCat.normalizedValue,
              change: catDiff,
              date: startOfDay,
            ));
          }
        }
      }
    } catch (_) {
      // Ignore if historical input retrieval fails
    }

    return insights;
  }

  Future<ScoreInputModel> _buildScoreInputModel(DateTime startOfDay) async {
    final tasks = await _taskRepository.getAllTasks();
    final completedTasks = tasks.where((t) => 
        t.completed && t.completedAt != null && _isSameDay(t.completedAt!, startOfDay)).toList();
    final overdueTaskCount = tasks.where((t) => !t.completed && t.dueDate != null && t.dueDate!.isBefore(startOfDay)).length;
    final plannerEvents = await _plannerRepository.getAllEvents();
    final completedPlannerEvents = plannerEvents.where((e) => e.isCompleted && _isSameDay(e.date, startOfDay)).toList();

    final allHabits = await _habitRepository.getAllHabits();
    final completions = await _habitRepository.getCompletionsForDate(startOfDay);

    final focusSessions = await _focusRepository.getAllSessions();
    final todaySessions = focusSessions.where((s) => s.completed && _isSameDay(s.startedAt, startOfDay));
    final focusMinutes = todaySessions.fold<int>(0, (sum, s) => sum + s.duration);

    final stepLog = await _healthRepository.getStepsForDate(startOfDay);
    final sleepLog = await _healthRepository.getSleepForDate(startOfDay);
    final workoutLogs = await _healthRepository.getWorkoutsForDate(startOfDay);

    int workoutMinutes = 0;
    if (_stravaRepository != null) {
      final endOfDay = DateTime(startOfDay.year, startOfDay.month, startOfDay.day, 23, 59, 59, 999);
      final stravaActivities = await _stravaRepository!.getActivitiesForDateRange(startOfDay, endOfDay);
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

    final goals = await _goalRepository.getGoalsForDate(startOfDay);
    final completedGoalsCount = goals.where((g) => g.completed && !g.isLongTerm).length;
    final isAuthorizedHealth = await _healthRepository.isAuthorized();
    final isHealthConnected = isAuthorizedHealth || stepLog != null || workoutLogs.isNotEmpty || sleepLog != null;
    final isStravaConnected = _stravaRepository != null;

    final historicalDailyScores = await _scoreRepository.getRecentDailyScores(startOfDay, limit: 14);

    return ScoreInputModel(
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
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatRecordType(String type) {
    switch (type) {
      case 'highest_daily_score':
        return 'Daily Score';
      case 'longest_streak':
        return 'Streak';
      case 'longest_strava_distance':
        return 'Strava Distance';
      case 'highest_strava_elevation':
        return 'Strava Elevation';
      case 'longest_strava_workout':
        return 'Strava Duration';
      default:
        return type;
    }
  }
}
