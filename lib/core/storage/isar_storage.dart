import 'package:isar_community/isar_community.dart';
import 'package:path_provider/path_provider.dart';
import 'storage_service.dart';
import '../../features/tasks/domain/task.dart';
import '../../features/notes/domain/note.dart';
import '../../features/planner/domain/planner_event.dart';

class IsarStorage implements StorageService {
  late final Isar _isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [TaskSchema, NoteSchema, PlannerEventSchema],
      directory: dir.path,
    );
  }

  @override
  Future<void> saveTasks(List<Task> tasks) async {
    await _isar.writeTxn(() async {
      await _isar.tasks.putAll(tasks);
    });
  }

  @override
  Future<List<Task>> loadTasks() async {
    return await _isar.tasks.where().findAll();
  }

  @override
  Future<void> deleteTask(dynamic id) async {
    if (id is! int) return;
    await _isar.writeTxn(() async {
      await _isar.tasks.delete(id);
    });
  }

  @override
  Future<void> saveNotes(List<Note> notes) async {
    await _isar.writeTxn(() async {
      await _isar.notes.putAll(notes);
    });
  }

  @override
  Future<List<Note>> loadNotes() async {
    return await _isar.notes.where().findAll();
  }

  @override
  Future<void> deleteNote(dynamic id) async {
    if (id is! int) return;
    await _isar.writeTxn(() async {
      await _isar.notes.delete(id);
    });
  }

  @override
  Future<void> savePlanner(List<PlannerEvent> events) async {
    await _isar.writeTxn(() async {
      await _isar.plannerEvents.putAll(events);
    });
  }

  @override
  Future<List<PlannerEvent>> loadPlanner() async {
    return await _isar.plannerEvents.where().findAll();
  }
}
