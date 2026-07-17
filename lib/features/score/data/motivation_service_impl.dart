import 'dart:async';

import '../domain/entities/achievement.dart';
import '../domain/entities/personal_record.dart';
import '../domain/services/motivation_service.dart';
import '../domain/services/score_service.dart';
import 'repositories/achievement_repository.dart';
import 'repositories/personal_record_repository.dart';
import 'repositories/score_repository.dart';
import '../../tasks/data/task_repository.dart';
import '../../focus/data/focus_repository.dart';
import '../../habits/data/habit_repository.dart';

class MotivationServiceImpl implements MotivationService {
  final ScoreService _scoreService;
  final ScoreRepository _scoreRepository;
  final PersonalRecordRepository _recordRepository;
  final AchievementRepository _achievementRepository;
  final TaskRepository _taskRepository;
  final FocusRepository _focusRepository;
  final HabitRepository _habitRepository;

  final _eventController = StreamController<MotivationEvent>.broadcast();

  MotivationServiceImpl(
    this._scoreService,
    this._scoreRepository,
    this._recordRepository,
    this._achievementRepository,
    this._taskRepository,
    this._focusRepository,
    this._habitRepository,
  );

  @override
  Future<int> calculateCurrentStreak() async {
    // Uses the same logic as ScoreService for consistency
    int streak = 0;
    int missedDays = 0;
    DateTime current = DateTime.now();
    
    // Check today first
    final todayScore = await _scoreRepository.getDailyScore(current);
    if (todayScore != null && todayScore.totalScore >= 50) {
      streak++;
    } else {
      // Missed today doesn't break the streak yet, but doesn't add to it
    }

    current = current.subtract(const Duration(days: 1));
    while (missedDays < 5) {
      final score = await _scoreRepository.getDailyScore(current);
      if (score != null && score.totalScore >= 50) {
        streak++;
        missedDays = 0;
      } else {
        missedDays++;
      }
      current = current.subtract(const Duration(days: 1));
      if (streak > 10000) break;
    }
    return streak;
  }

  @override
  Future<void> checkPersonalRecords(DateTime date) async {
    final score = await _scoreService.calculateActiveScore(date);

    await _recordRepository.updateIfHigher('highest_daily_score', score.totalScore.toDouble(), date);
    
    final tasks = await _taskRepository.getAllTasks();
    final completedToday = tasks.where((t) => t.completed && t.completedAt != null && _isSameDay(t.completedAt!, date)).length;
    await _recordRepository.updateIfHigher('most_tasks', completedToday.toDouble(), date);

    final focusSessions = await _focusRepository.getAllSessions();
    final focusToday = focusSessions.where((s) => s.completed && _isSameDay(s.startedAt, date));
    final focusMins = focusToday.fold<int>(0, (sum, s) => sum + s.duration);
    await _recordRepository.updateIfHigher('longest_focus', focusMins.toDouble(), date);
    
    // Longest streak is updated in finalizeDay usually, but we check it here too
    final streak = await calculateCurrentStreak();
    await _recordRepository.updateIfHigher('longest_streak', streak.toDouble(), date);
  }

  @override
  Future<void> evaluateAchievements() async {
    final tasks = await _taskRepository.getAllTasks();
    final completedCount = tasks.where((t) => t.completed).length;
    
    if (completedCount >= 1) {
      await _unlockAchievement('first_task', 'First Task', 'Completed your very first task!', 'Operator', 'Bronze');
    }
    if (completedCount >= 50) {
      await _unlockAchievement('50_tasks', 'Elite Operator', 'Completed 50 tasks.', 'Operator', 'Gold');
    }

    final streak = await calculateCurrentStreak();
    if (streak >= 7) {
      await _unlockAchievement('7_day_streak', 'Consistent', 'Maintain a 7-day streak.', 'Architect', 'Silver');
    }

    final focusSessions = await _focusRepository.getAllSessions();
    if (focusSessions.length >= 10) {
       await _unlockAchievement('10_focus', 'Monk Mode', 'Completed 10 focus sessions.', 'Monk', 'Silver');
    }
  }

  Future<void> _unlockAchievement(String id, String title, String desc, String cat, String tier) async {
    final existing = await _achievementRepository.getAchievement(id);
    if (existing == null || !existing.isUnlocked) {
      final achievement = existing ?? Achievement.create(
        achievementId: id,
        title: title,
        description: desc,
        category: cat,
        tier: tier,
      );
      achievement.isUnlocked = true;
      achievement.unlockedAt = DateTime.now();
      await _achievementRepository.saveAchievement(achievement);
      
      _eventController.add(MotivationEvent(
        title: 'Achievement Unlocked! 🏆',
        message: '$title: $desc',
        type: 'achievement',
      ));
    }
  }

  @override
  Stream<MotivationEvent> watchMotivationEvents() => _eventController.stream;

  @override
  Future<List<Achievement>> getUnlockedAchievements() async {
    final all = await _achievementRepository.getAllAchievements();
    return all.where((a) => a.isUnlocked).toList();
  }

  @override
  Future<List<PersonalRecord>> getPersonalRecords() async {
    return await _recordRepository.getAllRecords();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
