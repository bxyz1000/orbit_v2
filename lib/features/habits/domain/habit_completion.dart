import 'package:isar_community/isar_community.dart';

part 'habit_completion.g.dart';

@collection
class HabitCompletion {
  Id id = Isar.autoIncrement;

  late int habitId;
  late DateTime date;

  HabitCompletion();

  HabitCompletion.create({
    required this.habitId,
    required this.date,
  });
}
