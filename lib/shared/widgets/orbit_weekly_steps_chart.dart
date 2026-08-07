import 'package:flutter/material.dart';
import '../../core/theme/orbit_colors.dart';
import '../../core/theme/orbit_spacing.dart';

/// Horizontal bar chart for weekly step history with personal best indicator.
class OrbitWeeklyStepsChart extends StatelessWidget {
  final List<DayStepData> days;
  final int weeklyAverage;

  const OrbitWeeklyStepsChart({
    super.key,
    required this.days,
    required this.weeklyAverage,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (days.isEmpty) {
      return _buildEmptyState(context);
    }

    final maxSteps = days.fold<int>(0, (max, d) => d.steps > max ? d.steps : max);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'This Week',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              'Avg: ${_formatNumber(weeklyAverage)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
        OrbitSpacing.vGapLg,

        // Day rows
        ...days.map((day) => _DayRow(
              day: day,
              maxSteps: maxSteps,
              accentColor: colorScheme.primary,
              isDark: isDark,
            )),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(OrbitSpacing.xl),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.directions_walk_rounded,
            size: 32,
            color: colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          OrbitSpacing.vGapMd,
          Text(
            'Your step history will appear here\nas Orbit collects more data.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(n >= 10000 ? 0 : 1)}K';
    }
    return '$n';
  }
}

class DayStepData {
  final String label; // "Mon", "Tue", etc.
  final int steps;
  final bool isPersonalBest;
  final bool isToday;

  const DayStepData({
    required this.label,
    required this.steps,
    this.isPersonalBest = false,
    this.isToday = false,
  });
}

class _DayRow extends StatelessWidget {
  final DayStepData day;
  final int maxSteps;
  final Color accentColor;
  final bool isDark;

  const _DayRow({
    required this.day,
    required this.maxSteps,
    required this.accentColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = maxSteps > 0 ? (day.steps / maxSteps).clamp(0.0, 1.0) : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              day.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: day.isToday ? FontWeight.w700 : FontWeight.w500,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: day.isToday ? 1.0 : 0.6),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    // Track
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.04)
                            : OrbitColors.warmGray100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    // Bar
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutCubic,
                      height: 20,
                      width: constraints.maxWidth * ratio,
                      decoration: BoxDecoration(
                        color: accentColor.withValues(
                          alpha: day.isToday ? 1.0 : 0.6,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 52,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  _formatNumber(day.steps),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                if (day.isPersonalBest) ...[
                  const SizedBox(width: 3),
                  Icon(
                    Icons.star_rounded,
                    size: 12,
                    color: accentColor,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int n) {
    if (n >= 10000) return '${(n / 1000).toStringAsFixed(0)},${(n % 1000).toString().padLeft(3, '0').substring(0, 3)}';
    if (n >= 1000) {
      final thousands = n ~/ 1000;
      final remainder = (n % 1000).toString().padLeft(3, '0');
      return '$thousands,$remainder';
    }
    return '$n';
  }
}
