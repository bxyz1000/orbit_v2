import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/health_repository.dart';
import 'health_providers.dart';
import '../../../score/presentation/providers/score_providers.dart';

/// Provider for last 7 days of step data (Mon-Sun).
final weeklyStepsProvider = FutureProvider<List<DailyStepEntry>>((ref) async {
  final repo = ref.watch(healthRepoProvider);
  ref.watch(productivityDataChangesProvider);

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final List<DailyStepEntry> entries = [];

  // Get the start of the week (Monday)
  final weekday = today.weekday; // 1=Mon, 7=Sun
  final monday = today.subtract(Duration(days: weekday - 1));

  for (int i = 0; i < 7; i++) {
    final date = monday.add(Duration(days: i));
    final stepLog = await repo.getStepsForDate(date);

    entries.add(DailyStepEntry(
      date: date,
      steps: stepLog?.count ?? 0,
      distance: stepLog?.distance ?? 0,
      activeMinutes: stepLog?.activeMinutes ?? 0,
      calories: stepLog?.calories ?? 0,
    ));
  }

  return entries;
});

/// Provider for step comparison (% change vs last week). Returns null if no baseline.
final stepsComparisonProvider = FutureProvider<double?>((ref) async {
  final repo = ref.watch(healthRepoProvider);
  ref.watch(productivityDataChangesProvider);

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  // Today's steps
  final todayLog = await repo.getStepsForDate(today);
  final todaySteps = todayLog?.count ?? 0;

  // Same day last week
  final lastWeekDate = today.subtract(const Duration(days: 7));
  final lastWeekLog = await repo.getStepsForDate(lastWeekDate);
  final lastWeekSteps = lastWeekLog?.count ?? 0;

  if (lastWeekSteps == 0 || todaySteps == 0) return null;
  return ((todaySteps - lastWeekSteps) / lastWeekSteps) * 100;
});

/// Provider for 30 days of monthly step data.
final monthlyStepsProvider = FutureProvider<List<DailyStepEntry>>((ref) async {
  final repo = ref.watch(healthRepoProvider);
  ref.watch(productivityDataChangesProvider);

  final now = DateTime.now();
  final end = DateTime(now.year, now.month, now.day);
  final start = end.subtract(const Duration(days: 29)); // 30 days total

  final logs = await repo.getStepLogsForDateRange(start, end);
  final Map<String, dynamic> logMap = {
    for (var log in logs) '${log.date.year}-${log.date.month}-${log.date.day}': log
  };

  final List<DailyStepEntry> entries = [];
  for (int i = 0; i < 30; i++) {
    final d = start.add(Duration(days: i));
    final key = '${d.year}-${d.month}-${d.day}';
    final log = logMap[key];

    entries.add(DailyStepEntry(
      date: d,
      steps: log?.count ?? 0,
      distance: log?.distance ?? 0,
      activeMinutes: log?.activeMinutes ?? 0,
      calories: log?.calories ?? 0,
    ));
  }

  return entries;
});

/// Simple data class for daily step entry.
class DailyStepEntry {
  final DateTime date;
  final int steps;
  final double distance;
  final int activeMinutes;
  final double calories;

  const DailyStepEntry({
    required this.date,
    required this.steps,
    required this.distance,
    required this.activeMinutes,
    required this.calories,
  });
}
