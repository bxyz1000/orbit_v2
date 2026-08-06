import '../../../planner/domain/planner_event.dart';
import '../../../score/domain/entities/daily_score.dart';
import '../../../score/domain/entities/personal_record.dart';

enum TimelineItemType { task, focus, planner, health, goal, habit }

class DashboardTimelineItem {
  final String id;
  final String title;
  final String? subtitle;
  final DateTime timestamp;
  final TimelineItemType type;
  final bool isCompleted;

  const DashboardTimelineItem({
    required this.id,
    required this.title,
    this.subtitle,
    required this.timestamp,
    required this.type,
    this.isCompleted = false,
  });
}

class DashboardTaskSummary {
  final int completed;
  final int remaining;

  const DashboardTaskSummary({
    required this.completed,
    required this.remaining,
  });
}

class DashboardFocusSummary {
  final int minutesCompleted;
  final int minutesTarget;

  const DashboardFocusSummary({
    required this.minutesCompleted,
    required this.minutesTarget,
  });
}

class DashboardHealthSummary {
  final int steps;
  final double calories;
  final int workoutMinutes;
  final int sleepMinutes;

  const DashboardHealthSummary({
    required this.steps,
    required this.calories,
    required this.workoutMinutes,
    required this.sleepMinutes,
  });
}

class DashboardGoalSummary {
  final int completed;
  final int remaining;

  const DashboardGoalSummary({
    required this.completed,
    required this.remaining,
  });
}

class DashboardState {
  final DailyScore orbitScore;
  final DashboardTaskSummary taskSummary;
  final DashboardFocusSummary focusSummary;
  final DashboardHealthSummary healthSummary;
  final List<PlannerEvent> todayEvents;
  final DashboardGoalSummary goalSummary;
  final int currentStreak;
  final int longestStreak;
  final List<DashboardTimelineItem> todayTimeline;
  final DateTime? lastSyncedTime;
  final int beatYesterdayScore;
  final List<PersonalRecord> personalRecords;

  const DashboardState({
    required this.orbitScore,
    required this.taskSummary,
    required this.focusSummary,
    required this.healthSummary,
    required this.todayEvents,
    required this.goalSummary,
    required this.currentStreak,
    required this.longestStreak,
    required this.todayTimeline,
    this.lastSyncedTime,
    required this.beatYesterdayScore,
    required this.personalRecords,
  });

  // Top-level getters for direct access
  int get tasksCompleted => taskSummary.completed;
  int get tasksRemaining => taskSummary.remaining;
  int get focusMinutesCompleted => focusSummary.minutesCompleted;
  int get focusMinutesTarget => focusSummary.minutesTarget;
  int get healthSteps => healthSummary.steps;
  double get healthCalories => healthSummary.calories;
  int get healthWorkoutMinutes => healthSummary.workoutMinutes;
  int get healthSleepMinutes => healthSummary.sleepMinutes;
  int get goalsCompleted => goalSummary.completed;
  int get goalsRemaining => goalSummary.remaining;

  factory DashboardState.empty() {
    final now = DateTime.now();
    return DashboardState(
      orbitScore: DailyScore.create(date: now),
      taskSummary: const DashboardTaskSummary(completed: 0, remaining: 0),
      focusSummary: const DashboardFocusSummary(minutesCompleted: 0, minutesTarget: 120),
      healthSummary: const DashboardHealthSummary(steps: 0, calories: 0.0, workoutMinutes: 0, sleepMinutes: 0),
      todayEvents: const [],
      goalSummary: const DashboardGoalSummary(completed: 0, remaining: 0),
      currentStreak: 0,
      longestStreak: 0,
      todayTimeline: const [],
      lastSyncedTime: null,
      beatYesterdayScore: 0,
      personalRecords: const [],
    );
  }

  DashboardState copyWith({
    DailyScore? orbitScore,
    DashboardTaskSummary? taskSummary,
    DashboardFocusSummary? focusSummary,
    DashboardHealthSummary? healthSummary,
    List<PlannerEvent>? todayEvents,
    DashboardGoalSummary? goalSummary,
    int? currentStreak,
    int? longestStreak,
    List<DashboardTimelineItem>? todayTimeline,
    DateTime? lastSyncedTime,
    int? beatYesterdayScore,
    List<PersonalRecord>? personalRecords,
  }) {
    return DashboardState(
      orbitScore: orbitScore ?? this.orbitScore,
      taskSummary: taskSummary ?? this.taskSummary,
      focusSummary: focusSummary ?? this.focusSummary,
      healthSummary: healthSummary ?? this.healthSummary,
      todayEvents: todayEvents ?? this.todayEvents,
      goalSummary: goalSummary ?? this.goalSummary,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      todayTimeline: todayTimeline ?? this.todayTimeline,
      lastSyncedTime: lastSyncedTime ?? this.lastSyncedTime,
      beatYesterdayScore: beatYesterdayScore ?? this.beatYesterdayScore,
      personalRecords: personalRecords ?? this.personalRecords,
    );
  }
}
