import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/isar_database.dart';
import '../../features/tasks/data/task_repository.dart';
import '../../features/notes/data/note_repository.dart';
import '../../features/planner/data/planner_repository.dart';
import '../../features/habits/data/habit_repository.dart';
import '../../features/focus/data/focus_repository.dart';
import '../../features/health/data/health_repository.dart';
import '../../features/health/data/services/health_service_impl.dart';
import '../../features/goals/data/goal_repository.dart';
import '../../features/score/data/repositories/score_repository.dart';
import '../../features/score/data/repositories/personal_record_repository.dart';
import '../../features/score/data/repositories/achievement_repository.dart';

final isarProvider = Provider((ref) => IsarDatabase.instance);

final taskRepositoryProvider = Provider((ref) => TaskRepository(ref.watch(isarProvider)));
final noteRepositoryProvider = Provider((ref) => NoteRepository(ref.watch(isarProvider)));
final plannerRepositoryProvider = Provider((ref) => PlannerRepository(ref.watch(isarProvider)));
final habitRepositoryProvider = Provider((ref) => HabitRepository(ref.watch(isarProvider)));
final focusRepositoryProvider = Provider((ref) => FocusRepository(ref.watch(isarProvider)));

final healthRepositoryProvider = Provider((ref) {
  final isar = ref.watch(isarProvider);
  final service = HealthServiceImpl(); // Or use a provider
  return HealthRepository(isar, service);
});

final goalRepositoryProvider = Provider((ref) => GoalRepository(ref.watch(isarProvider)));
final scoreRepositoryProvider = Provider((ref) => ScoreRepository(ref.watch(isarProvider)));
final personalRecordRepositoryProvider = Provider((ref) => PersonalRecordRepository(ref.watch(isarProvider)));
final achievementRepositoryProvider = Provider((ref) => AchievementRepository(ref.watch(isarProvider)));
