import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/dashboard_state.dart';
import '../../domain/services/dashboard_service.dart';
import '../../data/dashboard_service_impl.dart';
import '../../../../shared/providers/repository_providers.dart';
import '../../../health/presentation/providers/health_providers.dart';
import '../../../score/presentation/providers/score_providers.dart';

/// Provider for [DashboardService].
final dashboardServiceProvider = Provider<DashboardService>((ref) {
  return DashboardServiceImpl(
    taskRepository: ref.watch(taskRepositoryProvider),
    focusRepository: ref.watch(focusRepositoryProvider),
    plannerRepository: ref.watch(plannerRepositoryProvider),
    healthRepository: ref.watch(healthRepoProvider),
    scoreRepository: ref.watch(scoreRepositoryProvider),
    goalRepository: ref.watch(goalRepositoryProvider),
    personalRecordRepository: ref.watch(personalRecordRepositoryProvider),
    achievementRepository: ref.watch(achievementRepositoryProvider),
    scoreService: ref.watch(scoreServiceProvider),
  );
});

/// Reactive provider for [DashboardState].
/// Automatically recalculates and emits updated dashboard state whenever any underlying Isar database collection changes.
final dashboardProvider = FutureProvider<DashboardState>((ref) async {
  final service = ref.watch(dashboardServiceProvider);
  final healthSyncState = ref.watch(healthSyncNotifierProvider);
  
  // Watch productivity data changes stream to trigger rebuild on any repository update
  ref.watch(productivityDataChangesProvider);

  final state = await service.getDashboardState();
  final updatedState = state.copyWith(
    lastSyncedTime: healthSyncState.lastSyncedAt ?? state.lastSyncedTime,
  );
  debugPrint('[HEALTH] dashboard provider updated: steps=${updatedState.healthSteps}, calories=${updatedState.healthCalories}, lastSyncedAt=${updatedState.lastSyncedTime}');
  return updatedState;
});
