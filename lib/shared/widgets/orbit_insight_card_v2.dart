import 'package:flutter/material.dart';
import '../../core/theme/orbit_colors.dart';
import '../../core/theme/orbit_spacing.dart';
import '../../core/theme/orbit_shadows.dart';
import '../../features/insights/domain/entities/orbit_insight.dart';
import '../../features/insights/domain/entities/insight_type.dart';

/// Premium redesigned insight card for the new Orbit UI.
class OrbitInsightCardV2 extends StatelessWidget {
  final OrbitInsight insight;

  const OrbitInsightCardV2({super.key, required this.insight});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(OrbitSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? OrbitColors.darkElevated : OrbitColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: OrbitShadows.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getInsightColor(insight.type).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                _getInsightEmoji(insight.type),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          OrbitSpacing.hGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                OrbitSpacing.vGapXs,
                Text(
                  insight.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        height: 1.4,
                      ),
                ),
                if (insight.change != null) ...[
                  OrbitSpacing.vGapSm,
                  Row(
                    children: [
                      Icon(
                        insight.change! >= 0
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        size: 14,
                        color: insight.change! >= 0
                            ? OrbitColors.success
                            : OrbitColors.error,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${insight.change! >= 0 ? '+' : ''}${insight.change!.toStringAsFixed(1)}%',
                        style:
                            Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: insight.change! >= 0
                                      ? OrbitColors.success
                                      : OrbitColors.error,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getInsightEmoji(InsightType type) {
    switch (type) {
      case InsightType.scoreImprovement:
      case InsightType.categoryImprovement:
      case InsightType.aboveBaseline:
        return '📈';
      case InsightType.scoreDecline:
      case InsightType.categoryDecline:
      case InsightType.belowBaseline:
        return '📉';
      case InsightType.streak:
      case InsightType.consistency:
        return '🔥';
      case InsightType.personalRecord:
        return '🏆';
      case InsightType.strongestCategory:
        return '⭐';
      case InsightType.weakestCategory:
      case InsightType.biggestOpportunity:
        return '🎯';
    }
  }

  Color _getInsightColor(InsightType type) {
    switch (type) {
      case InsightType.scoreImprovement:
      case InsightType.categoryImprovement:
      case InsightType.aboveBaseline:
        return OrbitColors.success;
      case InsightType.scoreDecline:
      case InsightType.categoryDecline:
      case InsightType.belowBaseline:
        return OrbitColors.warning;
      case InsightType.streak:
      case InsightType.consistency:
        return OrbitColors.copper500;
      case InsightType.personalRecord:
      case InsightType.strongestCategory:
        return OrbitColors.copper400;
      case InsightType.weakestCategory:
      case InsightType.biggestOpportunity:
        return OrbitColors.info;
    }
  }
}
