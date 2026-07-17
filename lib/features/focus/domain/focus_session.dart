import 'package:isar_community/isar_community.dart';

part 'focus_session.g.dart';

@collection
class FocusSession {
  Id id = Isar.autoIncrement;

  late int duration; // in minutes
  late bool completed;
  late DateTime startedAt;
  DateTime? endedAt;

  FocusSession();

  FocusSession.create({
    required this.duration,
    this.completed = true,
    DateTime? startedAt,
    this.endedAt,
  }) {
    this.startedAt = startedAt ?? DateTime.now();
  }
}
