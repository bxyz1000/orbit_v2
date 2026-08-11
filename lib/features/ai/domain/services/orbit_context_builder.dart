import 'package:orbit_v2/features/ai/domain/entities/orbit_ai_context.dart';
import 'package:orbit_v2/features/dashboard/domain/entities/dashboard_state.dart';
import 'package:orbit_v2/features/health/domain/entities/health_snapshot.dart';
import 'package:orbit_v2/features/settings/domain/user_preferences.dart';
import 'package:orbit_v2/features/tasks/domain/task.dart';
import 'package:orbit_v2/features/habits/domain/habit.dart';
import 'package:orbit_v2/features/planner/domain/planner_event.dart';

class OrbitContextBuilder {
  static OrbitAIContext buildFromState({
    required DashboardState dashboardState,
    required UserPreferences preferences,
    required bool isHealthAuthorized,
    bool isStravaConnected = false,
    double? score7DayEma,
    HealthSnapshot? healthSnapshot,
    List<Task> pendingTasks = const [],
    List<Habit> habits = const [],
    List<PlannerEvent> todayEvents = const [],
  }) {
    final now = DateTime.now();

    // Build Health Metric States safely with explicit availability distinction
    final HealthMetricState stepsState;
    final HealthMetricState caloriesState;
    final HealthMetricState totalCaloriesState;
    final HealthMetricState sleepState;
    final HealthMetricState heartRateState;
    final HealthMetricState restingHeartRateState;
    final HealthMetricState activeMinutesState;

    if (!isHealthAuthorized) {
      stepsState = HealthMetricState.notConnected('steps');
      caloriesState = HealthMetricState.notConnected('kcal');
      totalCaloriesState = HealthMetricState.notConnected('kcal');
      sleepState = HealthMetricState.notConnected('minutes');
      heartRateState = HealthMetricState.notConnected('BPM');
      restingHeartRateState = HealthMetricState.notConnected('BPM');
      activeMinutesState = HealthMetricState.notConnected('minutes');
    } else if (healthSnapshot == null) {
      stepsState = HealthMetricState.noData('steps');
      caloriesState = HealthMetricState.noData('kcal');
      totalCaloriesState = HealthMetricState.noData('kcal');
      sleepState = HealthMetricState.noData('minutes');
      heartRateState = HealthMetricState.noData('BPM');
      restingHeartRateState = HealthMetricState.noData('BPM');
      activeMinutesState = HealthMetricState.noData('minutes');
    } else {
      stepsState = healthSnapshot.steps > 0
          ? HealthMetricState.available(healthSnapshot.steps, 'steps')
          : HealthMetricState.noData('steps');

      caloriesState = healthSnapshot.calories > 0
          ? HealthMetricState.available(healthSnapshot.calories.round(), 'kcal')
          : HealthMetricState.noData('kcal');

      totalCaloriesState = healthSnapshot.totalCalories != null && healthSnapshot.totalCalories! > 0
          ? HealthMetricState.available(healthSnapshot.totalCalories!.round(), 'kcal')
          : (healthSnapshot.calories > 0 ? HealthMetricState.available(healthSnapshot.calories.round(), 'kcal') : HealthMetricState.noData('kcal'));

      sleepState = healthSnapshot.sleepMinutes > 0
          ? HealthMetricState.available(healthSnapshot.sleepMinutes, 'minutes', '${healthSnapshot.sleepMinutes ~/ 60}h ${healthSnapshot.sleepMinutes % 60}m')
          : HealthMetricState.noData('minutes');

      heartRateState = healthSnapshot.avgHeartRate != null
          ? HealthMetricState.available(healthSnapshot.avgHeartRate!.round(), 'BPM', healthSnapshot.restingHeartRate != null ? 'Resting: ${healthSnapshot.restingHeartRate!.round()} BPM' : null)
          : HealthMetricState.noData('BPM');

      restingHeartRateState = healthSnapshot.restingHeartRate != null
          ? HealthMetricState.available(healthSnapshot.restingHeartRate!.round(), 'BPM')
          : HealthMetricState.noData('BPM');

      activeMinutesState = healthSnapshot.activeMinutes > 0
          ? HealthMetricState.available(healthSnapshot.activeMinutes, 'minutes')
          : HealthMetricState.noData('minutes');
    }

    final habitSummaries = habits.map((h) => '${h.title} (Streak: ${h.currentStreak}d)').toList();
    final pendingTitles = pendingTasks.map((t) => t.title).toList();
    final eventTitles = todayEvents.map((e) => '${e.title} at ${e.startTime}').toList();
    final records = dashboardState.personalRecords.map((r) => '${r.recordType}: ${r.value.toInt()}').toList();

    final healthScoreVal = dashboardState.orbitScore.stepsScore +
        dashboardState.orbitScore.workoutScore +
        dashboardState.orbitScore.sleepScore;

    final overdueCount = pendingTasks.where((t) => t.dueDate != null && t.dueDate!.isBefore(now)).length;
    final completedHabitsCount = habits.where((h) => h.completedToday).length;

    return OrbitAIContext(
      timestamp: now,
      userName: preferences.userName.isNotEmpty ? preferences.userName : 'Orbit User',
      userTagline: preferences.userTagline,
      totalScore: dashboardState.orbitScore.totalScore,
      taskScore: dashboardState.orbitScore.taskScore,
      focusScore: dashboardState.orbitScore.focusScore,
      healthScore: healthScoreVal,
      goalScore: dashboardState.orbitScore.goalScore,
      score7DayEma: score7DayEma,
      pointsToBeatYesterday: dashboardState.beatYesterdayScore,
      beatYesterdayAchieved: dashboardState.beatYesterdayScore <= 0,
      tasksCompletedToday: dashboardState.tasksCompleted,
      tasksPendingToday: dashboardState.tasksRemaining,
      overdueTaskCount: overdueCount,
      pendingTaskTitles: pendingTitles,
      activeHabitsCount: habits.length,
      habitsCompletedToday: completedHabitsCount,
      habitSummaries: habitSummaries,
      focusMinutesToday: dashboardState.focusMinutesCompleted,
      focusTargetMinutes: dashboardState.focusMinutesTarget,
      isHealthConnected: isHealthAuthorized,
      stepsState: stepsState,
      caloriesState: caloriesState,
      totalCaloriesState: totalCaloriesState,
      sleepState: sleepState,
      heartRateState: heartRateState,
      restingHeartRateState: restingHeartRateState,
      activeMinutesState: activeMinutesState,
      isStravaConnected: isStravaConnected,
      stravaActivitiesCountToday: isStravaConnected ? 1 : 0,
      latestStravaActivitySummary: isStravaConnected ? 'Strava Connected' : null,
      activeGoalsCount: dashboardState.goalsRemaining + dashboardState.goalsCompleted,
      goalsCompletedToday: dashboardState.goalsCompleted,
      upcomingEventsToday: eventTitles,
      personalRecords: records,
    );
  }
}
