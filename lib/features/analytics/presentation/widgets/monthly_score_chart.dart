import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../score/score.dart';

class MonthlyScoreChart extends ConsumerWidget {
  const MonthlyScoreChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoresAsync = ref.watch(lastThirtyDaysScoresProvider);

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

  _LineChartPainter({
    required this.scores,
    required this.animationValue,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (scores.isEmpty) return;

    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [primaryColor.withValues(alpha: 0.3), primaryColor.withValues(alpha: 0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final fillPath = Path();
    final width = size.width;
    final height = size.height;
    final stepX = width / (scores.length - 1);
    
    final maxScore = scores.map((e) => e.totalScore).reduce((a, b) => a > b ? a : b).toDouble();
    final normalizedMax = maxScore < 100 ? 100.0 : maxScore + 20;

    for (int i = 0; i < scores.length; i++) {
      final x = i * stepX;
      final y = height - (scores[i].totalScore / normalizedMax * height * animationValue);
      
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
      
      if (i == scores.length - 1) {
        fillPath.lineTo(x, height);
        fillPath.close();
      }
    }

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) => 
      oldDelegate.animationValue != animationValue;
}
