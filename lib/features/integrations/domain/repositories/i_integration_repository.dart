import '../entities/integration.dart';

abstract class IIntegrationRepository {
  Future<List<Integration>> getAllIntegrations();
  Future<Integration?> getIntegrationById(String id);
  Future<void> updateIntegration(Integration integration);
  Stream<List<Integration>> watchIntegrations();
}
