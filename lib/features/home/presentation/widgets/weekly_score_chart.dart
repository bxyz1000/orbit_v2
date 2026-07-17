import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../score/score.dart';

class WeeklyScoreChart extends ConsumerWidget {
  const WeeklyScoreChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoresAsync = ref.watch(lastSevenDaysScoresProvider);

    return scoresAsync.when(
      data: (scores) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(seconds: 1),
        curve: Curves.easeOutQuart,
        builder: (context, value, child) {
          return CustomPaint(
            painter: _LineChartPainter(
              scores: scores,
              animationValue: value,
              primaryColor: Theme.of(context).colorScheme.primary,
              onSurfaceColor: Theme.of(context).colorScheme.onSurface,
            ),
            size: Size.infinite,
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox(),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<DailyScore> scores;
  final double animationValue;
  final Color primaryColor;
  final Color onSurfaceColor;

  _LineChartPainter({
    required this.scores,
    required this.animationValue,
    required this.primaryColor,
    required this.onSurfaceColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (scores.isEmpty) return;

    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final path = Path();
    final width = size.width;
    final height = size.height;
    final stepX = width / (scores.length - 1);
    
    // Normalize scores
    final maxScore = scores.map((e) => e.totalScore).reduce((a, b) => a > b ? a : b).toDouble();
    final normalizedMax = maxScore < 100 ? 100.0 : maxScore + 20;

    for (int i = 0; i < scores.length; i++) {
      final x = i * stepX;
      final y = height - (scores[i].totalScore / normalizedMax * height * animationValue);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw dots
    for (int i = 0; i < scores.length; i++) {
      final x = i * stepX;
      final y = height - (scores[i].totalScore / normalizedMax * height * animationValue);
      canvas.drawCircle(Offset(x, y), 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) => 
      oldDelegate.animationValue != animationValue;
}
