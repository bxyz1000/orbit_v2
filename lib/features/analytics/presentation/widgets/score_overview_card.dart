import 'package:flutter/material.dart';
import '../../domain/score_analytics.dart';
import '../../domain/period_comparison.dart';
import '../../../../core/theme/orbit_spacing.dart';
import '../../../../shared/widgets/orbit_group_card.dart';

class ScoreOverviewCard extends StatelessWidget {
  final ScoreAnalytics scoreAnalytics;

  const ScoreOverviewCard({
    super.key,
    required this.scoreAnalytics,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final comparison = scoreAnalytics.comparison;
    final trend = comparison?.trend ?? TrendDirection.neutral;
    final percentage = comparison?.percentageChange ?? 0.0;

    return OrbitGroupCard(
      padding: const EdgeInsets.all(OrbitSpacing.xl),
      children: [
        Center(
          child: Text(
            'ORBIT SCORE',
            style: textTheme.labelMedium?.copyWith(
              letterSpacing: 2,
              fontWeight: FontWeight.w900,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
        OrbitSpacing.gapLg,
        Center(
          child: TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: scoreAnalytics.averageScore.round()),
            duration: const Duration(seconds: 1),
            curve: Curves.easeOutQuart,
            builder: (context, value, child) {
              return Text(
                '$value',
                style: textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 64,
                ),
              );
            },
          ),
        ),
        if (comparison != null) ...[
          OrbitSpacing.gapMd,
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getTrendIcon(trend),
                  color: _getTrendColor(trend),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${percentage.abs().toStringAsFixed(1)}%',
                  style: textTheme.bodyMedium?.copyWith(
                    color: _getTrendColor(trend),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'vs previous',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
        OrbitSpacing.gapXl,
        const Divider(height: 1),
        OrbitSpacing.gapLg,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              context,
              'Average',
              scoreAnalytics.averageScore.toStringAsFixed(1),
            ),
            _buildStatItem(
              context,
              'Best',
              '${scoreAnalytics.highestScore}',
            ),
            _buildStatItem(
              context,
              'Lowest',
              '${scoreAnalytics.lowestScore}',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  IconData _getTrendIcon(TrendDirection trend) {
    switch (trend) {
      case TrendDirection.up:
        return Icons.arrow_upward;
      case TrendDirection.down:
        return Icons.arrow_downward;
      case TrendDirection.neutral:
        return Icons.remove;
    }
  }

  Color _getTrendColor(TrendDirection trend) {
    switch (trend) {
      case TrendDirection.up:
        return Colors.green;
      case TrendDirection.down:
        return Colors.red;
      case TrendDirection.neutral:
        return Colors.grey;
    }
  }
}
