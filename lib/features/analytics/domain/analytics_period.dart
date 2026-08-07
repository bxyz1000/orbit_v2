enum AnalyticsPeriod {
  today,
  last7Days,
  last30Days,
  last90Days,
}

extension AnalyticsPeriodExtension on AnalyticsPeriod {
  int get days {
    switch (this) {
      case AnalyticsPeriod.today:
        return 1;
      case AnalyticsPeriod.last7Days:
        return 7;
      case AnalyticsPeriod.last30Days:
        return 30;
      case AnalyticsPeriod.last90Days:
        return 90;
    }
  }

  DateTime getStartDate([DateTime? referenceDate]) {
    final ref = referenceDate ?? DateTime.now();
    final startOfToday = DateTime(ref.year, ref.month, ref.day);
    if (this == AnalyticsPeriod.today) {
      return startOfToday;
    }
    return startOfToday.subtract(Duration(days: days - 1));
  }

  DateTime getEndDate([DateTime? referenceDate]) {
    final ref = referenceDate ?? DateTime.now();
    return DateTime(ref.year, ref.month, ref.day, 23, 59, 59);
  }
}
