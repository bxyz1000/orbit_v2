import 'package:isar_community/isar.dart';
import '../../domain/entities/integration.dart';

part 'integration_model.g.dart';

@collection
class IntegrationModel {
  late String id; // use string id as Isar id is int, we'll store orbit internal id here

  Id get isarId => id.hashCode;

  late String name;
  
  @enumerated
  late IntegrationStatus status;
  
  DateTime? lastSync;
  
  late String metadataJson; // store as json string

  late bool isSupported;

  IntegrationModel();

  IntegrationModel.fromEntity(Integration integration) {
    id = integration.id;
    name = integration.name;
    status = integration.status;
    lastSync = integration.lastSync;
    isSupported = integration.isSupported;
    // For metadata, we'll just store an empty string or basic json for now 
    // as we don't have a complex mapper yet.
    metadataJson = '{}'; 
  }

  Integration toEntity() {
    return Integration(
      id: id,
      name: name,
      status: status,
      lastSync: lastSync,
      isSupported: isSupported,
      metadata: {}, // Decode json if needed
    );
  }
}
