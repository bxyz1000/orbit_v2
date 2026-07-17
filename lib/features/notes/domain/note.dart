import 'package:isar_community/isar.dart';

part 'note.g.dart';

@collection
class Note {
  Id id = Isar.autoIncrement;

  late String title;
  late String content;
  late DateTime createdAt;

  Note();

  Note.create({
    required this.title,
    required this.content,
    required this.createdAt,
  });

  Note copyWith({
    Id? id,
    String? title,
    String? content,
    DateTime? createdAt,
  }) {
    final note = Note()
      ..id = id ?? this.id
      ..title = title ?? this.title
      ..content = content ?? this.content
      ..createdAt = createdAt ?? this.createdAt;
    return note;
  }
}
