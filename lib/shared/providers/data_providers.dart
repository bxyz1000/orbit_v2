import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'repository_providers.dart';
import '../../features/tasks/domain/task.dart';
import '../../features/habits/domain/habit.dart';
import '../../features/planner/domain/planner_event.dart';
import 'package:orbit_v2/features/score/presentation/providers/score_providers.dart';

final pendingTasksProvider = FutureProvider<List<Task>>((ref) async {
  final repo = ref.watch(taskRepositoryProvider);
  ref.watch(productivityDataChangesProvider);
  final allTasks = await repo.getAllTasks();
  return allTasks.where((t) => !t.completed).toList();
});

final todayEventsProvider = FutureProvider<List<PlannerEvent>>((ref) async {
  final repo = ref.watch(plannerRepositoryProvider);
  ref.watch(productivityDataChangesProvider);
  final allEvents = await repo.getAllEvents();
  final now = DateTime.now();
  return allEvents.where((e) {
    return e.date.year == now.year && 
           e.date.month == now.month && 
           e.date.day == now.day;
  }).toList();
});

final allHabitsProvider = FutureProvider<List<Habit>>((ref) async {
  final repo = ref.watch(habitRepositoryProvider);
  ref.watch(productivityDataChangesProvider);
  return repo.getAllHabits();
});

final completedHabitsTodayCountProvider = FutureProvider<int>((ref) async {
  final repo = ref.watch(habitRepositoryProvider);
  ref.watch(productivityDataChangesProvider);
  final completions = await repo.getCompletionsForDate(DateTime.now());
  return completions.length;
});
