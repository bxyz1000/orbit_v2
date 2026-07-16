import 'storage_service.dart';
import '../../features/tasks/domain/task.dart';
import '../../features/notes/domain/note.dart';
import '../../features/planner/domain/planner_event.dart';
import 'package:flutter/material.dart';

class InMemoryStorage implements StorageService {
  final List<Task> _tasks = [
    Task()
      ..id = 1
      ..title = 'Finish Orbit MVP'
      ..completed = false,
    Task()
      ..id = 2
      ..title = 'Workout'
      ..completed = true,
    Task()
      ..id = 3
      ..title = 'Study Flutter'
      ..completed = false,
  ];

  final List<Note> _notes = [
    Note()
      ..id = 1
      ..title = 'Project Ideas'
      ..content = '1. Build a personal OS\n2. Create a productivity app\n3. Learn Flutter deeper'
      ..createdAt = DateTime.now().subtract(const Duration(days: 2)),
    Note()
      ..id = 2
      ..title = 'Grocery List'
      ..content = 'Milk, Eggs, Bread, Coffee, Fruits'
      ..createdAt = DateTime.now().subtract(const Duration(hours: 5)),
    Note()
      ..id = 3
      ..title = 'App Feedback'
      ..content = 'The dashboard looks great. Need to add persistence next.'
      ..createdAt = DateTime.now(),
  ];

  final List<PlannerEvent> _plannerEvents = [
    PlannerEvent()
      ..id = 1
      ..time = '09:00 AM'
      ..title = 'Gym'
      ..color = Colors.blue,
    PlannerEvent()
      ..id = 2
      ..time = '11:00 AM'
      ..title = 'Flutter Development'
      ..color = Colors.orange,
    PlannerEvent()
      ..id = 3
      ..time = '03:00 PM'
      ..title = 'Study'
      ..color = Colors.purple,
    PlannerEvent()
      ..id = 4
      ..time = '08:00 PM'
      ..title = 'Family Time'
      ..color = Colors.green,
  ];

  @override
  Future<void> saveTasks(List<Task> tasks) async {
    _tasks.clear();
    _tasks.addAll(tasks);
  }

  @override
  Future<List<Task>> loadTasks() async {
    return List.from(_tasks);
  }

  @override
  Future<void> deleteTask(dynamic id) async {
    _tasks.removeWhere((t) => t.id == id);
  }

  @override
  Future<void> saveNotes(List<Note> notes) async {
    _notes.clear();
    _notes.addAll(notes);
  }

  @override
  Future<List<Note>> loadNotes() async {
    return List.from(_notes);
  }

  @override
  Future<void> deleteNote(dynamic id) async {
    _notes.removeWhere((n) => n.id == id);
  }

  @override
  Future<void> savePlanner(List<PlannerEvent> events) async {
    _plannerEvents.clear();
    _plannerEvents.addAll(events);
  }

  @override
  Future<List<PlannerEvent>> loadPlanner() async {
    return List.from(_plannerEvents);
  }
}
