import 'package:flutter/material.dart';
import '../../domain/goal_analytics.dart';
import '../../../../core/theme/orbit_spacing.dart';
import '../../../../shared/widgets/orbit_stat_card.dart';
import '../../../../shared/widgets/orbit_section_header.dart';

class GoalAnalyticsSection extends StatelessWidget {
  final GoalAnalytics goalAnalytics;

  const GoalAnalyticsSection({
    super.key,
    required this.goalAnalytics,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrbitSectionHeader(title: "Goals"),
        OrbitSpacing.gapLg,
        Row(
          children: [
            Expanded(
              child: OrbitStatCard(
                title: 'Achieved',
                value: '${goalAnalytics.totalCompleted}',
                icon: Icons.flag,
              ),
            ),
            OrbitSpacing.gapMd,
            Expanded(
              child: OrbitStatCard(
                title: 'Success Rate',
                value: '${(goalAnalytics.completionRate * 100).round()}%',
                icon: Icons.auto_awesome,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
