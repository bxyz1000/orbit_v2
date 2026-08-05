import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/health_snapshot.dart';
import '../../domain/repositories/i_health_service.dart';
import '../../data/services/health_service_impl.dart';

import '../../../../features/score/presentation/providers/score_providers.dart';

final healthServiceProvider = Provider<IHealthService>((ref) {
  return HealthServiceImpl();
});

final healthAuthorizationProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(healthServiceProvider);
  debugPrint('HealthProviders: [Authorization] Checking permission status...');
  final result = await service.isAuthorized();
  debugPrint('HealthProviders: [Authorization] Result: $result');
  return result;
});

final todayHealthSnapshotProvider = FutureProvider<HealthSnapshot>((ref) async {
  debugPrint('HealthProviders: [Snapshot] Provider rebuild started');
  
  final isAuthorized = await ref.watch(healthAuthorizationProvider.future);
  if (!isAuthorized) {
    debugPrint('HealthProviders: [Snapshot] Returning empty (Not Authorized)');
    return HealthSnapshot.empty();
  }

  // Watch for Isar changes
  ref.watch(productivityDataChangesProvider);

  // We rely on the sync provider to update Isar.
  // This provider will read the latest from Isar.
  final repo = ref.watch(healthRepositoryProvider);
  
  // We combine the data from different Isar collections for today
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  
  final stepLog = await repo.getStepsForDate(startOfDay);
  final sleepLog = await repo.getSleepForDate(startOfDay);
  final workouts = await repo.getWorkoutsForDate(startOfDay);
  
  final workoutMinutes = workouts.fold<int>(0, (sum, w) => sum + w.durationMinutes);

  final snapshot = HealthSnapshot(
    steps: stepLog?.count ?? 0,
    calories: stepLog?.calories ?? 0,
    distance: stepLog?.distance ?? 0,
    activeMinutes: stepLog?.activeMinutes ?? 0,
    sleepMinutes: sleepLog?.durationMinutes ?? 0,
    workoutMinutes: workoutMinutes,
    timestamp: DateTime.now(),
  );
  
  debugPrint('HealthProviders: [Snapshot] Data from Repository: steps=${snapshot.steps}');
  return snapshot;
});
