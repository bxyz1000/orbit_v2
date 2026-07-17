import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../tasks/data/task_repository.dart';
import '../../habits/data/habit_repository.dart';
import '../../focus/data/focus_repository.dart';
import '../../score/score.dart';
import '../domain/productivity_stats.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../core/theme/orbit_radius.dart';
import '../../../shared/widgets/orbit_section_header.dart';
import '../../../shared/widgets/orbit_group_card.dart';
import '../../../shared/widgets/orbit_stat_card.dart';
import '../../../shared/widgets/orbit_info_tile.dart';

class AnalyticsPage extends ConsumerStatefulWidget {
  final TaskRepository taskRepository;
  final HabitRepository habitRepository;
  final FocusRepository focusRepository;

  const AnalyticsPage({
    super.key,
    required this.taskRepository,
    required this.habitRepository,
    required this.focusRepository,
  });

  @override
  ConsumerState<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends ConsumerState<AnalyticsPage> {
  bool _isLoading = true;
  ProductivityStats? _stats;
  List<Achievement> _achievements = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final scoreService = ref.read(scoreServiceProvider);
      final now = DateTime.now();
      
      // Use the Score Engine for the current stats
      final currentDailyScore = await scoreService.calculateActiveScore(now);
      
      final tasks = await widget.taskRepository.getAllTasks();
      final habits = await widget.habitRepository.getAllHabits();
      final sessions = await widget.focusRepository.getAllSessions();
      
      final todayStart = DateTime(now.year, now.month, now.day);
      final weekStart = todayStart.subtract(const Duration(days: 7));

      final tasksToday = tasks.where((t) => _isSameDay(t.createdAt, now)).toList();
      final tasksRemainingToday = tasksToday.length - (currentDailyScore.taskScore ~/ 10);

      final weeklyTasks = tasks.where((t) => t.createdAt.isAfter(weekStart) && t.completed).length;
      final weeklySessions = sessions.where((s) => s.startedAt.isAfter(weekStart)).toList();
      final weeklyFocusMinutes = weeklySessions.fold<int>(0, (sum, s) => sum + s.duration);
      
      final records = await scoreService.getRecords();
      int currentStreak = records.any((r) => r.recordType == 'longest_streak') 
          ? records.firstWhere((r) => r.recordType == 'longest_streak').value.toInt() 
          : 0;

      _stats = ProductivityStats(
        tasksCompletedToday: currentDailyScore.taskScore ~/ 10,
        tasksRemainingToday: tasksRemainingToday,
        habitsCompletedToday: currentDailyScore.habitScore ~/ 15,
        totalHabitsToday: habits.length,
        focusSessionsToday: sessions.where((s) => _isSameDay(s.startedAt, now)).length,
        focusMinutesToday: currentDailyScore.focusScore * 25 ~/ 20,
        weeklyTasksCompleted: weeklyTasks,
        weeklyFocusMinutes: weeklyFocusMinutes,
        weeklyHabitCompletionRate: habits.isEmpty ? 0 : (currentDailyScore.habitScore ~/ 15 / habits.length) * 100,
        currentStreak: currentStreak,
        bestStreak: currentStreak, // Simplified for now
        productivityScore: currentDailyScore.totalScore,
      );

      _achievements = [
        Achievement(
          title: 'First Task',
          isUnlocked: tasks.any((t) => t.completed),
          icon: Icons.check_circle_outline,
        ),
        Achievement(
          title: '7 Day Streak',
          isUnlocked: currentStreak >= 7,
          icon: Icons.local_fire_department,
        ),
        Achievement(
          title: '50 Tasks Completed',
          isUnlocked: tasks.where((t) => t.completed).length >= 50,
          icon: Icons.emoji_events,
        ),
        Achievement(
          title: '10 Focus Sessions',
          isUnlocked: sessions.length >= 10,
          icon: Icons.timer,
        ),
      ];

      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    if (_stats == null || (_stats!.tasksCompletedToday == 0 && _stats!.tasksRemainingToday == 0 && _stats!.totalHabitsToday == 0 && _stats!.focusSessionsToday == 0)) {
      return Scaffold(
        appBar: AppBar(title: const Text('Analytics')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.analytics_outlined, size: 64, color: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
              const SizedBox(height: OrbitSpacing.lg),
              const Text('No analytics available yet.'),
            ],
          ),
        ),
      );
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(OrbitSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildScoreCard(colorScheme, theme),
            const SizedBox(height: OrbitSpacing.xxl),
            const OrbitSectionHeader(title: "Today's Statistics"),
            const SizedBox(height: OrbitSpacing.lg),
            _buildTodayStatsGrid(),
            const SizedBox(height: OrbitSpacing.xxl),
            const OrbitSectionHeader(title: "Weekly Statistics"),
            const SizedBox(height: OrbitSpacing.lg),
            _buildWeeklyStats(colorScheme, theme),
            const SizedBox(height: OrbitSpacing.xxl),
            const OrbitSectionHeader(title: "Achievements"),
            const SizedBox(height: OrbitSpacing.lg),
            _buildAchievements(colorScheme, theme),
            const SizedBox(height: OrbitSpacing.huge),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(ColorScheme colorScheme, ThemeData theme) {
    return OrbitGroupCard(
      padding: const EdgeInsets.all(OrbitSpacing.xl),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Productivity Score', style: theme.textTheme.titleMedium),
                Text('Based on your daily activity', 
                  style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.6))),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(OrbitSpacing.lg),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${_stats!.productivityScore}',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: OrbitSpacing.lg),
        LinearProgressIndicator(
          value: _stats!.productivityScore / 100,
          backgroundColor: colorScheme.primary.withOpacity(0.1),
          borderRadius: OrbitRadius.brCircular,
        ),
      ],
    );
  }

  Widget _buildTodayStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: OrbitStatCard(title: 'Tasks Done', value: '${_stats!.tasksCompletedToday}')),
            const SizedBox(width: OrbitSpacing.md),
            Expanded(child: OrbitStatCard(title: 'Remaining', value: '${_stats!.tasksRemainingToday}')),
          ],
        ),
        const SizedBox(height: OrbitSpacing.md),
        Row(
          children: [
            Expanded(child: OrbitStatCard(title: 'Habits', value: '${_stats!.habitsCompletedToday}/${_stats!.totalHabitsToday}')),
            const SizedBox(width: OrbitSpacing.md),
            Expanded(child: OrbitStatCard(title: 'Focus Time', value: '${_stats!.focusMinutesToday}m')),
          ],
        ),
      ],
    );
  }

  Widget _buildWeeklyStats(ColorScheme colorScheme, ThemeData theme) {
    return OrbitGroupCard(
      children: [
        OrbitInfoTile(
          title: 'Tasks Completed',
          subtitle: '${_stats!.weeklyTasksCompleted} this week',
          trailing: _buildMiniBar(0.7, colorScheme.primary),
        ),
        OrbitInfoTile(
          title: 'Focus Hours',
          subtitle: '${(_stats!.weeklyFocusMinutes / 60).toStringAsFixed(1)} hours',
          trailing: _buildMiniBar(0.5, colorScheme.secondary),
        ),
        OrbitInfoTile(
          title: 'Habit Completion',
          subtitle: '${_stats!.weeklyHabitCompletionRate.toInt()}% consistency',
          trailing: _buildMiniBar(_stats!.weeklyHabitCompletionRate / 100, Colors.green),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(OrbitSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStreakInfo('Current Streak', _stats!.currentStreak, Icons.local_fire_department, Colors.orange),
              _buildStreakInfo('Best Streak', _stats!.bestStreak, Icons.emoji_events, Colors.amber),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMiniBar(double value, Color color) {
    return Container(
      width: 60,
      height: 8,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: OrbitRadius.brCircular,
      ),
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: value.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: OrbitRadius.brCircular,
          ),
        ),
      ),
    );
  }

  Widget _buildStreakInfo(String label, int value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color),
        Text('$value days', style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _buildAchievements(ColorScheme colorScheme, ThemeData theme) {
    return OrbitGroupCard(
      children: _achievements.map((achievement) {
        return OrbitInfoTile(
          title: achievement.title,
          icon: achievement.icon,
          trailing: Icon(
            achievement.isUnlocked ? Icons.check_circle : Icons.lock_outline,
            color: achievement.isUnlocked ? Colors.green : colorScheme.onSurface.withOpacity(0.2),
          ),
          titleStyle: theme.textTheme.bodyMedium?.copyWith(
            color: achievement.isUnlocked ? null : colorScheme.onSurface.withOpacity(0.4),
          ),
        );
      }).toList(),
    );
  }
}

class Achievement {
  final String title;
  final bool isUnlocked;
  final IconData icon;

  Achievement({required this.title, required this.isUnlocked, required this.icon});
}
