import 'package:flutter/material.dart';
import '../../domain/orbit_analytics.dart';
import '../../domain/period_comparison.dart';
import '../../../../core/theme/orbit_spacing.dart';
import '../../../../shared/widgets/orbit_group_card.dart';
import '../../../../shared/widgets/orbit_section_header.dart';
import '../../../../shared/widgets/orbit_info_tile.dart';

class ComparisonSection extends StatelessWidget {
  final OrbitAnalytics analytics;

  const ComparisonSection({
    super.key,
    required this.analytics,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrbitSectionHeader(title: "Period Comparison"),
        OrbitSpacing.gapLg,
        OrbitGroupCard(
          children: [
            if (analytics.score.comparison != null)
              _buildComparisonTile(
                context,
                'Orbit Score',
                analytics.score.comparison!,
                Icons.bolt,
                Colors.amber,
              ),
            if (analytics.tasks.completionComparison != null) ...[
              const Divider(height: 1, indent: 56),
              _buildComparisonTile(
                context,
                'Task Completion',
                analytics.tasks.completionComparison!,
                Icons.check_circle_outline,
                Colors.blue,
              ),
            ],
            if (analytics.focus.minutesComparison != null) ...[
              const Divider(height: 1, indent: 56),
              _buildComparisonTile(
                context,
                'Focus Time',
                analytics.focus.minutesComparison!,
                Icons.timer_outlined,
                Colors.orange,
              ),
            ],
            if (analytics.health.stepsComparison != null) ...[
              const Divider(height: 1, indent: 56),
              _buildComparisonTile(
                context,
                'Daily Steps',
                analytics.health.stepsComparison!,
                Icons.directions_walk,
                Colors.green,
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildComparisonTile(
    BuildContext context,
    String title,
    PeriodComparison<num> comparison,
    IconData icon,
    Color iconColor,
  ) {
    final theme = Theme.of(context);
    
    return OrbitInfoTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: title,
      subtitle: '${comparison.percentageChange >= 0 ? '+' : ''}${comparison.percentageChange.toStringAsFixed(1)}% vs last period',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getTrendIcon(comparison.trend),
            color: _getTrendColor(comparison.trend),
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            _formatValue(comparison.currentValue),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: _getTrendColor(comparison.trend),
            ),
          ),
        ],
      ),
    );
  }

  String _formatValue(num value) {
    if (value is double) return value.toStringAsFixed(1);
    return value.toString();
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
