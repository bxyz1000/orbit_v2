import 'package:flutter/material.dart';
import '../../../../core/theme/orbit_colors.dart';
import '../../domain/health_metrics.dart';
import '../../domain/entities/health_sample.dart';
import '../providers/health_providers.dart';
import 'orbit_health_chart_painter.dart';
import 'orbit_health_metric_card.dart';

class OrbitCaloriesCard extends StatelessWidget {
  final double activeCalories;
  final List<StepLog> history;
  final HealthMetricStatus status;
  final VoidCallback? onConnectTap;

  const OrbitCaloriesCard({
    super.key,
    required this.activeCalories,
    this.history = const [],
    this.status = HealthMetricStatus.available,
    this.onConnectTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final String metricStr = activeCalories > 0
        ? '${activeCalories.round()} kcal'
        : '0 kcal';

    final String subtitleStr = activeCalories > 0
        ? 'Active energy burned today'
        : 'No active energy recorded today';

    final trendPoints = history
        .map((s) => HealthTrendPoint(
              timestamp: s.date,
              value: s.calories,
              label: '${s.date.day}/${s.date.month}',
            ))
        .toList();

    return OrbitHealthMetricCard(
      title: 'Active Calories',
      metricValue: metricStr,
      subtitle: subtitleStr,
      icon: Icons.local_fire_department_rounded,
      iconColor: Colors.deepOrangeAccent,
      status: status,
      onConnectTap: onConnectTap,
      customContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Energy Burned History',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              if (history.isNotEmpty)
                Text(
                  '7-Day Total: ${history.fold<double>(0, (sum, s) => sum + s.calories).round()} kcal',
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
                lineColor: Colors.deepOrangeAccent,
                gradientColor: Colors.deepOrange,
                showDots: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
