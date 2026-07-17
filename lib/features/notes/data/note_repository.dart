import 'package:isar_community/isar_community.dart';
import '../domain/note.dart';

class NoteRepository {
  final Isar _isar;

  NoteRepository(this._isar);

  Future<List<Note>> getAllNotes() async {
    return await _isar.notes.where().findAll();
  }

  Future<void> saveNote(Note note) async {
    await _isar.writeTxn(() async {
      await _isar.notes.put(note);
    });
  }

  Future<void> saveNotes(List<Note> notes) async {
    await _isar.writeTxn(() async {
      await _isar.notes.putAll(notes);
    });
  }

  Future<void> deleteNote(Id id) async {
    await _isar.writeTxn(() async {
      await _isar.notes.delete(id);
    });
  }
}
