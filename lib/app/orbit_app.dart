import 'package:flutter/material.dart';
import '../core/theme/orbit_theme.dart';
import '../features/home/presentation/home_page.dart';
import '../features/tasks/data/task_repository.dart';
import '../features/notes/data/note_repository.dart';
import '../features/planner/data/planner_repository.dart';
import '../features/habits/data/habit_repository.dart';
import '../features/focus/data/focus_repository.dart';
import '../features/score/score.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

class OrbitApp extends StatelessWidget {
  final TaskRepository taskRepository;
  final NoteRepository noteRepository;
  final PlannerRepository plannerRepository;
  final HabitRepository habitRepository;
  final FocusRepository focusRepository;
  final ScoreService scoreService;

  const OrbitApp({
    super.key,
    required this.taskRepository,
    required this.noteRepository,
    required this.plannerRepository,
    required this.habitRepository,
    required this.focusRepository,
    required this.scoreService,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) {
        return MaterialApp(
          title: 'Orbit',
          debugShowCheckedModeBanner: false,
          theme: OrbitTheme.light,
          darkTheme: OrbitTheme.dark,
          themeMode: mode,
          home: HomePage(
            taskRepository: taskRepository,
            noteRepository: noteRepository,
            plannerRepository: plannerRepository,
            habitRepository: habitRepository,
            focusRepository: focusRepository,
            scoreService: scoreService,
          ),
        );
      },
    );
  }
}
