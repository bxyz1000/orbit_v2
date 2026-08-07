import 'analytics_period.dart';
import 'score_analytics.dart';
import 'task_analytics.dart';
import 'focus_analytics.dart';
import 'health_analytics.dart';
import 'habit_analytics.dart';
import 'goal_analytics.dart';
import 'strava_analytics.dart';

class OrbitAnalytics {
  final AnalyticsPeriod period;
  final ScoreAnalytics score;
  final TaskAnalytics tasks;
  final FocusAnalytics focus;
  final HealthAnalytics health;
  final HabitAnalytics habits;
  final GoalAnalytics goals;
  final StravaAnalytics? strava;
  final Map<String, num> personalRecords;

  const OrbitAnalytics({
    required this.period,
    required this.score,
    required this.tasks,
    required this.focus,
    required this.health,
    required this.habits,
    required this.goals,
    this.strava,
    required this.personalRecords,
  });

  static const empty = OrbitAnalytics(
    period: AnalyticsPeriod.last7Days,
    score: ScoreAnalytics.empty,
    tasks: TaskAnalytics.empty,
    focus: FocusAnalytics.empty,
    health: HealthAnalytics.empty,
    habits: HabitAnalytics.empty,
    goals: GoalAnalytics.empty,
    strava: null,
    personalRecords: {},
  );
}

