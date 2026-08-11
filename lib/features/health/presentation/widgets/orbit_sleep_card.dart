import 'package:flutter/material.dart';
import '../../../../core/theme/orbit_colors.dart';
import '../../domain/health_metrics.dart';
import '../../domain/entities/health_sample.dart';
import '../providers/health_providers.dart';
import 'orbit_health_chart_painter.dart';
import 'orbit_health_metric_card.dart';

class OrbitSleepCard extends StatelessWidget {
  final int sleepMinutes;
  final List<SleepLog> history;
  final HealthMetricStatus status;
  final VoidCallback? onConnectTap;

  const OrbitSleepCard({
    super.key,
    required this.sleepMinutes,
    this.history = const [],
    this.status = HealthMetricStatus.available,
    this.onConnectTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final String metricStr = sleepMinutes > 0
        ? '${sleepMinutes ~/ 60}h ${sleepMinutes % 60}m'
        : 'No Data';

    final String subtitleStr = sleepMinutes >= 420
        ? 'Restorative sleep target achieved'
        : (sleepMinutes > 0 ? 'Below 7h target' : 'No sleep recorded for this date');

    final trendPoints = history
        .map((s) => HealthTrendPoint(
              timestamp: s.date,
              value: (s.durationMinutes / 60.0),
              label: '${s.date.day}/${s.date.month}',
            ))
        .toList();

    return OrbitHealthMetricCard(
      title: 'Sleep & Recovery',
      metricValue: metricStr,
      subtitle: subtitleStr,
      icon: Icons.nightlight_round,
      iconColor: Colors.indigoAccent,
      status: status,
      onConnectTap: onConnectTap,
      customContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '7-Day Consistency',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              if (history.isNotEmpty)
                Text(
                  'Avg: ${(history.fold<int>(0, (sum, s) => sum + s.durationMinutes) / (history.length * 60)).toStringAsFixed(1)}h/day',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface.withValues(alpha: 0.45),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 60,
            width: double.infinity,
            child: CustomPaint(
              painter: OrbitHealthChartPainter(
                points: trendPoints,
                lineColor: Colors.indigoAccent,
                gradientColor: Colors.indigo,
                showDots: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
