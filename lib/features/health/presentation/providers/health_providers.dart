import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/health_snapshot.dart';
import '../../domain/repositories/i_health_service.dart';
import '../../data/services/health_service_impl.dart';

final healthServiceProvider = Provider<IHealthService>((ref) {
  return HealthServiceImpl();
});

final healthAuthorizationProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(healthServiceProvider);
  return await service.isAuthorized();
});

final todayHealthSnapshotProvider = FutureProvider<HealthSnapshot>((ref) async {
  final isAuthorized = await ref.watch(healthAuthorizationProvider.future);
  if (!isAuthorized) {
    return HealthSnapshot.empty();
  }

  final service = ref.watch(healthServiceProvider);
  return await service.getHealthSnapshot(DateTime.now());
});
