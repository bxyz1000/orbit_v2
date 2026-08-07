import 'package:flutter/material.dart';
import '../../domain/health_analytics.dart';
import '../../../../core/theme/orbit_spacing.dart';
import '../../../../shared/widgets/orbit_group_card.dart';
import '../../../../shared/widgets/orbit_stat_card.dart';
import '../../../../shared/widgets/orbit_section_header.dart';

class HealthAnalyticsSection extends StatelessWidget {
  final HealthAnalytics healthAnalytics;

  const HealthAnalyticsSection({
    super.key,
    required this.healthAnalytics,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrbitSectionHeader(title: "Health"),
        OrbitSpacing.gapLg,
        Row(
          children: [
            Expanded(
              child: OrbitStatCard(
                title: 'Avg Steps',
                value: '${healthAnalytics.averageSteps.round()}',
                icon: Icons.directions_walk,
              ),
            ),
            OrbitSpacing.gapMd,
            Expanded(
              child: OrbitStatCard(
                title: 'Avg Sleep',
                value: _formatMinutes(healthAnalytics.averageSleepMinutes.round()),
                icon: Icons.nightlight_round,
              ),
            ),
          ],
        ),
        OrbitSpacing.gapMd,
        OrbitGroupCard(
          padding: const EdgeInsets.all(OrbitSpacing.xl),
          children: [
            const Text(
              'STEPS HISTORY',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
            ),
            OrbitSpacing.gapLg,
            SizedBox(
              height: 120,
              child: _HealthBarChart(
                points: healthAnalytics.stepsPerDay,
                color: Colors.green,
                maxValue: 10000,
              ),
            ),
          ],
        ),
        OrbitSpacing.gapMd,
        OrbitGroupCard(
          padding: const EdgeInsets.all(OrbitSpacing.xl),
          children: [
            const Text(
              'SLEEP HISTORY',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
            ),
            OrbitSpacing.gapLg,
            SizedBox(
              height: 120,
              child: _HealthBarChart(
                points: healthAnalytics.sleepDurationPerDay,
                color: Colors.indigo,
                maxValue: 480, // 8 hours
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatMinutes(int minutes) {
    if (minutes == 0) return '0m';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h == 0) return '${m}m';
    return '${h}h ${m}m';
  }
}

class _HealthBarChart extends StatelessWidget {
  final List<dynamic> points;
  final Color color;
  final double maxValue;

  const _HealthBarChart({
    required this.points,
    required this.color,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const Center(child: Text('No data yet', style: TextStyle(fontSize: 12, color: Colors.grey)));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final dataMax = points.map((e) => (e.value as num).toDouble()).reduce((a, b) => a > b ? a : b);
        final effectiveMax = dataMax > maxValue ? dataMax * 1.1 : maxValue;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: points.map((point) {
            final val = (point.value as num).toDouble();
            final height = (val / effectiveMax) * constraints.maxHeight;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  height: height.clamp(4.0, double.infinity),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: val >= maxValue ? 1.0 : 0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
