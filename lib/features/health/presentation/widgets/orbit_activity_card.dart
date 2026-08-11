import 'package:flutter/material.dart';
import '../../../../core/theme/orbit_colors.dart';
import '../../domain/health_metrics.dart';
import '../providers/health_providers.dart';
import 'orbit_health_metric_card.dart';

class OrbitActivityCard extends StatelessWidget {
  final int activeMinutes;
  final int workoutMinutes;
  final double distanceMeters;
  final List<WorkoutLog> workouts;
  final HealthMetricStatus status;
  final VoidCallback? onConnectTap;

  const OrbitActivityCard({
    super.key,
    required this.activeMinutes,
    required this.workoutMinutes,
    required this.distanceMeters,
    this.workouts = const [],
    this.status = HealthMetricStatus.available,
    this.onConnectTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final double distanceKm = distanceMeters / 1000.0;
    final String metricStr = workoutMinutes > 0
        ? '${workoutMinutes}m workouts'
        : (activeMinutes > 0 ? '${activeMinutes}m active' : '0m');

    final String subtitleStr = distanceKm > 0
        ? '${distanceKm.toStringAsFixed(2)} km covered today'
        : 'No exercise sessions recorded today';

    return OrbitHealthMetricCard(
      title: 'Activity & Workouts',
      metricValue: metricStr,
      subtitle: subtitleStr,
      icon: Icons.fitness_center_rounded,
      iconColor: OrbitColors.copper500,
      status: status,
      onConnectTap: onConnectTap,
      customContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatPill(context, 'Distance', '${distanceKm.toStringAsFixed(1)} km', isDark),
              _buildStatPill(context, 'Active Mins', '${activeMinutes}m', isDark),
              _buildStatPill(context, 'Workouts', '${workouts.length}', isDark),
            ],
          ),
          if (workouts.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              'TODAY\'S WORKOUT SESSIONS',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                color: colorScheme.onSurface.withValues(alpha: 0.45),
              ),
            ),
            const SizedBox(height: 8),
            ...workouts.map((w) => Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.directions_run_rounded, size: 14, color: OrbitColors.copper500),
                          const SizedBox(width: 6),
                          Text(
                            w.type ?? 'Workout',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${w.durationMinutes}m',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: OrbitColors.copper500,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildStatPill(BuildContext context, String label, String value, bool isDark) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : OrbitColors.warmGray100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
