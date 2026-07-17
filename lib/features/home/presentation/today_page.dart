import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../core/theme/orbit_radius.dart';
import '../../../shared/widgets/orbit_section_header.dart';
import '../../../shared/widgets/orbit_stat_card.dart';
import '../../../shared/widgets/orbit_action_card.dart';
import '../../../shared/widgets/orbit_group_card.dart';
import '../../../shared/widgets/orbit_info_tile.dart';
import '../../score/score.dart';

class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good Morning ☀️';
    if (hour >= 12 && hour < 17) return 'Good Afternoon 🌤️';
    if (hour >= 17 && hour < 22) return 'Good Evening 🌙';
    return 'Good Night 🌌';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(currentDailyScoreProvider);
    final streakAsync = ref.watch(currentStreakProvider);
    final recordsAsync = ref.watch(personalRecordsProvider);
    final achievementsAsync = ref.watch(unlockedAchievementsProvider);

    // Listen for motivation events and show snackbars
    ref.listen(motivationEventsProvider, (previous, next) {
      if (next.hasValue) {
        final event = next.value!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(event.message),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(OrbitSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, ref, scoreAsync, streakAsync),
              const SizedBox(height: OrbitSpacing.xxl),
              
              scoreAsync.when(
                data: (score) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const OrbitSectionHeader(title: "Today's Focus"),
                    const SizedBox(height: OrbitSpacing.lg),
                    _buildFocusOverview(context, score),
                    const SizedBox(height: OrbitSpacing.xxl),
                    
                    const OrbitSectionHeader(title: "Consistency & Records"),
                    const SizedBox(height: OrbitSpacing.lg),
                    _buildRecordsSection(recordsAsync),
                    const SizedBox(height: OrbitSpacing.xxl),
                    
                    const OrbitSectionHeader(title: "Quick Actions"),
                    const SizedBox(height: OrbitSpacing.lg),
                    _buildQuickActionsGrid(context),
                    const SizedBox(height: OrbitSpacing.xxl),
                    
                    const OrbitSectionHeader(title: "Achievements"),
                    const SizedBox(height: OrbitSpacing.lg),
                    _buildAchievementsSection(achievementsAsync),
                    const SizedBox(height: OrbitSpacing.huge),
                  ],
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error loading score: $e'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, AsyncValue<DailyScore> scoreAsync, AsyncValue<int> streakAsync) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final now = DateTime.now();
    
    final months = const [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final weekdays = const [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    final dateString = '${weekdays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_getGreeting(), style: textTheme.headlineLarge),
            const SizedBox(height: OrbitSpacing.xs),
            Text(dateString, style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6))),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            scoreAsync.when(
              data: (score) => AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: OrbitRadius.brCircular,
                  boxShadow: [
                    BoxShadow(color: colorScheme.primary.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: Text(
                  '${score.totalScore}',
                  style: textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              loading: () => const SizedBox(width: 40, height: 40, child: CircularProgressIndicator(strokeWidth: 2)),
              error: (_, _) => const Icon(Icons.error_outline),
            ),
            const SizedBox(height: OrbitSpacing.sm),
            streakAsync.when(
              data: (streak) => Row(
                children: [
                  Icon(Icons.local_fire_department, color: Colors.orange, size: 20),
                  const SizedBox(width: 4),
                  Text('$streak Day Streak', style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.orange)),
                ],
              ),
              loading: () => const SizedBox(),
              error: (_, _) => const SizedBox(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFocusOverview(BuildContext context, DailyScore score) {
    // Derive minutes from score (v1.1 formula: 25m = 20pts)
    final focusMinutes = (score.focusScore * 25 / 20).round();
    final tasksCompleted = score.taskScore ~/ 10;
    
    return Row(
      children: [
        Expanded(
          child: OrbitStatCard(
            title: 'Focus Time',
            value: focusMinutes >= 60 ? '${focusMinutes ~/ 60}h ${focusMinutes % 60}m' : '${focusMinutes}m',
            icon: Icons.timer,
          ),
        ),
        const SizedBox(width: OrbitSpacing.md),
        Expanded(
          child: OrbitStatCard(
            title: 'Tasks Done',
            value: '$tasksCompleted',
            icon: Icons.check_circle,
          ),
        ),
      ],
    );
  }

  Widget _buildRecordsSection(AsyncValue<List<PersonalRecord>> recordsAsync) {
    return recordsAsync.when(
      data: (records) {
        if (records.isEmpty) return const OrbitGroupCard(children: [OrbitInfoTile(title: 'No records yet', subtitle: 'Keep pushing to set your first PR!')]);
        
        // Find specific records
        final highestScore = records.where((r) => r.recordType == 'highest_daily_score').firstOrNull;
        final longestStreak = records.where((r) => r.recordType == 'longest_streak').firstOrNull;
        
        return OrbitGroupCard(
          children: [
            if (highestScore != null)
              OrbitInfoTile(
                icon: Icons.emoji_events_outlined,
                title: 'Personal Best Score',
                subtitle: '${highestScore.value.toInt()} points',
                trailing: Text(_formatDate(highestScore.achievedAt)),
              ),
            if (longestStreak != null)
              OrbitInfoTile(
                icon: Icons.auto_graph,
                title: 'Longest Streak',
                subtitle: '${longestStreak.value.toInt()} days',
                trailing: Text(_formatDate(longestStreak.achievedAt)),
              ),
          ],
        );
      },
      loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
      error: (_, _) => const Text('Error loading records'),
    );
  }

  Widget _buildAchievementsSection(AsyncValue<List<Achievement>> achievementsAsync) {
    return achievementsAsync.when(
      data: (achievements) {
        if (achievements.isEmpty) return const OrbitGroupCard(children: [OrbitInfoTile(title: 'No achievements unlocked', subtitle: 'Your journey has just begun.')]);
        
        return OrbitGroupCard(
          children: achievements.take(3).map((a) => OrbitInfoTile(
            icon: _getAchievementIcon(a.tier),
            title: a.title,
            subtitle: a.description,
            trailing: const Icon(Icons.check_circle, color: Colors.green, size: 20),
          )).toList(),
        );
      },
      loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
      error: (_, _) => const Text('Error loading achievements'),
    );
  }

  IconData _getAchievementIcon(String tier) {
    switch (tier.toLowerCase()) {
      case 'bronze': return Icons.military_tech_outlined;
      case 'silver': return Icons.military_tech;
      case 'gold': return Icons.workspace_premium;
      case 'orbit platinum': return Icons.stars;
      default: return Icons.emoji_events;
    }
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: OrbitSpacing.md,
          crossAxisSpacing: OrbitSpacing.md,
          childAspectRatio: 1.5,
          children: [
            OrbitActionCard(
              icon: Icons.add_task, 
              title: 'Tasks',
              onTap: () {}, // Handled by Navigation
            ),
            OrbitActionCard(
              icon: Icons.calendar_month, 
              title: 'Planner',
              onTap: () {},
            ),
            OrbitActionCard(
              icon: Icons.repeat, 
              title: 'Habits',
              onTap: () {},
            ),
            OrbitActionCard(
              icon: Icons.timer, 
              title: 'Focus',
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
