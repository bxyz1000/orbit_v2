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

/// Provider for step comparison (% change vs last week).
final stepsComparisonProvider = FutureProvider<double>((ref) async {
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

  if (lastWeekSteps == 0) return 0.0;
  return ((todaySteps - lastWeekSteps) / lastWeekSteps) * 100;
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
