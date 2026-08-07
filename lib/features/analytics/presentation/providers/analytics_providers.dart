import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/analytics_period.dart';
import '../../domain/orbit_analytics.dart';
import '../../domain/services/i_analytics_service.dart';
import '../../data/services/analytics_service_impl.dart';
import '../../../../shared/providers/repository_providers.dart';
import '../../../score/presentation/providers/score_providers.dart';
import '../../../health/presentation/providers/health_providers.dart';
import '../../../integrations/strava/presentation/providers/strava_providers.dart';

/// Currently selected analytics time period.
class AnalyticsPeriodNotifier extends Notifier<AnalyticsPeriod> {
  @override
  AnalyticsPeriod build() => AnalyticsPeriod.last7Days;

  void setPeriod(AnalyticsPeriod period) => state = period;
}

final analyticsPeriodProvider = NotifierProvider<AnalyticsPeriodNotifier, AnalyticsPeriod>(
  AnalyticsPeriodNotifier.new,
);

/// Provider for [IAnalyticsService].
final analyticsServiceProvider = Provider<IAnalyticsService>((ref) {
  return AnalyticsServiceImpl(
    scoreService: ref.watch(scoreServiceProvider),
    scoreRepository: ref.watch(scoreRepositoryProvider),
    taskRepository: ref.watch(taskRepositoryProvider),
    focusRepository: ref.watch(focusRepositoryProvider),
    healthRepository: ref.watch(healthRepoProvider),
    habitRepository: ref.watch(habitRepositoryProvider),
    goalRepository: ref.watch(goalRepositoryProvider),
    personalRecordRepository: ref.watch(personalRecordRepositoryProvider),
    stravaRepository: ref.watch(stravaRepositoryProvider),
  );
});


/// Reactive provider emitting [OrbitAnalytics] for a specified [AnalyticsPeriod].
/// Automatically updates whenever any underlying Isar repository collection emits a change.
final orbitAnalyticsProvider = FutureProvider.family<OrbitAnalytics, AnalyticsPeriod>((ref, period) async {
  ref.watch(productivityDataChangesProvider);
  final service = ref.watch(analyticsServiceProvider);
  return await service.getAnalytics(period);
});

/// Convenience provider for the currently selected analytics period.
final selectedOrbitAnalyticsProvider = FutureProvider<OrbitAnalytics>((ref) async {
  final period = ref.watch(analyticsPeriodProvider);
  return await ref.watch(orbitAnalyticsProvider(period).future);
});
