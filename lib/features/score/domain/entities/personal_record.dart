class PersonalRecord {
  final String recordType;
  final double value;
  final DateTime achievedAt;
  final DateTime updatedAt;

  PersonalRecord({
    required this.recordType,
    required this.value,
    required this.achievedAt,
    required this.updatedAt,
  });

  static PersonalRecord create({
    required String recordType,
    required double value,
    required DateTime achievedAt,
  }) {
    return PersonalRecord(
      recordType: recordType,
      value: value,
      achievedAt: achievedAt,
      updatedAt: DateTime.now(),
    );
  }
}
