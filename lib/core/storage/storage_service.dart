import '../../features/tasks/domain/task.dart';
import '../../features/notes/domain/note.dart';
import '../../features/planner/domain/planner_event.dart';

abstract class StorageService {
  Future<void> saveTasks(List<Task> tasks);
  Future<List<Task>> loadTasks();
  Future<void> deleteTask(dynamic id);

  Future<void> saveNotes(List<Note> notes);
  Future<List<Note>> loadNotes();
  Future<void> deleteNote(dynamic id);

  Future<void> savePlanner(List<PlannerEvent> events);
  Future<List<PlannerEvent>> loadPlanner();
}
