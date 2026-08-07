import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/orbit_insight.dart';
import '../../domain/services/i_insight_service.dart';
import '../../data/services/insight_service_impl.dart';
import '../../../../shared/providers/repository_providers.dart';
import '../../../score/presentation/providers/score_providers.dart';
import '../../../health/presentation/providers/health_providers.dart';
import '../../../integrations/strava/presentation/providers/strava_providers.dart';

/// Provider for [IInsightService].
final insightServiceProvider = Provider<IInsightService>((ref) {
  return InsightServiceImpl(
    scoreService: ref.watch(scoreServiceProvider),
    scoreRepository: ref.watch(scoreRepositoryProvider),
    recordRepository: ref.watch(personalRecordRepositoryProvider),
    taskRepository: ref.watch(taskRepositoryProvider),
    habitRepository: ref.watch(habitRepositoryProvider),
    focusRepository: ref.watch(focusRepositoryProvider),
    plannerRepository: ref.watch(plannerRepositoryProvider),
    healthRepository: ref.watch(healthRepoProvider),
    goalRepository: ref.watch(goalRepositoryProvider),
    stravaRepository: ref.watch(stravaRepositoryProvider),
  );
});

/// Reactive provider emitting today's deterministic Orbit insights.
final dailyInsightsProvider = FutureProvider<List<OrbitInsight>>((ref) async {
  final service = ref.watch(insightServiceProvider);
  ref.watch(productivityDataChangesProvider);
  return await service.generateDailyInsights(DateTime.now());
});

/// Reactive provider emitting category growth opportunity insights.
final categoryInsightsProvider = FutureProvider<List<OrbitInsight>>((ref) async {
  final service = ref.watch(insightServiceProvider);
  ref.watch(productivityDataChangesProvider);
  return await service.generateCategoryInsights(DateTime.now());
});
