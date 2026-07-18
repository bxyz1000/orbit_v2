import 'package:flutter/material.dart';
import 'package:orbit_v2/features/score/domain/entities/daily_score.dart';
import '../../../../core/theme/orbit_spacing.dart';

class ScoreBreakdownBars extends StatelessWidget {
  final DailyScore score;

  const ScoreBreakdownBars({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    // Only show bars for categories that have points or a minimum visual representation
    final categories = [
      _BreakdownData('Tasks', score.taskScore, Colors.blue),
      _BreakdownData('Focus', score.focusScore, Colors.orange),
      _BreakdownData('Habits', score.habitScore, Colors.green),
      _BreakdownData('Health', score.stepsScore + score.workoutScore + score.sleepScore, Colors.red),
      _BreakdownData('Planner', score.plannerScore, Colors.purple),
    ];

    final activeCategories = categories.where((c) => c.value > 0).toList();

    if (activeCategories.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Complete actions to see score breakdown.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ),
      );
    }

    return Column(
      children: activeCategories.map((cat) => Column(
        children: [
          _buildBar(context, cat.label, cat.value, cat.color),
          if (activeCategories.indexOf(cat) < activeCategories.length - 1) 
            OrbitSpacing.gapMd,
        ],
      )).toList(),
    );
  }

  Widget _buildBar(BuildContext context, String label, int value, Color color) {
    // Use a logical max for normalization, e.g., 50 points per category sub-goal
    final maxScore = 100.0; 
    final progress = (value / maxScore).clamp(0.01, 1.0); // Show at least a tiny bit if > 0

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelMedium),
            Text('+$value', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: progress),
          duration: const Duration(seconds: 1),
          curve: Curves.easeOutQuart,
          builder: (context, value, child) {
            return LinearProgressIndicator(
              value: value,
              backgroundColor: color.withValues(alpha: 0.1),
              color: color,
              borderRadius: BorderRadius.circular(10),
              minHeight: 6,
            );
          },
        ),
      ],
    );
  }
}

class _BreakdownData {
  final String label;
  final int value;
  final Color color;
  _BreakdownData(this.label, this.value, this.color);
}
