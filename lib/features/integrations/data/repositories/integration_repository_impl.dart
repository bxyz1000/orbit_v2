import 'package:isar_community/isar.dart';
import '../../domain/entities/integration.dart';
import '../../domain/repositories/i_integration_repository.dart';
import '../models/integration_model.dart';

class IntegrationRepositoryImpl implements IIntegrationRepository {
  final Isar _isar;

  IntegrationRepositoryImpl(this._isar);

  @override
  Future<List<Integration>> getAllIntegrations() async {
    final models = await _isar.integrationModels.where().findAll();
    if (models.isEmpty) {
      // Seed initial data
      final initialIntegrations = [
        Integration(id: 'health_connect', name: 'Health Connect', status: IntegrationStatus.notConnected),
        Integration(id: 'strava', name: 'Strava', status: IntegrationStatus.notConnected),
        Integration(id: 'apple_health', name: 'Apple Health', status: IntegrationStatus.notConnected, isSupported: false),
        Integration(id: 'garmin', name: 'Garmin', status: IntegrationStatus.notConnected, isSupported: false),
        Integration(id: 'samsung_health', name: 'Samsung Health', status: IntegrationStatus.notConnected, isSupported: false),
        Integration(id: 'fitbit', name: 'Fitbit', status: IntegrationStatus.notConnected, isSupported: false),
        Integration(id: 'google_calendar', name: 'Google Calendar', status: IntegrationStatus.notConnected, isSupported: false),
      ];
      
      await _isar.writeTxn(() async {
        await _isar.integrationModels.putAll(initialIntegrations.map(IntegrationModel.fromEntity).toList());
      });
      
      return initialIntegrations;
    }
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Integration?> getIntegrationById(String id) async {
    final model = await _isar.integrationModels.get(id.hashCode);
    return model?.toEntity();
  }

  @override
  Future<void> updateIntegration(Integration integration) async {
    await _isar.writeTxn(() async {
      await _isar.integrationModels.put(IntegrationModel.fromEntity(integration));
    });
  }

  @override
  Stream<List<Integration>> watchIntegrations() {
    return _isar.integrationModels.where().watch().map(
      (models) => models.map((m) => m.toEntity()).toList(),
    );
  }
}
