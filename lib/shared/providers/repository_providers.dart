import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbit_v2/core/database/isar_database.dart';
import 'package:orbit_v2/features/tasks/data/task_repository.dart';
import 'package:orbit_v2/features/notes/data/note_repository.dart';
import 'package:orbit_v2/features/planner/data/planner_repository.dart';
import 'package:orbit_v2/features/habits/data/habit_repository.dart';
import 'package:orbit_v2/features/focus/data/focus_repository.dart';
import 'package:orbit_v2/features/goals/data/goal_repository.dart';
import 'package:orbit_v2/features/score/data/repositories/score_repository.dart';
import 'package:orbit_v2/features/score/data/repositories/personal_record_repository.dart';
import 'package:orbit_v2/features/score/data/repositories/achievement_repository.dart';

final isarProvider = Provider((ref) => IsarDatabase.instance);

final taskRepositoryProvider = Provider((ref) => TaskRepository(ref.watch(isarProvider)));
final noteRepositoryProvider = Provider((ref) => NoteRepository(ref.watch(isarProvider)));
final plannerRepositoryProvider = Provider((ref) => PlannerRepository(ref.watch(isarProvider)));
final habitRepositoryProvider = Provider((ref) => HabitRepository(ref.watch(isarProvider)));
final focusRepositoryProvider = Provider((ref) => FocusRepository(ref.watch(isarProvider)));

final goalRepositoryProvider = Provider((ref) => GoalRepository(ref.watch(isarProvider)));
final scoreRepositoryProvider = Provider((ref) => ScoreRepository(ref.watch(isarProvider)));
final personalRecordRepositoryProvider = Provider((ref) => PersonalRecordRepository(ref.watch(isarProvider)));
final achievementRepositoryProvider = Provider((ref) => AchievementRepository(ref.watch(isarProvider)));
