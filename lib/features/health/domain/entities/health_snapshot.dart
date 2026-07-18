class HealthSnapshot {
  final int steps;
  final double calories;
  final double distance; // in meters
  final int activeMinutes;
  final int sleepMinutes;
  final int workoutMinutes;
  final DateTime timestamp;

  const HealthSnapshot({
    required this.steps,
    required this.calories,
    required this.distance,
    required this.activeMinutes,
    required this.sleepMinutes,
    required this.workoutMinutes,
    required this.timestamp,
  });

  factory HealthSnapshot.empty() => HealthSnapshot(
        steps: 0,
        calories: 0,
        distance: 0,
        activeMinutes: 0,
        sleepMinutes: 0,
        workoutMinutes: 0,
        timestamp: DateTime.now(),
      );

  HealthSnapshot copyWith({
    int? steps,
    double? calories,
    double? distance,
    int? activeMinutes,
    int? sleepMinutes,
    int? workoutMinutes,
    DateTime? timestamp,
  }) {
    return HealthSnapshot(
      steps: steps ?? this.steps,
      calories: calories ?? this.calories,
      distance: distance ?? this.distance,
      activeMinutes: activeMinutes ?? this.activeMinutes,
      sleepMinutes: sleepMinutes ?? this.sleepMinutes,
      workoutMinutes: workoutMinutes ?? this.workoutMinutes,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
