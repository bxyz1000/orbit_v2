import 'package:isar_community/isar.dart';
import '../../domain/entities/achievement.dart';
import '../models/achievement_model.dart';

class AchievementRepository {
  final Isar _isar;

  AchievementRepository(this._isar);

  Future<List<Achievement>> getAllAchievements() async {
    final models = await _isar.achievementModels.where().findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  Future<Achievement?> getAchievement(String id) async {
    final model = await _isar.achievementModels.filter().achievementIdEqualTo(id).findFirst();
    return model?.toEntity();
  }

  Future<void> saveAchievement(Achievement achievement) async {
    final model = AchievementModel.fromEntity(achievement);
    final existing = await _isar.achievementModels.filter().achievementIdEqualTo(achievement.achievementId).findFirst();
    if (existing != null) model.id = existing.id;

    await _isar.writeTxn(() async {
      await _isar.achievementModels.put(model);
    });
  }

  Stream<void> watchAchievements() => _isar.achievementModels.watchLazy();
}
