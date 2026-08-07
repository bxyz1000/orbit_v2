import 'package:flutter/material.dart';
import '../../domain/task_analytics.dart';
import '../../../../core/theme/orbit_spacing.dart';
import '../../../../shared/widgets/orbit_group_card.dart';
import '../../../../shared/widgets/orbit_stat_card.dart';
import '../../../../shared/widgets/orbit_section_header.dart';

class TaskAnalyticsSection extends StatelessWidget {
  final TaskAnalytics taskAnalytics;

  const TaskAnalyticsSection({
    super.key,
    required this.taskAnalytics,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrbitSectionHeader(title: "Tasks"),
        OrbitSpacing.gapLg,
        Row(
          children: [
            Expanded(
              child: OrbitStatCard(
                title: 'Completed',
                value: '${taskAnalytics.totalCompleted}',
                icon: Icons.check_circle_outline,
              ),
            ),
            OrbitSpacing.gapMd,
            Expanded(
              child: OrbitStatCard(
                title: 'Completion',
                value: '${(taskAnalytics.overallCompletionRate * 100).round()}%',
                icon: Icons.percent,
              ),
            ),
          ],
        ),
        OrbitSpacing.gapMd,
        OrbitGroupCard(
          padding: const EdgeInsets.all(OrbitSpacing.xl),
          children: [
            const Text(
              'COMPLETION TREND',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
            ),
            OrbitSpacing.gapLg,
            SizedBox(
              height: 120,
              child: _TaskBarChart(analytics: taskAnalytics),
            ),
          ],
        ),
      ],
    );
  }
}

class _TaskBarChart extends StatelessWidget {
  final TaskAnalytics analytics;

  const _TaskBarChart({required this.analytics});

  @override
  Widget build(BuildContext context) {
    if (analytics.totalPerDay.isEmpty) {
      return const Center(child: Text('No data yet', style: TextStyle(fontSize: 12, color: Colors.grey)));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxTotal = analytics.totalPerDay.map((e) => e.value).reduce((a, b) => a > b ? a : b);
        if (maxTotal == 0) return const Center(child: Text('No tasks recorded', style: TextStyle(fontSize: 12, color: Colors.grey)));

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: analytics.totalPerDay.asMap().entries.map((entry) {
            final idx = entry.key;
            final totalPoint = entry.value;
            final completedPoint = analytics.completedPerDay.length > idx 
                ? analytics.completedPerDay[idx] 
                : null;

            final totalHeight = (totalPoint.value / maxTotal) * constraints.maxHeight;
            final completedHeight = completedPoint != null 
                ? (completedPoint.value / maxTotal) * constraints.maxHeight 
                : 0.0;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          height: totalHeight.clamp(4.0, double.infinity),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Container(
                          height: completedHeight.clamp(0.0, double.infinity),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
