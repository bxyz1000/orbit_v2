import 'package:isar_community/isar_community.dart';
import '../domain/task.dart';

class TaskRepository {
  final Isar _isar;

  TaskRepository(this._isar);

  Future<List<Task>> getAllTasks() async {
    return await _isar.tasks.where().findAll();
  }

  Future<void> saveTask(Task task) async {
    await _isar.writeTxn(() async {
      await _isar.tasks.put(task);
    });
  }

  Future<void> saveTasks(List<Task> tasks) async {
    await _isar.writeTxn(() async {
      await _isar.tasks.putAll(tasks);
    });
  }

  Future<void> deleteTask(Id id) async {
    await _isar.writeTxn(() async {
      await _isar.tasks.delete(id);
    });
  }

  Stream<void> watchTasks() => _isar.tasks.watchLazy();
}
