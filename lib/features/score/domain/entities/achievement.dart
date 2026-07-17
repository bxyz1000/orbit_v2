import 'package:isar_community/isar_community.dart';

part 'achievement.g.dart';

@collection
class Achievement {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String achievementId; // e.g., 'first_task', '7_day_streak'
  
  late String title;
  late String description;
  late String category; // Architect, Warrior, Monk, Operator
  late String tier; // Bronze, Silver, Gold, Orbit Platinum
  
  late bool isUnlocked;
  DateTime? unlockedAt;

  Achievement();

  Achievement.create({
    required this.achievementId,
    required this.title,
    required this.description,
    required this.category,
    required this.tier,
    this.isUnlocked = false,
  });
}
