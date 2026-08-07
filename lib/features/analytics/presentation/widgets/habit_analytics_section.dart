import 'package:flutter/material.dart';
import '../../domain/habit_analytics.dart';
import '../../../../core/theme/orbit_spacing.dart';
import '../../../../shared/widgets/orbit_group_card.dart';
import '../../../../shared/widgets/orbit_stat_card.dart';
import '../../../../shared/widgets/orbit_section_header.dart';
import '../../../../shared/widgets/orbit_info_tile.dart';

class HabitAnalyticsSection extends StatelessWidget {
  final HabitAnalytics habitAnalytics;

  const HabitAnalyticsSection({
    super.key,
    required this.habitAnalytics,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrbitSectionHeader(title: "Habits"),
        OrbitSpacing.gapLg,
        Row(
          children: [
            Expanded(
              child: OrbitStatCard(
                title: 'Compliance',
                value: '${(habitAnalytics.overallCompletionRate * 100).round()}%',
                icon: Icons.repeat,
              ),
            ),
            OrbitSpacing.gapMd,
            Expanded(
              child: OrbitStatCard(
                title: 'Streak',
                value: '${habitAnalytics.currentStreak}',
                icon: Icons.local_fire_department,
              ),
            ),
          ],
        ),
        OrbitSpacing.gapMd,
        OrbitGroupCard(
          children: [
            OrbitInfoTile(
              icon: Icons.emoji_events_outlined,
              title: 'Best Streak',
              trailing: Text(
                '${habitAnalytics.bestStreak} days',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
