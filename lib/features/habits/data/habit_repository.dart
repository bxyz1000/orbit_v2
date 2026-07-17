import 'package:isar_community/isar_community.dart';
import '../domain/habit.dart';
import '../domain/habit_completion.dart';

class HabitRepository {
  final Isar _isar;

  HabitRepository(this._isar);

  Future<List<Habit>> getAllHabits() async {
    return await _isar.habits.where().findAll();
  }

  Future<void> saveHabit(Habit habit) async {
    await _isar.writeTxn(() async {
      await _isar.habits.put(habit);
    });
  }

  Future<void> deleteHabit(Id id) async {
    await _isar.writeTxn(() async {
      await _isar.habits.delete(id);
    });
  }

  Future<List<HabitCompletion>> getCompletionsForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return await _isar.habitCompletions
        .filter()
        .dateGreaterThan(startOfDay.subtract(const Duration(seconds: 1)))
        .and()
        .dateLessThan(endOfDay)
        .findAll();
  }

  Future<void> saveCompletion(HabitCompletion completion) async {
    await _isar.writeTxn(() async {
      await _isar.habitCompletions.put(completion);
    });
  }

  Stream<void> watchHabits() => _isar.habits.watchLazy();
  Stream<void> watchCompletions() => _isar.habitCompletions.watchLazy();
}
