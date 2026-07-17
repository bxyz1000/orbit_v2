import 'package:isar_community/isar.dart';
import '../../domain/entities/personal_record.dart';
import '../models/personal_record_model.dart';

/// Data layer for managing Personal Records.
class PersonalRecordRepository {
  final Isar _isar;

  PersonalRecordRepository(this._isar);

  /// Retrieves a specific personal record by type.
  Future<PersonalRecord?> getRecord(String type) async {
    final model = await _isar.personalRecordModels.filter().recordTypeEqualTo(type).findFirst();
    return model?.toEntity();
  }

  /// Retrieves all personal records.
  Future<List<PersonalRecord>> getAllRecords() async {
    final models = await _isar.personalRecordModels.where().findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  /// Saves or updates a personal record.
  Future<void> saveRecord(PersonalRecord record) async {
    final model = PersonalRecordModel.fromEntity(record);
    // Note: To support updates, we'd need to find the ID first or handle it in fromEntity if we passed the ID.
    // For simplicity here, we assume record type is unique and we find by type.
    final existing = await _isar.personalRecordModels.filter().recordTypeEqualTo(record.recordType).findFirst();
    if (existing != null) model.id = existing.id;
    
    await _isar.writeTxn(() async {
      await _isar.personalRecordModels.put(model);
    });
  }

  /// Updates a record value if the new value is higher.
  Future<void> updateIfHigher(String type, double newValue, DateTime date) async {
    final existing = await getRecord(type);
    if (existing == null || newValue > existing.value) {
      final updated = PersonalRecord.create(
        recordType: type,
        value: newValue,
        achievedAt: date,
      );
      await saveRecord(updated);
    }
  }

  /// Watches all personal records for changes.
  Stream<void> watchRecords() => _isar.personalRecordModels.watchLazy();
}
