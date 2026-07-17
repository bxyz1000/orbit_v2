import 'package:isar_community/isar.dart';

part 'task.g.dart';

@collection
class Task {
  Id id = Isar.autoIncrement;
  
  late String title;
  late bool completed;
  late DateTime createdAt;
  DateTime? dueDate;
  DateTime? completedAt;

  Task();

  Task.create({
    required this.title,
    this.completed = false,
    DateTime? createdAt,
    this.dueDate,
    this.completedAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
  }

  Task copyWith({
    Id? id,
    String? title,
    bool? completed,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? completedAt,
  }) {
    final task = Task()
      ..id = id ?? this.id
      ..title = title ?? this.title
      ..completed = completed ?? this.completed
      ..createdAt = createdAt ?? this.createdAt
      ..dueDate = dueDate ?? this.dueDate
      ..completedAt = completedAt ?? this.completedAt;
    return task;
  }
}
