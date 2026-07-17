import '../entities/personal_record.dart';
import '../entities/achievement.dart';

abstract class MotivationService {
  /// Calculates the current daily streak considering the 5-day grace period.
  Future<int> calculateCurrentStreak();

  /// Checks if any Personal Records were broken on the given date.
  Future<void> checkPersonalRecords(DateTime date);

  /// Automatically unlocks achievements based on the latest performance data.
  Future<void> evaluateAchievements();

  /// Generates motivational events (e.g., Beat Yesterday, Streak Milestone).
  Stream<MotivationEvent> watchMotivationEvents();

  /// Returns all unlocked achievements.
  Future<List<Achievement>> getUnlockedAchievements();

  /// Returns all personal records.
  Future<List<PersonalRecord>> getPersonalRecords();
}

class MotivationEvent {
  final String title;
  final String message;
  final String type; // e.g., 'pr', 'streak', 'achievement'

  MotivationEvent({
    required this.title,
    required this.message,
    required this.type,
  });
}
