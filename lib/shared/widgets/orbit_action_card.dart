import 'package:flutter/material.dart';
import '../../core/theme/orbit_spacing.dart';
import '../../core/theme/orbit_radius.dart';

class OrbitActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final String? semanticLabel;

  const OrbitActionCard({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      button: true,
      label: semanticLabel ?? title,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: OrbitRadius.brMd,
          border: Border.all(color: colorScheme.outline.withOpacity(0.5)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: OrbitRadius.brMd,
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: colorScheme.primary, size: 24),
                OrbitSpacing.gapSm,
                Text(
                  title,
                  style: theme.textTheme.labelLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
