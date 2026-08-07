import 'dart:math';
import '../../domain/analytics_period.dart';
import '../../domain/analytics_point.dart';
import '../../domain/focus_analytics.dart';
import '../../domain/goal_analytics.dart';
import '../../domain/habit_analytics.dart';
import '../../domain/health_analytics.dart';
import '../../domain/orbit_analytics.dart';
import '../../domain/period_comparison.dart';
import '../../domain/score_analytics.dart';
import '../../domain/task_analytics.dart';
import '../../domain/services/i_analytics_service.dart';
import '../../../score/domain/services/score_service.dart';
import '../../../score/data/repositories/score_repository.dart';
import '../../../score/data/repositories/personal_record_repository.dart';
import '../../../tasks/data/task_repository.dart';
import '../../../focus/data/focus_repository.dart';
import '../../../health/data/health_repository.dart';
import '../../../habits/data/habit_repository.dart';
import '../../../goals/data/goal_repository.dart';
import '../../domain/strava_analytics.dart';
import '../../../integrations/strava/domain/repositories/i_strava_repository.dart';
import '../../../integrations/strava/domain/services/strava_analytics_adapter.dart';

class AnalyticsServiceImpl implements IAnalyticsService {
  final ScoreService _scoreService;
  final ScoreRepository _scoreRepository;
  final TaskRepository _taskRepository;
  final FocusRepository _focusRepository;
  final HealthRepository _healthRepository;
  final HabitRepository _habitRepository;
  final GoalRepository _goalRepository;
  final PersonalRecordRepository _personalRecordRepository;
  final IStravaRepository? _stravaRepository;

  AnalyticsServiceImpl({
    required ScoreService scoreService,
    required ScoreRepository scoreRepository,
    required TaskRepository taskRepository,
    required FocusRepository focusRepository,
    required HealthRepository healthRepository,
    required HabitRepository habitRepository,
    required GoalRepository goalRepository,
    required PersonalRecordRepository personalRecordRepository,
    IStravaRepository? stravaRepository,
  })  : _scoreService = scoreService,
        _scoreRepository = scoreRepository,
        _taskRepository = taskRepository,
        _focusRepository = focusRepository,
        _healthRepository = healthRepository,
        _habitRepository = habitRepository,
        _goalRepository = goalRepository,
        _personalRecordRepository = personalRecordRepository,
        _stravaRepository = stravaRepository;


  @override
  Future<OrbitAnalytics> getAnalytics(AnalyticsPeriod period, [DateTime? referenceDate]) async {
    final now = referenceDate ?? DateTime.now();
    final startDate = period.getStartDate(now);
    final numDays = period.days;

    // Gather all historical raw data concurrently
    final futures = await Future.wait([
      _taskRepository.getAllTasks(),
      _focusRepository.getAllSessions(),
      _habitRepository.getAllHabits(),
      _personalRecordRepository.getAllRecords(),
    ]);

    final allTasks = futures[0] as List;
    final allFocus = futures[1] as List;
    final allHabits = futures[2] as List;
    final personalRecordList = futures[3] as List;

    // Build day list for current period
    final days = List.generate(
      numDays,
      (i) => DateTime(startDate.year, startDate.month, startDate.day).add(Duration(days: i)),
    );

    // 1. Score Analytics
    final List<AnalyticsPoint<int>> dailyScores = [];
    int scoreSum = 0;
    int maxScore = 0;
    int minScore = 1000000;

    for (final day in days) {
      final scoreObj = await _scoreService.calculateActiveScore(day);
      final val = scoreObj.totalScore;
      dailyScores.add(AnalyticsPoint(date: day, value: val));
      scoreSum += val;
      if (val > maxScore) maxScore = val;
      if (val < minScore) minScore = val;
    }

    final avgScore = numDays > 0 ? scoreSum / numDays : 0.0;
    final effectiveMinScore = dailyScores.isEmpty ? 0 : (minScore == 1000000 ? 0 : minScore);

    // Score comparison against previous equal period
    final prevStartDate = startDate.subtract(Duration(days: numDays));
    int prevScoreSum = 0;
    for (int i = 0; i < numDays; i++) {
      final pDay = prevStartDate.add(Duration(days: i));
      final pScore = await _scoreService.calculateActiveScore(pDay);
      prevScoreSum += pScore.totalScore;
    }
    final prevAvgScore = numDays > 0 ? prevScoreSum / numDays : 0.0;
    final scoreComparison = PeriodComparison.calculate(avgScore, prevAvgScore);

    final scoreAnalytics = ScoreAnalytics(
      dailyScores: dailyScores,
      averageScore: avgScore,
      highestScore: maxScore,
      lowestScore: effectiveMinScore,
      comparison: scoreComparison,
    );

    // 2. Task Analytics
    final List<AnalyticsPoint<int>> completedPerDay = [];
    final List<AnalyticsPoint<int>> totalPerDay = [];
    int totalCompletedTasks = 0;
    int totalTasksCount = 0;
    DateTime? bestTaskDay;
    int maxTasksCompletedInADay = -1;
    double dailyCompletionRatesSum = 0.0;

    for (final day in days) {
      int dayCompleted = 0;
      int dayTotal = 0;

      for (final t in allTasks) {
        final createdDay = t.createdAt != null ? DateTime(t.createdAt!.year, t.createdAt!.month, t.createdAt!.day) : null;
        final completedDay = t.completedAt != null ? DateTime(t.completedAt!.year, t.completedAt!.month, t.completedAt!.day) : null;

        if (t.completed && completedDay != null && _isSameDay(completedDay, day)) {
          dayCompleted++;
        }
        if (createdDay != null && _isSameDay(createdDay, day)) {
          dayTotal++;
        }
      }

      completedPerDay.add(AnalyticsPoint(date: day, value: dayCompleted));
      totalPerDay.add(AnalyticsPoint(date: day, value: dayTotal));
      totalCompletedTasks += dayCompleted;
      totalTasksCount += dayTotal;

      if (dayCompleted > maxTasksCompletedInADay && dayCompleted > 0) {
        maxTasksCompletedInADay = dayCompleted;
        bestTaskDay = day;
      }

      final dayRate = dayTotal > 0 ? (dayCompleted / dayTotal) * 100.0 : (dayCompleted > 0 ? 100.0 : 0.0);
      dailyCompletionRatesSum += dayRate;
    }

    final overallTaskRate = totalTasksCount > 0 ? (totalCompletedTasks / totalTasksCount) * 100.0 : (totalCompletedTasks > 0 ? 100.0 : 0.0);
    final avgDailyTaskRate = numDays > 0 ? dailyCompletionRatesSum / numDays : 0.0;

    // Previous period tasks for comparison
    int prevCompletedTasks = 0;
    for (int i = 0; i < numDays; i++) {
      final pDay = prevStartDate.add(Duration(days: i));
      for (final t in allTasks) {
        final completedDay = t.completedAt != null ? DateTime(t.completedAt!.year, t.completedAt!.month, t.completedAt!.day) : null;
        if (t.completed && completedDay != null && _isSameDay(completedDay, pDay)) {
          prevCompletedTasks++;
        }
      }
    }
    final taskComparison = PeriodComparison.calculate(totalCompletedTasks, prevCompletedTasks);

    final taskAnalytics = TaskAnalytics(
      completedPerDay: completedPerDay,
      totalPerDay: totalPerDay,
      overallCompletionRate: overallTaskRate,
      averageDailyCompletionRate: avgDailyTaskRate,
      bestDay: bestTaskDay,
      totalCompleted: totalCompletedTasks,
      totalTasks: totalTasksCount,
      completionComparison: taskComparison,
    );

    // 3. Focus Analytics
    final List<AnalyticsPoint<int>> focusMinutesPerDay = [];
    int totalFocusMinutes = 0;
    int totalFocusSessionsCount = 0;
    DateTime? longestFocusDay;
    int maxFocusMinsInADay = -1;

    for (final day in days) {
      int dayMins = 0;
      int daySessions = 0;

      for (final s in allFocus) {
        if (s.completed && _isSameDay(s.startedAt, day)) {
          dayMins += s.duration as int;
          daySessions++;
        }
      }

      focusMinutesPerDay.add(AnalyticsPoint(date: day, value: dayMins));
      totalFocusMinutes += dayMins;
      totalFocusSessionsCount += daySessions;

      if (dayMins > maxFocusMinsInADay && dayMins > 0) {
        maxFocusMinsInADay = dayMins;
        longestFocusDay = day;
      }
    }

    final avgDailyFocusMins = numDays > 0 ? totalFocusMinutes / numDays : 0.0;

    int prevFocusMins = 0;
    for (int i = 0; i < numDays; i++) {
      final pDay = prevStartDate.add(Duration(days: i));
      for (final s in allFocus) {
        if (s.completed && _isSameDay(s.startedAt, pDay)) {
          prevFocusMins += s.duration as int;
        }
      }
    }
    final focusComparison = PeriodComparison.calculate(totalFocusMinutes, prevFocusMins);

    final focusAnalytics = FocusAnalytics(
      minutesPerDay: focusMinutesPerDay,
      totalMinutes: totalFocusMinutes,
      averageDailyMinutes: avgDailyFocusMins,
      longestFocusDay: longestFocusDay,
      totalSessions: totalFocusSessionsCount,
      minutesComparison: focusComparison,
    );

    // 4. Health Analytics
    final List<AnalyticsPoint<int>> stepsPerDay = [];
    final List<AnalyticsPoint<double>> caloriesPerDay = [];
    final List<AnalyticsPoint<int>> sleepPerDay = [];
    final List<AnalyticsPoint<int>> workoutsPerDay = [];

    int totalSteps = 0;
    double totalCalories = 0.0;
    int totalSleepMins = 0;
    int totalWorkoutCount = 0;
    DateTime? highestStepsDay;
    int maxStepsInADay = -1;

    for (final day in days) {
      final stepLog = await _healthRepository.getStepsForDate(day);
      final sleepLog = await _healthRepository.getSleepForDate(day);
      final workoutLogs = await _healthRepository.getWorkoutsForDate(day);

      final steps = stepLog?.count ?? 0;
      final cals = stepLog?.calories ?? 0.0;
      final sleepMins = sleepLog?.durationMinutes ?? 0;
      final workoutCount = workoutLogs.length;

      stepsPerDay.add(AnalyticsPoint(date: day, value: steps));
      caloriesPerDay.add(AnalyticsPoint(date: day, value: cals));
      sleepPerDay.add(AnalyticsPoint(date: day, value: sleepMins));
      workoutsPerDay.add(AnalyticsPoint(date: day, value: workoutCount));

      totalSteps += steps;
      totalCalories += cals;
      totalSleepMins += sleepMins;
      totalWorkoutCount += workoutCount;

      if (steps > maxStepsInADay && steps > 0) {
        maxStepsInADay = steps;
        highestStepsDay = day;
      }
    }

    final avgSteps = numDays > 0 ? totalSteps / numDays : 0.0;
    final avgCalories = numDays > 0 ? totalCalories / numDays : 0.0;
    final avgSleepMins = numDays > 0 ? totalSleepMins / numDays : 0.0;

    int prevStepsTotal = 0;
    for (int i = 0; i < numDays; i++) {
      final pDay = prevStartDate.add(Duration(days: i));
      final pStepLog = await _healthRepository.getStepsForDate(pDay);
      prevStepsTotal += pStepLog?.count ?? 0;
    }
    final prevAvgSteps = numDays > 0 ? prevStepsTotal / numDays : 0.0;
    final healthComparison = PeriodComparison.calculate(avgSteps, prevAvgSteps);

    final healthAnalytics = HealthAnalytics(
      stepsPerDay: stepsPerDay,
      averageSteps: avgSteps,
      highestStepsDay: highestStepsDay,
      caloriesPerDay: caloriesPerDay,
      averageCalories: avgCalories,
      sleepDurationPerDay: sleepPerDay,
      averageSleepMinutes: avgSleepMins,
      workoutsPerDay: workoutsPerDay,
      totalWorkouts: totalWorkoutCount,
      stepsComparison: healthComparison,
    );

    // 5. Habit Analytics
    final List<AnalyticsPoint<int>> dailyHabitCompletions = [];
    int totalHabitCompletionsCount = 0;

    for (final day in days) {
      final completions = await _habitRepository.getCompletionsForDate(day);
      final count = completions.length;
      dailyHabitCompletions.add(AnalyticsPoint(date: day, value: count));
      totalHabitCompletionsCount += count;
    }

    final totalPossibleHabits = allHabits.length * numDays;
    final habitCompletionRate = totalPossibleHabits > 0
        ? (totalHabitCompletionsCount / totalPossibleHabits) * 100.0
        : (totalHabitCompletionsCount > 0 ? 100.0 : 0.0);

    final lastDailyScore = await _scoreRepository.getDailyScore(days.last);
    final currentHabitStreak = (lastDailyScore?.totalScore ?? 0) > 0 ? 1 : 0;
    int bestHabitStreak = currentHabitStreak;
    for (final record in personalRecordList) {
      if (record.recordType == 'longest_streak') {
        bestHabitStreak = max(bestHabitStreak, record.value.toInt());
      }
    }

    final habitAnalytics = HabitAnalytics(
      overallCompletionRate: habitCompletionRate,
      dailyCompletions: dailyHabitCompletions,
      currentStreak: currentHabitStreak,
      bestStreak: bestHabitStreak,
    );

    // 6. Goal Analytics
    int goalsCompleted = 0;
    int goalsRemaining = 0;

    for (final day in days) {
      final goals = await _goalRepository.getGoalsForDate(day);
      for (final g in goals) {
        if (g.completed) {
          goalsCompleted++;
        } else {
          goalsRemaining++;
        }
      }
    }

    final totalGoals = goalsCompleted + goalsRemaining;
    final goalCompletionRate = totalGoals > 0 ? (goalsCompleted / totalGoals) * 100.0 : 0.0;

    final goalAnalytics = GoalAnalytics(
      totalCompleted: goalsCompleted,
      totalRemaining: goalsRemaining,
      completionRate: goalCompletionRate,
    );

    // 7. Strava Analytics
    final List<AnalyticsPoint<int>> stravaActivitiesPerDay = [];
    final List<AnalyticsPoint<int>> stravaWorkoutMinsPerDay = [];
    final List<AnalyticsPoint<double>> stravaDistancePerDay = [];
    final List<AnalyticsPoint<double>> stravaElevationPerDay = [];
    final List<AnalyticsPoint<double>> stravaCaloriesPerDay = [];

    int totalStravaActivities = 0;
    int totalStravaWorkoutMins = 0;
    double totalStravaDistanceKm = 0.0;
    double totalStravaElevationGainMeters = 0.0;
    double totalStravaCalories = 0.0;
    DateTime? longestStravaActivityDay;
    int maxStravaMinsInADay = -1;

    if (_stravaRepository != null) {
      for (final day in days) {
        final startOfDay = DateTime(day.year, day.month, day.day);
        final endOfDay = DateTime(day.year, day.month, day.day, 23, 59, 59, 999);
        final dayActivities = await _stravaRepository!.getActivitiesForDateRange(startOfDay, endOfDay);
        final daySummary = StravaAnalyticsAdapter.aggregateActivities(day, dayActivities);

        stravaActivitiesPerDay.add(AnalyticsPoint(date: day, value: daySummary.activityCount));
        stravaWorkoutMinsPerDay.add(AnalyticsPoint(date: day, value: daySummary.totalDurationMinutes));
        stravaDistancePerDay.add(AnalyticsPoint(date: day, value: daySummary.totalDistanceKm));
        stravaElevationPerDay.add(AnalyticsPoint(date: day, value: daySummary.totalElevationGainMeters));
        stravaCaloriesPerDay.add(AnalyticsPoint(date: day, value: daySummary.totalCalories));

        totalStravaActivities += daySummary.activityCount;
        totalStravaWorkoutMins += daySummary.totalDurationMinutes;
        totalStravaDistanceKm += daySummary.totalDistanceKm;
        totalStravaElevationGainMeters += daySummary.totalElevationGainMeters;
        totalStravaCalories += daySummary.totalCalories;

        if (daySummary.totalDurationMinutes > maxStravaMinsInADay && daySummary.totalDurationMinutes > 0) {
          maxStravaMinsInADay = daySummary.totalDurationMinutes;
          longestStravaActivityDay = day;
        }
      }
    }

    int prevStravaWorkoutMins = 0;
    if (_stravaRepository != null) {
      for (int i = 0; i < numDays; i++) {
        final pDay = prevStartDate.add(Duration(days: i));
        final startOfPDay = DateTime(pDay.year, pDay.month, pDay.day);
        final endOfPDay = DateTime(pDay.year, pDay.month, pDay.day, 23, 59, 59, 999);
        final pActivities = await _stravaRepository!.getActivitiesForDateRange(startOfPDay, endOfPDay);
        final pSummary = StravaAnalyticsAdapter.aggregateActivities(pDay, pActivities);
        prevStravaWorkoutMins += pSummary.totalDurationMinutes;
      }
    }
    final stravaComparison = PeriodComparison.calculate(totalStravaWorkoutMins, prevStravaWorkoutMins);

    final stravaAnalytics = StravaAnalytics(
      activitiesPerDay: stravaActivitiesPerDay,
      totalActivities: totalStravaActivities,
      workoutMinutesPerDay: stravaWorkoutMinsPerDay,
      totalWorkoutMinutes: totalStravaWorkoutMins,
      distancePerDay: stravaDistancePerDay,
      totalDistanceKm: totalStravaDistanceKm,
      elevationPerDay: stravaElevationPerDay,
      totalElevationGainMeters: totalStravaElevationGainMeters,
      caloriesPerDay: stravaCaloriesPerDay,
      totalCalories: totalStravaCalories,
      longestActivityDay: longestStravaActivityDay,
      workoutMinutesComparison: stravaComparison,
    );

    // 8. Personal Records Map
    final Map<String, num> personalRecordsMap = {};
    for (final r in personalRecordList) {
      personalRecordsMap[r.recordType] = r.value;
    }

    return OrbitAnalytics(
      period: period,
      score: scoreAnalytics,
      tasks: taskAnalytics,
      focus: focusAnalytics,
      health: healthAnalytics,
      habits: habitAnalytics,
      goals: goalAnalytics,
      strava: stravaAnalytics,
      personalRecords: personalRecordsMap,
    );
  }


  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
