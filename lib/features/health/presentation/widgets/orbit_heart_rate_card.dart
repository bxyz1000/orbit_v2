import 'package:flutter/material.dart';
import '../../../../core/theme/orbit_colors.dart';
import '../../domain/entities/health_sample.dart';
import '../providers/health_providers.dart';
import 'orbit_health_chart_painter.dart';
import 'orbit_health_metric_card.dart';

class OrbitHeartRateCard extends StatelessWidget {
  final double? avgHeartRate;
  final double? restingHeartRate;
  final List<HeartRateSample> samples;
  final HealthMetricStatus status;
  final VoidCallback? onConnectTap;

  const OrbitHeartRateCard({
    super.key,
    this.avgHeartRate,
    this.restingHeartRate,
    this.samples = const [],
    this.status = HealthMetricStatus.available,
    this.onConnectTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final String metricStr = avgHeartRate != null ? '${avgHeartRate!.round()} bpm' : 'No Data';
    final String subtitleStr = restingHeartRate != null
        ? 'Resting: ${restingHeartRate!.round()} bpm'
        : (samples.isNotEmpty ? '${samples.length} readings today' : 'No heart rate data recorded today');

    final trendPoints = samples
        .map((s) => HealthTrendPoint(timestamp: s.timestamp, value: s.bpm))
        .toList();

    return OrbitHealthMetricCard(
      title: 'Heart Rate',
      metricValue: metricStr,
      subtitle: subtitleStr,
      icon: Icons.favorite_rounded,
      iconColor: Colors.redAccent,
      status: status,
      onConnectTap: onConnectTap,
      customContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (restingHeartRate != null)
                Row(
                  children: [
                    const Icon(Icons.nightlight_round, size: 14, color: Colors.indigoAccent),
                    const SizedBox(width: 4),
                    Text(
                      'Resting ${restingHeartRate!.round()} BPM',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              if (samples.isNotEmpty)
                Text(
                  'Range: ${trendPoints.map((p) => p.value).reduce((a, b) => a < b ? a : b).round()} - ${trendPoints.map((p) => p.value).reduce((a, b) => a > b ? a : b).round()} BPM',
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
                lineColor: Colors.redAccent,
                gradientColor: Colors.redAccent,
                showDots: trendPoints.length <= 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
