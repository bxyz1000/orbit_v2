import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/providers/repository_providers.dart';

final healthSyncProvider = FutureProvider<void>((ref) async {
  final repo = ref.watch(healthRepositoryProvider);
  await repo.syncHealthData(DateTime.now());
});
