import 'package:isar_community/isar.dart';
import '../../domain/entities/personal_record.dart';

part 'personal_record_model.g.dart';

@collection
class PersonalRecordModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String recordType;

  late double value;
  late DateTime achievedAt;
  late DateTime updatedAt;

  PersonalRecordModel();

  factory PersonalRecordModel.fromEntity(PersonalRecord record) {
    return PersonalRecordModel()
      ..recordType = record.recordType
      ..value = record.value
      ..achievedAt = record.achievedAt
      ..updatedAt = record.updatedAt;
  }

  PersonalRecord toEntity() {
    return PersonalRecord(
      recordType: recordType,
      value: value,
      achievedAt: achievedAt,
      updatedAt: updatedAt,
    );
  }
}
