import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../score/score.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../shared/widgets/orbit_section_header.dart';
import '../../../shared/widgets/orbit_group_card.dart';
import '../../../shared/widgets/orbit_stat_card.dart';
import '../../../shared/widgets/orbit_info_tile.dart';
import 'widgets/monthly_score_chart.dart';

class InsightsPage extends ConsumerWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(currentDailyScoreProvider);
    final streakAsync = ref.watch(currentStreakProvider);
    final recordsAsync = ref.watch(personalRecordsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('INSIGHTS', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2)),
      ),
      body: scoreAsync.when(
        data: (score) => SingleChildScrollView(
          padding: const EdgeInsets.all(OrbitSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOverview(context, streakAsync, recordsAsync),
              OrbitSpacing.gapXxl,
              const OrbitSectionHeader(title: "Monthly Trend"),
              OrbitSpacing.gapLg,
              const OrbitGroupCard(
                padding: EdgeInsets.all(OrbitSpacing.xl),
                children: [
                  Text('DAILY ORBIT SCORES (30D)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
                  SizedBox(height: 24),
                  SizedBox(height: 180, child: MonthlyScoreChart()),
                ],
              ),
              OrbitSpacing.gapXxl,
              const OrbitSectionHeader(title: "Consistency Records"),
              OrbitSpacing.gapLg,
              _buildRecords(recordsAsync),
              OrbitSpacing.gapXxl,
              const OrbitSectionHeader(title: "Unlocked Milestones"),
              OrbitSpacing.gapLg,
              _buildAchievements(ref),
              const SizedBox(height: OrbitSpacing.huge),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildOverview(BuildContext context, AsyncValue<int> streakAsync, AsyncValue<List<PersonalRecord>> recordsAsync) {
    return Row(
      children: [
        Expanded(
          child: streakAsync.when(
            data: (streak) => OrbitStatCard(title: 'Active Streak', value: '$streak Days', icon: Icons.local_fire_department),
            loading: () => const OrbitStatCard(title: 'Streak', value: '...'),
            error: (_, __) => const OrbitStatCard(title: 'Streak', value: 'Err'),
          ),
        ),
        OrbitSpacing.gapMd,
        Expanded(
          child: recordsAsync.when(
            data: (records) {
              final best = records.where((r) => r.recordType == 'highest_daily_score').firstOrNull;
              return OrbitStatCard(title: 'All-Time Best', value: '${best?.value.toInt() ?? 0}', icon: Icons.emoji_events);
            },
            loading: () => const OrbitStatCard(title: 'Best', value: '...'),
            error: (_, __) => const OrbitStatCard(title: 'Best', value: 'Err'),
          ),
        ),
      ],
    );
  }

  Widget _buildRecords(AsyncValue<List<PersonalRecord>> recordsAsync) {
    return recordsAsync.when(
      data: (records) => OrbitGroupCard(
        children: records.map((r) => OrbitInfoTile(
          icon: Icons.check_circle_outline,
          title: r.recordType.replaceAll('_', ' ').toUpperCase(),
          subtitle: 'Value: ${r.value.toInt()}',
          trailing: Text('${r.achievedAt.day}/${r.achievedAt.month}/${r.achievedAt.year}', style: const TextStyle(fontSize: 10)),
        )).toList(),
      ),
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
    );
  }

  Widget _buildAchievements(WidgetRef ref) {
    final achievementsAsync = ref.watch(unlockedAchievementsProvider);
    return achievementsAsync.when(
      data: (achievements) => OrbitGroupCard(
        children: achievements.map((a) => OrbitInfoTile(
          icon: Icons.stars,
          title: a.title,
          subtitle: a.description,
          trailing: const Icon(Icons.check_circle, color: Colors.green, size: 20),
        )).toList(),
      ),
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
    );
  }
}
