import 'dart:math';
import '../domain/entities/dashboard_state.dart';
import '../domain/services/dashboard_service.dart';
import '../../tasks/data/task_repository.dart';
import '../../focus/data/focus_repository.dart';
import '../../planner/data/planner_repository.dart';
import '../../health/data/health_repository.dart';
import '../../score/data/repositories/score_repository.dart';
import '../../goals/data/goal_repository.dart';
import '../../habits/data/habit_repository.dart';
import '../../score/data/repositories/personal_record_repository.dart';
import '../../score/data/repositories/achievement_repository.dart';
import '../../score/domain/services/score_service.dart';
import '../../score/domain/entities/daily_score.dart';
import '../../score/domain/entities/personal_record.dart';
import '../../planner/domain/planner_event.dart';
import '../../tasks/domain/task.dart';
import '../../focus/domain/focus_session.dart';
import '../../health/domain/health_metrics.dart';
import '../../goals/domain/goal.dart';
import '../../habits/domain/habit_completion.dart';
import '../../integrations/strava/domain/repositories/i_strava_repository.dart';
import '../../integrations/strava/domain/entities/strava_activity.dart';

class DashboardServiceImpl implements DashboardService {
  final TaskRepository _taskRepository;
  final FocusRepository _focusRepository;
  final PlannerRepository _plannerRepository;
  final HealthRepository _healthRepository;
  final ScoreRepository _scoreRepository;
  final GoalRepository _goalRepository;
  final PersonalRecordRepository _personalRecordRepository;
  final HabitRepository? _habitRepository;
  final IStravaRepository? _stravaRepository;

  final ScoreService? _scoreService;

  DashboardServiceImpl({
    required TaskRepository taskRepository,
    required FocusRepository focusRepository,
    required PlannerRepository plannerRepository,
    required HealthRepository healthRepository,
    required ScoreRepository scoreRepository,
    required GoalRepository goalRepository,
    required PersonalRecordRepository personalRecordRepository,
    required AchievementRepository achievementRepository,
    HabitRepository? habitRepository,
    ScoreService? scoreService,
    IStravaRepository? stravaRepository,
  })  : _taskRepository = taskRepository,
        _focusRepository = focusRepository,
        _plannerRepository = plannerRepository,
        _healthRepository = healthRepository,
        _scoreRepository = scoreRepository,
        _goalRepository = goalRepository,
        _personalRecordRepository = personalRecordRepository,
        _habitRepository = habitRepository,
        _scoreService = scoreService,
        _stravaRepository = stravaRepository;


  @override
  Future<DashboardState> getDashboardState([DateTime? date]) async {
    final now = date ?? DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final yesterdayDate = startOfDay.subtract(const Duration(days: 1));

    // Gather data from all repositories in parallel for optimum performance
    final futures = await Future.wait([
      _taskRepository.getAllTasks(),
      _focusRepository.getAllSessions(),
      _plannerRepository.getAllEvents(),
      _healthRepository.getStepsForDate(startOfDay),
      _healthRepository.getSleepForDate(startOfDay),
      _healthRepository.getWorkoutsForDate(startOfDay),
      _scoreRepository.getDailyScore(startOfDay),
      _goalRepository.getGoalsForDate(startOfDay),
      _personalRecordRepository.getAllRecords(),
      _scoreRepository.getDailyScore(yesterdayDate),
      _habitRepository != null ? _habitRepository.getCompletionsForDate(startOfDay) : Future.value(<HabitCompletion>[]),
    ]);

    final allTasks = futures[0] as List<Task>;
    final allFocus = futures[1] as List<FocusSession>;
    final allPlannerEvents = futures[2] as List<PlannerEvent>;
    final stepLog = futures[3] as StepLog?;
    final sleepLog = futures[4] as SleepLog?;
    final workoutLogs = futures[5] as List<WorkoutLog>;
    final dbDailyScore = futures[6] as DailyScore?;
    final goals = futures[7] as List<Goal>;
    final personalRecords = futures[8] as List<PersonalRecord>;
    final yesterdayScore = futures[9] as DailyScore?;
    final habitCompletions = futures[10] as List<HabitCompletion>;

    // Tasks calculation
    int tasksCompleted = 0;
    int tasksRemaining = 0;
    for (final task in allTasks) {
      if (task.completed) {
        if (task.completedAt != null && _isSameDay(task.completedAt!, startOfDay)) {
          tasksCompleted++;
        }
      } else {
        tasksRemaining++;
      }
    }

    // Focus calculation
    int focusMinutesCompleted = 0;
    for (final s in allFocus) {
      if (s.completed && _isSameDay(s.startedAt, startOfDay)) {
        focusMinutesCompleted += s.duration;
      }
    }

    // Strava activities
    final List<StravaActivity> stravaActivities = [];
    if (_stravaRepository != null) {
      final endOfDay = DateTime(startOfDay.year, startOfDay.month, startOfDay.day, 23, 59, 59, 999);
      final list = await _stravaRepository!.getActivitiesForDateRange(startOfDay, endOfDay);
      stravaActivities.addAll(list);
    }

    // Health workout calculation with duplicate detection
    final steps = stepLog?.count ?? 0;
    final calories = stepLog?.calories ?? 0.0;
    final sleepMins = sleepLog?.durationMinutes ?? 0;
    int workoutMins = 0;

    for (final w in workoutLogs) {
      // Check if Health Connect workout overlaps with a Strava activity
      final isDuplicate = stravaActivities.any((sa) =>
          sa.startDate.difference(w.date).abs() <= const Duration(minutes: 15) &&
          (sa.durationMinutes - w.durationMinutes).abs() <= 15);
      if (!isDuplicate) {
        workoutMins += w.durationMinutes;
      }
    }
    for (final sa in stravaActivities) {
      workoutMins += sa.durationMinutes;
    }


    // Planner events calculation
    final List<PlannerEvent> todayEvents = [];
    for (final e in allPlannerEvents) {
      if (_isSameDay(e.date, startOfDay)) {
        todayEvents.add(e);
      }
    }

    // Goals calculation
    int goalsCompleted = 0;
    int goalsRemaining = 0;
    for (final g in goals) {
      if (g.completed) {
        goalsCompleted++;
      } else {
        goalsRemaining++;
      }
    }

    // Orbit Score: Use DB score if finalized; otherwise dynamically calculate live active score
    DailyScore orbitScore;
    if (dbDailyScore != null && dbDailyScore.isFinalized) {
      orbitScore = dbDailyScore;
    } else if (_scoreService != null) {
      orbitScore = await _scoreService.calculateActiveScore(startOfDay);
    } else {
      orbitScore = dbDailyScore ?? DailyScore.create(date: startOfDay);
    }

    // Beat yesterday calculation
    final yesterdayTotal = yesterdayScore?.totalScore ?? 0;
    final beatYesterdayScore = yesterdayScore != null
        ? max(0, (yesterdayTotal + 1) - orbitScore.totalScore)
        : max(0, 50 - orbitScore.totalScore);

    // Streak calculation
    final currentStreak = await _calculateCurrentStreak(startOfDay);
    int longestStreak = 0;
    for (final record in personalRecords) {
      if (record.recordType == 'longest_streak') {
        longestStreak = record.value.toInt();
      }
    }
    if (currentStreak > longestStreak) {
      longestStreak = currentStreak;
    }

    // Today's timeline
    final List<DashboardTimelineItem> todayTimeline = [];
    for (final t in allTasks) {
      if (t.completed && t.completedAt != null && _isSameDay(t.completedAt!, startOfDay)) {
        todayTimeline.add(DashboardTimelineItem(
          id: 'task_${t.id}',
          title: t.title,
          subtitle: 'Task Completed',
          timestamp: t.completedAt!,
          type: TimelineItemType.task,
          isCompleted: true,
        ));
      }
    }

    for (final s in allFocus) {
      if (s.completed && _isSameDay(s.startedAt, startOfDay)) {
        todayTimeline.add(DashboardTimelineItem(
          id: 'focus_${s.id}',
          title: 'Focus Session (${s.duration}m)',
          timestamp: s.startedAt,
          type: TimelineItemType.focus,
          isCompleted: true,
        ));
      }
    }

    for (final e in todayEvents) {
      todayTimeline.add(DashboardTimelineItem(
        id: 'event_${e.id}',
        title: e.title,
        subtitle: e.startTime,
        timestamp: e.date,
        type: TimelineItemType.planner,
        isCompleted: e.isCompleted,
      ));
    }

    for (final c in habitCompletions) {
      todayTimeline.add(DashboardTimelineItem(
        id: 'habit_${c.id}',
        title: 'Habit Completed',
        timestamp: c.date,
        type: TimelineItemType.habit,
        isCompleted: true,
      ));
    }

    for (final w in workoutLogs) {
      todayTimeline.add(DashboardTimelineItem(
        id: 'workout_${w.id}',
        title: w.type ?? 'Workout (${w.durationMinutes}m)',
        subtitle: '${w.durationMinutes} minutes',
        timestamp: w.date,
        type: TimelineItemType.health,
        isCompleted: true,
      ));
    }

    for (final sa in stravaActivities) {
      todayTimeline.add(DashboardTimelineItem(
        id: 'strava_${sa.id}',
        title: '${sa.name} (${sa.type})',
        subtitle: '${sa.durationMinutes}m • ${sa.distanceKm.toStringAsFixed(1)} km',
        timestamp: sa.startDate,
        type: TimelineItemType.health,
        isCompleted: true,
      ));
    }


    todayTimeline.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    final DateTime? lastSyncedTime = stepLog?.date ?? orbitScore.updatedAt;

    return DashboardState(
      orbitScore: orbitScore,
      taskSummary: DashboardTaskSummary(completed: tasksCompleted, remaining: tasksRemaining),
      focusSummary: DashboardFocusSummary(minutesCompleted: focusMinutesCompleted, minutesTarget: 120),
      healthSummary: DashboardHealthSummary(
        steps: steps,
        calories: calories,
        workoutMinutes: workoutMins,
        sleepMinutes: sleepMins,
      ),
      todayEvents: todayEvents,
      goalSummary: DashboardGoalSummary(completed: goalsCompleted, remaining: goalsRemaining),
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      todayTimeline: todayTimeline,
      lastSyncedTime: lastSyncedTime,
      beatYesterdayScore: beatYesterdayScore,
      personalRecords: personalRecords,
    );
  }

  Future<int> _calculateCurrentStreak(DateTime today) async {
    int streak = 0;
    int missedDays = 0;
    DateTime current = today;

    final todayScore = await _scoreRepository.getDailyScore(current);
    if (todayScore != null && todayScore.totalScore >= 50) {
      streak++;
    }

    current = current.subtract(const Duration(days: 1));
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
    return streak;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
