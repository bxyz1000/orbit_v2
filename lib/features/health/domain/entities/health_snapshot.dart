class HealthSnapshot {
  final int steps;
  final double calories;
  final double? totalCalories;
  final double distance; // in meters
  final int activeMinutes;
  final int sleepMinutes;
  final int workoutMinutes;
  final double? avgHeartRate;
  final double? restingHeartRate;
  final DateTime timestamp;

  const HealthSnapshot({
    required this.steps,
    required this.calories,
    this.totalCalories,
    required this.distance,
    required this.activeMinutes,
    required this.sleepMinutes,
    required this.workoutMinutes,
    this.avgHeartRate,
    this.restingHeartRate,
    required this.timestamp,
  });

  factory HealthSnapshot.empty() => HealthSnapshot(
        steps: 0,
        calories: 0,
        totalCalories: null,
        distance: 0,
        activeMinutes: 0,
        sleepMinutes: 0,
        workoutMinutes: 0,
        avgHeartRate: null,
        restingHeartRate: null,
        timestamp: DateTime.now(),
      );

  HealthSnapshot copyWith({
    int? steps,
    double? calories,
    double? totalCalories,
    double? distance,
    int? activeMinutes,
    int? sleepMinutes,
    int? workoutMinutes,
    double? avgHeartRate,
    double? restingHeartRate,
    DateTime? timestamp,
  }) {
    return HealthSnapshot(
      steps: steps ?? this.steps,
      calories: calories ?? this.calories,
      totalCalories: totalCalories ?? this.totalCalories,
      distance: distance ?? this.distance,
      activeMinutes: activeMinutes ?? this.activeMinutes,
      sleepMinutes: sleepMinutes ?? this.sleepMinutes,
      workoutMinutes: workoutMinutes ?? this.workoutMinutes,
      avgHeartRate: avgHeartRate ?? this.avgHeartRate,
      restingHeartRate: restingHeartRate ?? this.restingHeartRate,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
