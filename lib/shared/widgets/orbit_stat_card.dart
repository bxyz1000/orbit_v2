import 'package:flutter/material.dart';
import '../../core/theme/orbit_spacing.dart';
import '../../core/theme/orbit_radius.dart';

class OrbitStatCard extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String value;
  final TextStyle? valueStyle;

  const OrbitStatCard({
    super.key,
    this.icon,
    required this.title,
    required this.value,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      label: '$title: $value',
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: OrbitSpacing.lg,
          horizontal: OrbitSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: OrbitRadius.brMd,
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            if (icon != null) ...[
              Icon(icon, color: colorScheme.primary, size: 20),
              OrbitSpacing.gapSm,
            ],
            Text(
              value,
              style: valueStyle ??
                  theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            OrbitSpacing.gapXs,
            Text(
              title,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
