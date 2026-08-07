import 'package:flutter/material.dart';
import '../../domain/focus_analytics.dart';
import '../../../../core/theme/orbit_spacing.dart';
import '../../../../shared/widgets/orbit_group_card.dart';
import '../../../../shared/widgets/orbit_stat_card.dart';
import '../../../../shared/widgets/orbit_section_header.dart';

class FocusAnalyticsSection extends StatelessWidget {
  final FocusAnalytics focusAnalytics;

  const FocusAnalyticsSection({
    super.key,
    required this.focusAnalytics,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrbitSectionHeader(title: "Focus"),
        OrbitSpacing.gapLg,
        Row(
          children: [
            Expanded(
              child: OrbitStatCard(
                title: 'Total Time',
                value: _formatMinutes(focusAnalytics.totalMinutes),
                icon: Icons.timer_outlined,
              ),
            ),
            OrbitSpacing.gapMd,
            Expanded(
              child: OrbitStatCard(
                title: 'Avg Daily',
                value: '${focusAnalytics.averageDailyMinutes.round()}m',
                icon: Icons.speed,
              ),
            ),
          ],
        ),
        OrbitSpacing.gapMd,
        OrbitGroupCard(
          padding: const EdgeInsets.all(OrbitSpacing.xl),
          children: [
            const Text(
              'FOCUS MINUTES',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
            ),
            OrbitSpacing.gapLg,
            SizedBox(
              height: 120,
              child: _FocusLineChart(analytics: focusAnalytics),
            ),
          ],
        ),
      ],
    );
  }

  String _formatMinutes(int minutes) {
    if (minutes < 60) return '${minutes}m';
    final hours = minutes / 60;
    return '${hours.toStringAsFixed(1)}h';
  }
}

class _FocusLineChart extends StatelessWidget {
  final FocusAnalytics analytics;

  const _FocusLineChart({required this.analytics});

  @override
  Widget build(BuildContext context) {
    if (analytics.minutesPerDay.isEmpty) {
      return const Center(child: Text('No data yet', style: TextStyle(fontSize: 12, color: Colors.grey)));
    }

    final points = analytics.minutesPerDay;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 1),
      curve: Curves.easeOutQuart,
      builder: (context, value, child) {
        return CustomPaint(
          painter: _SimpleLinePainter(
            points: points,
            animationValue: value,
            color: primaryColor,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _SimpleLinePainter extends CustomPainter {
  final List<dynamic> points;
  final double animationValue;
  final Color color;

  _SimpleLinePainter({
    required this.points,
    required this.animationValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final fillPath = Path();
    final width = size.width;
    final height = size.height;
    final stepX = points.length > 1 ? width / (points.length - 1) : width;
    
    final maxValue = points.map((e) => (e.value as num).toDouble()).reduce((a, b) => a > b ? a : b);
    final normalizedMax = maxValue < 60 ? 60.0 : maxValue * 1.2;

    for (int i = 0; i < points.length; i++) {
      final x = i * stepX;
      final y = height - ((points[i].value as num).toDouble() / normalizedMax * height * animationValue);
      
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
      
      if (i == points.length - 1) {
        fillPath.lineTo(x, height);
        fillPath.close();
      }
    }

    if (points.length == 1) {
      canvas.drawCircle(Offset(0, height - ((points[0].value as num).toDouble() / normalizedMax * height * animationValue)), 4, paint..style = PaintingStyle.fill);
    } else {
      canvas.drawPath(fillPath, fillPaint);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SimpleLinePainter oldDelegate) => 
      oldDelegate.animationValue != animationValue;
}
