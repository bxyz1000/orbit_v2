import 'package:isar_community/isar.dart';
import '../../domain/entities/integration.dart';

part 'integration_model.g.dart';

@collection
class IntegrationModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String orbitId;

  late String name;
  
  @enumerated
  late IntegrationStatus status;
  
  DateTime? lastSync;
  
  late String metadataJson;

  late bool isSupported;

  IntegrationModel();

  IntegrationModel.fromEntity(Integration integration) {
    id = integration.id.hashCode;
    orbitId = integration.id;
    name = integration.name;
    status = integration.status;
    lastSync = integration.lastSync;
    isSupported = integration.isSupported;
    metadataJson = '{}'; 
  }

  Integration toEntity() {
    return Integration(
      id: orbitId,
      name: name,
      status: status,
      lastSync: lastSync,
      isSupported: isSupported,
      metadata: {},
    );
  }
}
