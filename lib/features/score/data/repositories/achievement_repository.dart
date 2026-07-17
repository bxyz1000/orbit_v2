import 'package:isar_community/isar_community.dart';
import '../../domain/entities/achievement.dart';

class AchievementRepository {
  final Isar _isar;

  AchievementRepository(this._isar);

  Future<List<Achievement>> getAllAchievements() async {
    return await _isar.achievements.where().findAll();
  }

  Future<Achievement?> getAchievement(String id) async {
    return await _isar.achievements.filter().achievementIdEqualTo(id).findFirst();
  }

  Future<void> saveAchievement(Achievement achievement) async {
    await _isar.writeTxn(() async {
      await _isar.achievements.put(achievement);
    });
  }

  Stream<void> watchAchievements() => _isar.achievements.watchLazy();
}
