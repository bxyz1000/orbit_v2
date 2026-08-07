import '../../../tasks/domain/task.dart';
import '../../../planner/domain/planner_event.dart';
import '../../../score/domain/entities/daily_score.dart';

/// Domain input model representing all data required by Score Engine V2.
/// Completely decoupled from Isar, Flutter UI, HTTP, or hardware services.
class ScoreInputModel {
  final DateTime date;

  // Task & Execution inputs
  final List<Task> completedTasks;
  final int overdueTaskCount;
  final List<PlannerEvent> completedPlannerEvents;

  // Habit inputs
  final int activeHabitsCount;
  final int completedHabitsCount;

  // Focus inputs
  final int focusMinutes;

  // Health & Vitality inputs
  final int steps;
  final int workoutMinutes;
  final int sleepMinutes;

  // Goal inputs
  final int completedGoalsCount;

  // Integration availability
  final bool isHealthConnected;
  final bool isStravaConnected;

  // Historical Scores (for 7-day EMA and streak calculations)
  final List<DailyScore> historicalDailyScores;

  ScoreInputModel({
    required this.date,
    this.completedTasks = const [],
    this.overdueTaskCount = 0,
    this.completedPlannerEvents = const [],
    this.activeHabitsCount = 0,
    this.completedHabitsCount = 0,
    this.focusMinutes = 0,
    this.steps = 0,
    this.workoutMinutes = 0,
    this.sleepMinutes = 0,
    this.completedGoalsCount = 0,
    this.isHealthConnected = false,
    this.isStravaConnected = false,
    this.historicalDailyScores = const [],
  });
}
