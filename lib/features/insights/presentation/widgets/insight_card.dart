import 'package:flutter/material.dart';
import '../../../../core/theme/orbit_spacing.dart';
import '../../../../shared/widgets/orbit_group_card.dart';
import '../../domain/entities/insight_priority.dart';
import '../../domain/entities/insight_type.dart';
import '../../domain/entities/orbit_insight.dart';

/// A reusable, responsive Material 3 card rendering a real [OrbitInsight].
class InsightCard extends StatelessWidget {
  final OrbitInsight insight;

  const InsightCard({
    super.key,
    required this.insight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final style = _getInsightStyle(context, insight.type, insight.priority);

    return OrbitGroupCard(
      padding: const EdgeInsets.all(OrbitSpacing.lg),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container with themed background
            Container(
              padding: const EdgeInsets.all(OrbitSpacing.sm + 2),
              decoration: BoxDecoration(
                color: style.accentColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                style.icon,
                color: style.accentColor,
                size: 22,
              ),
            ),
            OrbitSpacing.gapLg,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header metadata row: Priority tag & Category tag
                  Wrap(
                    spacing: OrbitSpacing.xs,
                    runSpacing: 4,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      // Priority Badge
                      _buildPriorityBadge(context, insight.priority),
                      if (insight.category != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            insight.category!.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Title
                  Text(
                    insight.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Description
                  Text(
                    insight.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.75),
                      height: 1.35,
                    ),
                  ),

                  // Supporting Data / Change Indicator Chip
                  if (insight.change != null || insight.currentValue != null) ...[
                    const SizedBox(height: OrbitSpacing.sm),
                    _buildSupportingValueChip(context, style.accentColor),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriorityBadge(BuildContext context, InsightPriority priority) {
    Color bg;
    Color fg;
    String label;

    switch (priority) {
      case InsightPriority.high:
        bg = Colors.amber.withValues(alpha: 0.15);
        fg = Colors.amber.shade900;
        label = 'HIGH PRIORITY';
        break;
      case InsightPriority.medium:
        bg = Theme.of(context).colorScheme.primaryContainer;
        fg = Theme.of(context).colorScheme.primary;
        label = 'MEDIUM';
        break;
      case InsightPriority.low:
        bg = Theme.of(context).colorScheme.surfaceContainerHighest;
        fg = Theme.of(context).colorScheme.onSurfaceVariant;
        label = 'INFO';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
          color: fg,
        ),
      ),
    );
  }

  Widget _buildSupportingValueChip(BuildContext context, Color accentColor) {
    final theme = Theme.of(context);
    final text = _formatSupportingText();

    if (text.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: accentColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            (insight.change ?? 0) >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
            size: 12,
            color: accentColor,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatSupportingText() {
    if (insight.change != null) {
      final sign = insight.change! >= 0 ? '+' : '';
      return '$sign${insight.change!.toStringAsFixed(0)} pts';
    } else if (insight.currentValue != null) {
      return '${insight.currentValue!.toStringAsFixed(0)} pts';
    }
    return '';
  }

  _InsightStyle _getInsightStyle(BuildContext context, InsightType type, InsightPriority priority) {
    final primary = Theme.of(context).colorScheme.primary;

    switch (type) {
      case InsightType.scoreImprovement:
        return _InsightStyle(
          accentColor: Colors.green,
          icon: Icons.trending_up,
        );
      case InsightType.scoreDecline:
        return _InsightStyle(
          accentColor: Colors.orange.shade800,
          icon: Icons.auto_awesome,
        );
      case InsightType.personalRecord:
        return _InsightStyle(
          accentColor: Colors.purple,
          icon: Icons.military_tech,
        );
      case InsightType.streak:
        return _InsightStyle(
          accentColor: Colors.deepOrange,
          icon: Icons.local_fire_department,
        );
      case InsightType.strongestCategory:
        return _InsightStyle(
          accentColor: Colors.teal,
          icon: Icons.stars,
        );
      case InsightType.biggestOpportunity:
        return _InsightStyle(
          accentColor: primary,
          icon: Icons.lightbulb_outline,
        );
      case InsightType.aboveBaseline:
        return _InsightStyle(
          accentColor: Colors.green,
          icon: Icons.flight_takeoff,
        );
      case InsightType.belowBaseline:
        return _InsightStyle(
          accentColor: Colors.blueGrey,
          icon: Icons.speed,
        );
      case InsightType.categoryImprovement:
        return _InsightStyle(
          accentColor: Colors.teal,
          icon: Icons.arrow_upward,
        );
      case InsightType.categoryDecline:
        return _InsightStyle(
          accentColor: Colors.amber.shade900,
          icon: Icons.arrow_downward,
        );
      case InsightType.weakestCategory:
      case InsightType.consistency:
        return _InsightStyle(
          accentColor: primary,
          icon: Icons.check_circle_outline,
        );
    }
  }
}

class _InsightStyle {
  final Color accentColor;
  final IconData icon;

  _InsightStyle({required this.accentColor, required this.icon});
}
