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
            _AnimatedStatValue(
              value: value,
              style: valueStyle ??
                  theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
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

class _AnimatedStatValue extends StatelessWidget {
  final String value;
  final TextStyle? style;

  const _AnimatedStatValue({required this.value, this.style});

  @override
  Widget build(BuildContext context) {
    // Check if the value is a simple number or a fraction like "3/5" or a duration like "20m"
    final numberMatch = RegExp(r'^(\d+)(.*)$').firstMatch(value);
    final fractionMatch = RegExp(r'^(\d+)/(\d+)(.*)$').firstMatch(value);

    if (fractionMatch != null) {
      final current = int.tryParse(fractionMatch.group(1) ?? '') ?? 0;
      final total = fractionMatch.group(2) ?? '';
      final suffix = fractionMatch.group(3) ?? '';
      
      return TweenAnimationBuilder<int>(
        tween: IntTween(begin: 0, end: current),
        duration: const Duration(seconds: 1),
        curve: Curves.easeOutCubic,
        builder: (context, val, child) {
          return Text('$val/$total$suffix', style: style, textAlign: TextAlign.center);
        },
      );
    } else if (numberMatch != null) {
      final numValue = int.tryParse(numberMatch.group(1) ?? '') ?? 0;
      final suffix = numberMatch.group(2) ?? '';

      return TweenAnimationBuilder<int>(
        tween: IntTween(begin: 0, end: numValue),
        duration: const Duration(seconds: 1),
        curve: Curves.easeOutCubic,
        builder: (context, val, child) {
          return Text('$val$suffix', style: style, textAlign: TextAlign.center);
        },
      );
    }

    return Text(value, style: style, textAlign: TextAlign.center);
  }
}
