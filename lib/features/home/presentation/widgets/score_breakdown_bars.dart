import 'package:flutter/material.dart';
import '../../score/domain/entities/daily_score.dart';
import '../../../../core/theme/orbit_spacing.dart';

class ScoreBreakdownBars extends StatelessWidget {
  final DailyScore score;

  const ScoreBreakdownBars({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildBar(context, 'Tasks', score.taskScore, Colors.blue),
        OrbitSpacing.gapMd,
        _buildBar(context, 'Focus', score.focusScore, Colors.orange),
        OrbitSpacing.gapMd,
        _buildBar(context, 'Habits', score.habitScore, Colors.green),
        OrbitSpacing.gapMd,
        _buildBar(context, 'Health', score.stepsScore + score.workoutScore + score.sleepScore, Colors.red),
        OrbitSpacing.gapMd,
        _buildBar(context, 'Planner', score.plannerScore, Colors.purple),
      ],
    );
  }

  Widget _buildBar(BuildContext context, String label, int value, Color color) {
    final maxScore = 50.0; // Normalizing contribution
    final progress = (value / maxScore).clamp(0.0, 1.0);

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
