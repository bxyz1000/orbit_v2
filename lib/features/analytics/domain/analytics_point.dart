class AnalyticsPoint<T> {
  final DateTime date;
  final T value;
  final String? label;

  const AnalyticsPoint({
    required this.date,
    required this.value,
    this.label,
  });
}
