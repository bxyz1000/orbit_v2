import 'package:flutter/material.dart';
import '../../../app/app_shell.dart';
import '../../tasks/data/task_repository.dart';
import '../../notes/data/note_repository.dart';
import '../../planner/data/planner_repository.dart';
import '../../habits/data/habit_repository.dart';
import '../../focus/data/focus_repository.dart';
import '../../score/score.dart';

class HomePage extends StatelessWidget {
  final TaskRepository taskRepository;
  final NoteRepository noteRepository;
  final PlannerRepository plannerRepository;
  final HabitRepository habitRepository;
  final FocusRepository focusRepository;
  final ScoreService scoreService;

  const HomePage({
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
    return AppShell(
      taskRepository: taskRepository,
      noteRepository: noteRepository,
      plannerRepository: plannerRepository,
      habitRepository: habitRepository,
      focusRepository: focusRepository,
      scoreService: scoreService,
    );
  }
}
