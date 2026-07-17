import 'package:isar_community/isar_community.dart';
import '../domain/goal.dart';

class GoalRepository {
  final Isar _isar;

  GoalRepository(this._isar);

  Future<List<Goal>> getGoalsForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return await _isar.goals
        .filter()
        .dateGreaterThan(startOfDay.subtract(const Duration(seconds: 1)))
        .and()
        .dateLessThan(endOfDay)
        .findAll();
  }

  Future<void> saveGoal(Goal goal) async {
    await _isar.writeTxn(() async {
      await _isar.goals.put(goal);
    });
  }

  Stream<void> watchGoals() => _isar.goals.watchLazy();
}
