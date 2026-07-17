import 'package:flutter/material.dart';
import 'app/orbit_app.dart';
import 'core/database/isar_database.dart';
import 'features/tasks/data/task_repository.dart';
import 'features/notes/data/note_repository.dart';
import 'features/planner/data/planner_repository.dart';
import 'features/habits/data/habit_repository.dart';
import 'features/focus/data/focus_repository.dart';
import 'features/health/data/health_repository.dart';
import 'features/goals/data/goal_repository.dart';
import 'features/score/score.dart';
import 'features/score/data/score_service_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await IsarDatabase.init();
  } catch (e) {
    debugPrint('Isar initialization failed: $e');
  }

  final isar = IsarDatabase.instance;
  final taskRepository = TaskRepository(isar);
  final noteRepository = NoteRepository(isar);
  final plannerRepository = PlannerRepository(isar);
  final habitRepository = HabitRepository(isar);
  final focusRepository = FocusRepository(isar);
  final healthRepository = HealthRepository(isar);
  final goalRepository = GoalRepository(isar);
  final scoreRepository = ScoreRepository(isar);
  final personalRecordRepository = PersonalRecordRepository(isar);

  final scoreService = ScoreServiceImpl(
    scoreRepository,
    personalRecordRepository,
    taskRepository,
    habitRepository,
    focusRepository,
    plannerRepository,
    healthRepository,
    goalRepository,
  );

  runApp(ProviderScope(
    child: OrbitApp(
      taskRepository: taskRepository,
      noteRepository: noteRepository,
      plannerRepository: plannerRepository,
      habitRepository: habitRepository,
      focusRepository: focusRepository,
      scoreService: scoreService,
    ),
  ));
}
