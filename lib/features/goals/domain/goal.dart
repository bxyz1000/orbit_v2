import 'package:isar_community/isar_community.dart';

part 'goal.g.dart';

@collection
class Goal {
  Id id = Isar.autoIncrement;

  late String title;
  late bool completed;
  late DateTime date;
  late bool isLongTerm;

  Goal();

  Goal.create({
    required this.title,
    required this.date,
    this.completed = false,
    this.isLongTerm = false,
  });
}
