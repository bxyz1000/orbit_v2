import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/health_snapshot.dart';
import '../../domain/repositories/i_health_service.dart';
import '../../data/services/health_service_impl.dart';

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

  final service = ref.watch(healthServiceProvider);
  debugPrint('HealthProviders: [Snapshot] Querying service for snapshot...');
  final snapshot = await service.getHealthSnapshot(DateTime.now());
  
  debugPrint('HealthProviders: [Snapshot] Data received: steps=${snapshot.steps}');
  return snapshot;
});
