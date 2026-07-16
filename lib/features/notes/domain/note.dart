import 'package:isar_community/isar_community.dart';

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
}
