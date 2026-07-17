import 'package:isar_community/isar.dart';
import '../../domain/entities/achievement.dart';

part 'achievement_model.g.dart';

@collection
class AchievementModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String achievementId;
  
  late String title;
  late String description;
  late String category;
  late String tier;
  
  late bool isUnlocked;
  DateTime? unlockedAt;

  AchievementModel();

  factory AchievementModel.fromEntity(Achievement achievement) {
    return AchievementModel()
      ..achievementId = achievement.achievementId
      ..title = achievement.title
      ..description = achievement.description
      ..category = achievement.category
      ..tier = achievement.tier
      ..isUnlocked = achievement.isUnlocked
      ..unlockedAt = achievement.unlockedAt;
  }

  Achievement toEntity() {
    return Achievement(
      achievementId: achievementId,
      title: title,
      description: description,
      category: category,
      tier: tier,
      isUnlocked: isUnlocked,
      unlockedAt: unlockedAt,
    );
  }
}
