enum TrendDirection {
  up,
  down,
  neutral,
}

class PeriodComparison<T extends num> {
  final T currentValue;
  final T previousValue;
  final T difference;
  final double percentageChange;
  final TrendDirection trend;

  const PeriodComparison({
    required this.currentValue,
    required this.previousValue,
    required this.difference,
    required this.percentageChange,
    required this.trend,
  });

  static PeriodComparison<num> calculate(num current, num previous) {
    final diff = current - previous;
    double pct = 0.0;
    if (previous != 0) {
      pct = (diff / previous.abs()) * 100.0;
    } else if (current > 0) {
      pct = 100.0;
    } else if (current < 0) {
      pct = -100.0;
    }

    TrendDirection trendDir;
    if (diff > 0) {
      trendDir = TrendDirection.up;
    } else if (diff < 0) {
      trendDir = TrendDirection.down;
    } else {
      trendDir = TrendDirection.neutral;
    }

    return PeriodComparison<num>(
      currentValue: current,
      previousValue: previous,
      difference: diff,
      percentageChange: pct,
      trend: trendDir,
    );
  }
}
