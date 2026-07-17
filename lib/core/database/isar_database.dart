import 'package:isar_community/isar_community.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/tasks/domain/task.dart';
import '../../features/notes/domain/note.dart';
import '../../features/planner/domain/planner_event.dart';
import '../../features/habits/domain/habit.dart';
import '../../features/habits/domain/habit_completion.dart';
import '../../features/focus/domain/focus_session.dart';
import '../../features/health/domain/health_metrics.dart';
import '../../features/goals/domain/goal.dart';
import '../../features/score/domain/entities/daily_score.dart';
import '../../features/score/domain/entities/weekly_score.dart';
import '../../features/score/domain/entities/monthly_score.dart';
import '../../features/score/domain/entities/personal_record.dart';
import '../../features/score/domain/entities/achievement.dart';

class IsarDatabase {
  static late final Isar _isar;

  static Isar get instance => _isar;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [
        TaskSchema,
        NoteSchema,
        PlannerEventSchema,
        HabitSchema,
        HabitCompletionSchema,
        FocusSessionSchema,
        StepLogSchema,
        WorkoutLogSchema,
        SleepLogSchema,
        GoalSchema,
        DailyScoreSchema,
        WeeklyScoreSchema,
        MonthlyScoreSchema,
        PersonalRecordSchema,
        AchievementSchema,
      ],
      directory: dir.path,
    );
  }
}
