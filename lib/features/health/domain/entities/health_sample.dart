class HeartRateSample {
  final DateTime timestamp;
  final double bpm;
  final bool isResting;

  const HeartRateSample({
    required this.timestamp,
    required this.bpm,
    this.isResting = false,
  });
}

class HealthTrendPoint {
  final DateTime timestamp;
  final double value;
  final String? label;

  const HealthTrendPoint({
    required this.timestamp,
    required this.value,
    this.label,
  });
}
