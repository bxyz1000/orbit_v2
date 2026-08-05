import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/integration.dart';
import '../../domain/repositories/i_integration_repository.dart';
import '../../data/repositories/integration_repository_impl.dart';
import '../../../../shared/providers/repository_providers.dart';

final integrationRepositoryProvider = Provider<IIntegrationRepository>((ref) {
  return IntegrationRepositoryImpl(ref.watch(isarProvider));
});

final integrationsStreamProvider = StreamProvider<List<Integration>>((ref) {
  final repo = ref.watch(integrationRepositoryProvider);
  return repo.watchIntegrations();
});

final integrationsListProvider = FutureProvider<List<Integration>>((ref) async {
  final repo = ref.watch(integrationRepositoryProvider);
  return await repo.getAllIntegrations();
});

final integrationByIdProvider = FutureProvider.family<Integration?, String>((ref, id) async {
  final repo = ref.watch(integrationRepositoryProvider);
  return await repo.getIntegrationById(id);
});
