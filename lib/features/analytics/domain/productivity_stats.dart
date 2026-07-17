class ProductivityStats {
  final int tasksCompletedToday;
  final int tasksRemainingToday;
  final int habitsCompletedToday;
  final int totalHabitsToday;
  final int focusSessionsToday;
  final int focusMinutesToday;
  
  final int weeklyTasksCompleted;
  final int weeklyFocusMinutes;
  final double weeklyHabitCompletionRate;
  
  final int currentStreak;
  final int bestStreak;
  
  final int productivityScore;

  ProductivityStats({
    required this.tasksCompletedToday,
    required this.tasksRemainingToday,
    required this.habitsCompletedToday,
    required this.totalHabitsToday,
    required this.focusSessionsToday,
    required this.focusMinutesToday,
    required this.weeklyTasksCompleted,
    required this.weeklyFocusMinutes,
    required this.weeklyHabitCompletionRate,
    required this.currentStreak,
    required this.bestStreak,
    required this.productivityScore,
  });

  static ProductivityStats empty() {
    return ProductivityStats(
      tasksCompletedToday: 0,
      tasksRemainingToday: 0,
      habitsCompletedToday: 0,
      totalHabitsToday: 0,
      focusSessionsToday: 0,
      focusMinutesToday: 0,
      weeklyTasksCompleted: 0,
      weeklyFocusMinutes: 0,
      weeklyHabitCompletionRate: 0,
      currentStreak: 0,
      bestStreak: 0,
      productivityScore: 0,
    );
  }
}
