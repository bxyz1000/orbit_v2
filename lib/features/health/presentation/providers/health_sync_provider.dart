import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'health_providers.dart';

final healthSyncProvider = FutureProvider<void>((ref) async {
  final repo = ref.watch(healthRepoProvider);
  await repo.syncHealthData(DateTime.now());
});
