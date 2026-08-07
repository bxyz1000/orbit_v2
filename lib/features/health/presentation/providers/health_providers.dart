import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbit_v2/features/health/domain/entities/health_snapshot.dart';
import 'package:orbit_v2/features/health/domain/repositories/i_health_service.dart';
import 'package:orbit_v2/features/health/data/services/health_service_impl.dart';
import 'package:orbit_v2/features/health/data/health_repository.dart';
import 'package:orbit_v2/features/score/presentation/providers/score_providers.dart';
import 'package:orbit_v2/shared/providers/repository_providers.dart';

final healthServiceProvider = Provider<IHealthService>((ref) {
  return HealthServiceImpl();
});

final healthRepoProvider = Provider<HealthRepository>((ref) {
  final isar = ref.watch(isarProvider);
  final service = ref.watch(healthServiceProvider);
  return HealthRepository(isar, service);
});

final healthAuthorizationProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(healthServiceProvider);
  debugPrint('[HEALTH] checking permission status...');
  final result = await service.isAuthorized();
  debugPrint('[HEALTH] hasPermissions result: $result');
  return result;
});

final healthSyncProvider = FutureProvider<void>((ref) async {
  final repo = ref.watch(healthRepoProvider);
  debugPrint('[HEALTH] sync started');
  await repo.syncHealthData(DateTime.now());
  debugPrint('[HEALTH] provider refresh triggered');
});

final todayHealthSnapshotProvider = FutureProvider<HealthSnapshot>((ref) async {
  debugPrint('[HEALTH] snapshot provider rebuild started');
  
  final isAuthorized = await ref.watch(healthAuthorizationProvider.future);
  if (!isAuthorized) {
    debugPrint('[HEALTH] returning empty snapshot (Not Authorized)');
    return HealthSnapshot.empty();
  }

  // Watch for Isar changes to trigger UI update when sync completes
  ref.watch(productivityDataChangesProvider);

  // Read latest from Isar
  final repo = ref.watch(healthRepoProvider);
  
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  
  final stepLog = await repo.getStepsForDate(startOfDay);
  
  if (stepLog == null) {
    debugPrint('[HEALTH] today\'s data missing in Isar, triggering sync...');
    await repo.syncHealthData(now);
  }
  
  final latestStepLog = await repo.getStepsForDate(startOfDay);
  final sleepLog = await repo.getSleepForDate(startOfDay);
  final workouts = await repo.getWorkoutsForDate(startOfDay);
  
  final workoutMinutes = workouts.fold<int>(0, (sum, w) => sum + w.durationMinutes);

  final snapshot = HealthSnapshot(
    steps: latestStepLog?.count ?? 0,
    calories: latestStepLog?.calories ?? 0,
    distance: latestStepLog?.distance ?? 0,
    activeMinutes: latestStepLog?.activeMinutes ?? 0,
    sleepMinutes: sleepLog?.durationMinutes ?? 0,
    workoutMinutes: workoutMinutes,
    timestamp: DateTime.now(),
  );
  
  debugPrint('[HEALTH] snapshot data from repository: steps=${snapshot.steps}');
  return snapshot;
});
