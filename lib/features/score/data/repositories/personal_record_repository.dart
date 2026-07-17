import 'package:isar_community/isar_community.dart';
import '../../domain/entities/personal_record.dart';

/// Data layer for managing Personal Records.
class PersonalRecordRepository {
  final Isar _isar;

  PersonalRecordRepository(this._isar);

  /// Retrieves a specific personal record by type.
  Future<PersonalRecord?> getRecord(String type) async {
    return await _isar.personalRecords.filter().recordTypeEqualTo(type).findFirst();
  }

  /// Retrieves all personal records.
  Future<List<PersonalRecord>> getAllRecords() async {
    return await _isar.personalRecords.where().findAll();
  }

  /// Saves or updates a personal record.
  Future<void> saveRecord(PersonalRecord record) async {
    await _isar.writeTxn(() async {
      await _isar.personalRecords.put(record);
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
      if (existing != null) updated.id = existing.id;
      await saveRecord(updated);
    }
  }

  /// Watches all personal records for changes.
  Stream<void> watchRecords() => _isar.personalRecords.watchLazy();
}
