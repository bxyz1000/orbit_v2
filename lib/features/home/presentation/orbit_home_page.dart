import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../core/theme/orbit_radius.dart';
import '../../../shared/widgets/orbit_section_header.dart';
import '../../../shared/widgets/orbit_group_card.dart';
import '../../../shared/widgets/orbit_stat_card.dart';
import '../../../shared/widgets/orbit_info_tile.dart';
import '../../score/score.dart';
import '../../tasks/data/task_repository.dart';
import '../../focus/data/focus_repository.dart';
import '../../habits/data/habit_repository.dart';
import '../../planner/data/planner_repository.dart';
import '../../planner/domain/planner_event.dart';
import 'widgets/score_progress_ring.dart';
import 'widgets/weekly_score_chart.dart';
import 'widgets/score_breakdown_bars.dart';
import 'widgets/consistency_heatmap.dart';

class OrbitHomePage extends ConsumerWidget {
  const OrbitHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(currentDailyScoreProvider);
    final yesterdayScoreAsync = ref.watch(yesterdayScoreProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('ORBIT', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2)),
        actions: [
          IconButton(
            icon: const CircleAvatar(radius: 14, child: Icon(Icons.person, size: 18)),
            onPressed: () {},
          ),
        ],
      ),
      body: scoreAsync.when(
        data: (score) => RefreshIndicator(
          onRefresh: () => ref.refresh(currentDailyScoreProvider.future),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(OrbitSpacing.xl),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroSection(context, score, yesterdayScoreAsync.asData?.value),
                OrbitSpacing.gapXxl,
                _buildNextBestAction(context, score, yesterdayScoreAsync.asData?.value),
                OrbitSpacing.gapXxl,
                const OrbitSectionHeader(title: "Today's Mission"),
                OrbitSpacing.gapLg,
                _buildDailyMission(ref),
                OrbitSpacing.gapXxl,
                _buildUpcomingEvent(ref, context),
                OrbitSpacing.gapXxl,
                const OrbitSectionHeader(title: "Current Progress"),
                OrbitSpacing.gapLg,
                _buildProgressGrid(score),
                OrbitSpacing.gapXxl,
                const OrbitSectionHeader(title: "Consistency Heatmap"),
                OrbitSpacing.gapLg,
                const OrbitGroupCard(
                  padding: EdgeInsets.all(OrbitSpacing.lg),
                  children: [ConsistencyHeatmap()],
                ),
                OrbitSpacing.gapXxl,
                const OrbitSectionHeader(title: "Performance Trends"),
                OrbitSpacing.gapLg,
                _buildCharts(ref),
                OrbitSpacing.gapXxl,
                const OrbitSectionHeader(title: "Milestones"),
                OrbitSpacing.gapLg,
                _buildMilestones(ref),
                const SizedBox(height: OrbitSpacing.huge),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, DailyScore score, DailyScore? yesterday) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final diff = yesterday != null ? score.totalScore - yesterday.totalScore : 0;
    final toBeat = yesterday != null ? (yesterday.totalScore + 1) - score.totalScore : 50 - score.totalScore;
    final completionPct = (score.totalScore / 100).clamp(0.0, 1.0);

    return Center(
      child: Column(
        children: [
          ScoreProgressRing(
            score: score.totalScore,
            progress: completionPct,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: score.totalScore),
                  duration: const Duration(seconds: 2),
                  builder: (context, value, child) {
                    return Text(
                      '$value',
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: colorScheme.onSurface,
                        fontSize: 64,
                      ),
                    );
                  },
                ),
                Text(
                  'ORBIT SCORE',
                  style: theme.textTheme.labelMedium?.copyWith(
                    letterSpacing: 1,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          OrbitSpacing.gapLg,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (yesterday != null) ...[
                Icon(
                  diff >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 16,
                  color: diff >= 0 ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  '${diff.abs()} vs yesterday',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: diff >= 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Text(
                toBeat > 0 ? '$toBeat to beat yesterday' : 'Yesterday beaten! 🎉',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNextBestAction(BuildContext context, DailyScore score, DailyScore? yesterday) {
    String recommendation = "One focus session will unlock today's potential.";
    IconData icon = Icons.timer_outlined;
    Color accentColor = Theme.of(context).colorScheme.primary;

    if (score.taskScore == 0) {
      recommendation = "Complete your first task to start your daily climb.";
      icon = Icons.check_circle_outline;
    } else if (yesterday != null && score.totalScore < yesterday.totalScore) {
      final diff = (yesterday.totalScore + 1) - score.totalScore;
      recommendation = "You are only $diff points away from beating yesterday.";
      icon = Icons.auto_awesome;
      accentColor = Colors.orange;
    }

    return OrbitGroupCard(
      padding: const EdgeInsets.all(OrbitSpacing.lg),
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 20),
            ),
            OrbitSpacing.gapLg,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "NEXT BEST ACTION",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: accentColor,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    recommendation,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)),
          ],
        ),
      ],
    );
  }

  Widget _buildDailyMission(WidgetRef ref) {
    // Ideally these would be generated by a MissionService based on real repository data.
    // For now, we will show dynamic titles but static IDs/types.
    return OrbitGroupCard(
      children: [
        OrbitInfoTile(
          icon: Icons.check_circle_outline,
          title: "Complete pending tasks",
          subtitle: "Maintain your momentum",
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: OrbitRadius.brCircular,
            ),
            child: const Text("+20", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 10)),
          ),
        ),
        const Divider(height: 1),
        OrbitInfoTile(
          icon: Icons.timer_outlined,
          title: "Start a focus session",
          subtitle: "Concentration is a superpower",
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: OrbitRadius.brCircular,
            ),
            child: const Text("+20", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 10)),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingEvent(WidgetRef ref, BuildContext context) {
    final plannerAsync = ref.watch(todaySessionsProvider); // Using focus session provider as a proxy for test, should use planner
    // Let's assume we have a planner provider.
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrbitSectionHeader(title: "Upcoming Event"),
        OrbitSpacing.gapLg,
        OrbitGroupCard(
          padding: const EdgeInsets.all(OrbitSpacing.lg),
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("11:00 AM", style: Theme.of(context).textTheme.labelSmall),
                    Text("Flutter Dev", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Starts in", style: Theme.of(context).textTheme.labelSmall),
                    Text("40m", style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.primary,
                    )),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressGrid(DailyScore score) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: OrbitStatCard(title: 'Tasks', value: '${score.taskScore ~/ 10}', icon: Icons.task_alt)),
            const SizedBox(width: OrbitSpacing.md),
            Expanded(child: OrbitStatCard(title: 'Focus', value: '${score.focusScore * 25 ~/ 20}m', icon: Icons.timer)),
          ],
        ),
        const SizedBox(height: OrbitSpacing.md),
        Row(
          children: [
            Expanded(child: OrbitStatCard(title: 'Habits', value: '${score.habitScore ~/ 15}', icon: Icons.repeat)),
            const SizedBox(width: OrbitSpacing.md),
            Expanded(child: OrbitStatCard(title: 'Steps', value: '0', icon: Icons.directions_walk)),
          ],
        ),
      ],
    );
  }

  Widget _buildCharts(WidgetRef ref) {
    return Column(
      children: [
        OrbitGroupCard(
          padding: const EdgeInsets.all(OrbitSpacing.xl),
          children: [
            const Text('WEEKLY PERFORMANCE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
            const SizedBox(height: 16),
            const SizedBox(height: 140, child: WeeklyScoreChart()),
          ],
        ),
        OrbitSpacing.gapLg,
        OrbitGroupCard(
          padding: const EdgeInsets.all(OrbitSpacing.xl),
          children: [
            const Text('SCORE CONTRIBUTION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
            const SizedBox(height: 16),
            Consumer(builder: (context, ref, _) {
              final score = ref.watch(currentDailyScoreProvider).asData?.value;
              if (score == null) return const SizedBox();
              return ScoreBreakdownBars(score: score);
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildMilestones(WidgetRef ref) {
    final achievementsAsync = ref.watch(unlockedAchievementsProvider);
    final recordsAsync = ref.watch(personalRecordsProvider);

    return achievementsAsync.when(
      data: (achievements) => OrbitGroupCard(
        children: [
          if (achievements.isEmpty)
            const OrbitInfoTile(title: "No milestones yet", subtitle: "Complete your first task to start.")
          else
            ...achievements.take(2).map((a) => OrbitInfoTile(
              icon: Icons.stars,
              title: a.title,
              subtitle: a.description,
              trailing: const Icon(Icons.check_circle, color: Colors.green, size: 16),
            )),
        ],
      ),
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
    );
  }
}
