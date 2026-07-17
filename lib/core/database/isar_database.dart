import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/tasks/domain/task.dart';
import '../../features/notes/domain/note.dart';
import '../../features/planner/domain/planner_event.dart';
import '../../features/habits/domain/habit.dart';
import '../../features/habits/domain/habit_completion.dart';
import '../../features/focus/domain/focus_session.dart';
import '../../features/health/domain/health_metrics.dart';
import '../../features/goals/domain/goal.dart';
import '../../features/score/data/models/daily_score_model.dart';
import '../../features/score/data/models/weekly_score_model.dart';
import '../../features/score/data/models/monthly_score_model.dart';
import '../../features/score/data/models/personal_record_model.dart';
import '../../features/score/data/models/achievement_model.dart';
import '../../features/settings/domain/user_preferences.dart';

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
        DailyScoreModelSchema,
        WeeklyScoreModelSchema,
        MonthlyScoreModelSchema,
        PersonalRecordModelSchema,
        AchievementModelSchema,
        UserPreferencesSchema,
      ],
      directory: dir.path,
    );
  }
}
