import 'package:isar_community/isar.dart';

part 'health_metrics.g.dart';

@collection
class StepLog {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late DateTime date;

  late int count;

  StepLog();

  StepLog.create({
    required this.date,
    required this.count,
  });
}

@collection
class WorkoutLog {
  Id id = Isar.autoIncrement;

  late DateTime date;
  late int durationMinutes;
  late String? type;

  WorkoutLog();

  WorkoutLog.create({
    required this.date,
    required this.durationMinutes,
    this.type,
  });
}

@collection
class SleepLog {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late DateTime date; // logical date of the sleep session

  late int durationMinutes;

  SleepLog();

  SleepLog.create({
    required this.date,
    required this.durationMinutes,
  });
}
