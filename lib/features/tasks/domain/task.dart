import 'package:isar_community/isar_community.dart';

part 'task.g.dart';

@collection
class Task {
  Id id = Isar.autoIncrement;
  
  late String title;
  late bool completed;

  Task();

  Task.create({
    required this.title,
    this.completed = false,
  });

  Task copyWith({
    Id? id,
    String? title,
    bool? completed,
  }) {
    final task = Task()
      ..id = id ?? this.id
      ..title = title ?? this.title
      ..completed = completed ?? this.completed;
    return task;
  }
}
