import 'package:flutter/material.dart';
import '../../core/theme/orbit_spacing.dart';

class OrbitSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final TextStyle? titleStyle;

  const OrbitSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: titleStyle ?? theme.textTheme.titleMedium,
        ),
        if (subtitle != null) ...[
          OrbitSpacing.gapXs,
          Text(
            subtitle!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ],
    );
  }
}
