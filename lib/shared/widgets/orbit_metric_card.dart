import 'package:flutter/material.dart';
import '../../core/theme/orbit_colors.dart';
import '../../core/theme/orbit_spacing.dart';
import '../../core/theme/orbit_shadows.dart';

/// Premium category metric card (Tasks 7/9 78%, Focus 82 min 76%, etc.)
class OrbitMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final double? percentage;
  final VoidCallback? onTap;

  const OrbitMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.percentage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(OrbitSpacing.lg),
        decoration: BoxDecoration(
          color: isDark ? OrbitColors.darkElevated : OrbitColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: OrbitShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Icon(
                  icon,
                  size: 18,
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ],
            ),
            OrbitSpacing.vGapSm,
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
            ),
            if (percentage != null) ...[
              OrbitSpacing.vGapSm,
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (percentage! / 100).clamp(0.0, 1.0),
                        minHeight: 4,
                        backgroundColor: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : OrbitColors.warmGray100,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  OrbitSpacing.hGapSm,
                  Text(
                    '${percentage!.toInt()}%',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
