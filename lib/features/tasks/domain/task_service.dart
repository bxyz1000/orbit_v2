import 'task.dart';

class TaskService {
  static final TaskService _instance = TaskService._internal();
  factory TaskService() => _instance;
  TaskService._internal();

  final List<Task> tasks = [
    Task(id: '1', title: 'Finish Orbit MVP', completed: false),
    Task(id: '2', title: 'Workout', completed: true),
    Task(id: '3', title: 'Study Flutter', completed: false),
  ];

  int get completedCount => tasks.where((t) => t.completed).length;
  int get remainingCount => tasks.length - completedCount;
  double get completionPercentage => tasks.isEmpty ? 0 : (completedCount / tasks.length);
}
