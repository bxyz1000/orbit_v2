enum MetricAvailability {
  available,
  notConnected,
  permissionRequired,
  noDataRecorded,
  error,
}

class HealthMetricState {
  final MetricAvailability availability;
  final num? value;
  final String unit;
  final String? details;

  const HealthMetricState({
    required this.availability,
    this.value,
    required this.unit,
    this.details,
  });

  factory HealthMetricState.available(num value, String unit, [String? details]) =>
      HealthMetricState(
        availability: MetricAvailability.available,
        value: value,
        unit: unit,
        details: details,
      );

  factory HealthMetricState.notConnected(String unit) =>
      HealthMetricState(
        availability: MetricAvailability.notConnected,
        unit: unit,
      );

  factory HealthMetricState.permissionRequired(String unit) =>
      HealthMetricState(
        availability: MetricAvailability.permissionRequired,
        unit: unit,
      );

  factory HealthMetricState.noData(String unit) =>
      HealthMetricState(
        availability: MetricAvailability.noDataRecorded,
        unit: unit,
      );

  factory HealthMetricState.error(String unit, [String? message]) =>
      HealthMetricState(
        availability: MetricAvailability.error,
        unit: unit,
        details: message,
      );

  bool get isAvailable => availability == MetricAvailability.available && value != null;

  @override
  String toString() {
    switch (availability) {
      case MetricAvailability.available:
        return '$value $unit${details != null ? " ($details)" : ""}';
      case MetricAvailability.notConnected:
        return 'NOT CONNECTED (Health Connect integration disabled)';
      case MetricAvailability.permissionRequired:
        return 'PERMISSION REQUIRED (Health Connect permission pending)';
      case MetricAvailability.noDataRecorded:
        return 'NO DATA RECORDED TODAY';
      case MetricAvailability.error:
        return 'ERROR (${details ?? "Failed to read metric"})';
    }
  }
}

/// Strongly typed, immutable snapshot of real Orbit user state passed to the AI Coach.
class OrbitAIContext {
  final DateTime timestamp;

  // Profile
  final String userName;
  final String userTagline;

  // Orbit Score State
  final int totalScore;
  final int taskScore;
  final int focusScore;
  final int healthScore;
  final int goalScore;
  final double? score7DayEma;
  final int pointsToBeatYesterday;
  final bool beatYesterdayAchieved;

  // Task & Execution State
  final int tasksCompletedToday;
  final int tasksPendingToday;
  final int overdueTaskCount;
  final List<String> pendingTaskTitles;

  // Habit State
  final int activeHabitsCount;
  final int habitsCompletedToday;
  final List<String> habitSummaries;

  // Focus State
  final int focusMinutesToday;
  final int focusTargetMinutes;

  // Health Metrics
  final bool isHealthConnected;
  final HealthMetricState stepsState;
  final HealthMetricState caloriesState;
  final HealthMetricState totalCaloriesState;
  final HealthMetricState sleepState;
  final HealthMetricState heartRateState;
  final HealthMetricState restingHeartRateState;
  final HealthMetricState activeMinutesState;

  // Strava Metrics
  final bool isStravaConnected;
  final int stravaActivitiesCountToday;
  final String? latestStravaActivitySummary;

  // Goals & Schedule State
  final int activeGoalsCount;
  final int goalsCompletedToday;
  final List<String> upcomingEventsToday;

  // Milestones & Personal Records
  final List<String> personalRecords;

  const OrbitAIContext({
    required this.timestamp,
    required this.userName,
    required this.userTagline,
    required this.totalScore,
    required this.taskScore,
    required this.focusScore,
    required this.healthScore,
    required this.goalScore,
    this.score7DayEma,
    required this.pointsToBeatYesterday,
    required this.beatYesterdayAchieved,
    required this.tasksCompletedToday,
    required this.tasksPendingToday,
    required this.overdueTaskCount,
    this.pendingTaskTitles = const [],
    required this.activeHabitsCount,
    required this.habitsCompletedToday,
    this.habitSummaries = const [],
    required this.focusMinutesToday,
    required this.focusTargetMinutes,
    required this.isHealthConnected,
    required this.stepsState,
    required this.caloriesState,
    required this.totalCaloriesState,
    required this.sleepState,
    required this.heartRateState,
    required this.restingHeartRateState,
    required this.activeMinutesState,
    required this.isStravaConnected,
    required this.stravaActivitiesCountToday,
    this.latestStravaActivitySummary,
    required this.activeGoalsCount,
    required this.goalsCompletedToday,
    this.upcomingEventsToday = const [],
    this.personalRecords = const [],
  });

  /// Serializes the authentic Orbit state into a clean prompt context block.
  String toPromptContext() {
    final buffer = StringBuffer();
    buffer.writeln('=== AUTHENTIC USER ORBIT CONTEXT (${timestamp.toIso8601String()}) ===');
    buffer.writeln('USER: $userName ($userTagline)');
    buffer.writeln('');
    buffer.writeln('ORBIT SCORE: $totalScore / 100');
    buffer.writeln(' - Task Score: $taskScore / 25');
    buffer.writeln(' - Focus Score: $focusScore / 25');
    buffer.writeln(' - Health Score: $healthScore / 25');
    buffer.writeln(' - Goal Score: $goalScore / 25');
    if (score7DayEma != null) {
      buffer.writeln(' - 7-Day EMA Baseline: ${score7DayEma!.toStringAsFixed(1)}');
    }
    buffer.writeln(' - Beat Yesterday Status: ${beatYesterdayAchieved ? "Yesterday Beaten!" : "$pointsToBeatYesterday points remaining to beat yesterday"}');
    buffer.writeln('');
    buffer.writeln('EXECUTION & TASKS:');
    buffer.writeln(' - Completed Today: $tasksCompletedToday');
    buffer.writeln(' - Pending Today: $tasksPendingToday');
    buffer.writeln(' - Overdue Tasks: $overdueTaskCount');
    if (pendingTaskTitles.isNotEmpty) {
      buffer.writeln(' - Top Pending Tasks: ${pendingTaskTitles.take(3).join(", ")}');
    }
    buffer.writeln('');
    buffer.writeln('HABITS:');
    buffer.writeln(' - Completed Today: $habitsCompletedToday / $activeHabitsCount active habits');
    if (habitSummaries.isNotEmpty) {
      buffer.writeln(' - Habit Status: ${habitSummaries.join(", ")}');
    }
    buffer.writeln('');
    buffer.writeln('FOCUS SESSIONS:');
    buffer.writeln(' - Focus Minutes Today: ${focusMinutesToday}m / ${focusTargetMinutes}m target');
    buffer.writeln('');
    buffer.writeln('HEALTH METRICS (HEALTH CONNECT):');
    buffer.writeln(' - Connected: $isHealthConnected');
    buffer.writeln(' - Steps: $stepsState');
    buffer.writeln(' - Active Calories: $caloriesState');
    buffer.writeln(' - Total Energy Burned: $totalCaloriesState');
    buffer.writeln(' - Sleep Duration: $sleepState');
    buffer.writeln(' - Heart Rate: $heartRateState');
    buffer.writeln(' - Resting Heart Rate: $restingHeartRateState');
    buffer.writeln(' - Active Minutes: $activeMinutesState');
    buffer.writeln('');
    buffer.writeln('STRAVA INTEGRATION:');
    buffer.writeln(' - Connected: $isStravaConnected');
    buffer.writeln(' - Activities Today: $stravaActivitiesCountToday');
    if (latestStravaActivitySummary != null) {
      buffer.writeln(' - Latest Activity: $latestStravaActivitySummary');
    }
    buffer.writeln('');
    buffer.writeln('GOALS & SCHEDULE:');
    buffer.writeln(' - Active Goals: $activeGoalsCount (Completed today: $goalsCompletedToday)');
    if (upcomingEventsToday.isNotEmpty) {
      buffer.writeln(' - Upcoming Events: ${upcomingEventsToday.join(", ")}');
    }
    if (personalRecords.isNotEmpty) {
      buffer.writeln('');
      buffer.writeln('MILESTONES & RECORDS:');
      buffer.writeln(' - Records: ${personalRecords.join(", ")}');
    }
    buffer.writeln('========================================================');
    return buffer.toString();
  }
}
