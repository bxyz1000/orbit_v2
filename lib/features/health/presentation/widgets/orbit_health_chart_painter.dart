import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../../core/theme/orbit_colors.dart';
import '../../domain/entities/health_sample.dart';

class OrbitHealthChartPainter extends CustomPainter {
  final List<HealthTrendPoint> points;
  final Color lineColor;
  final Color gradientColor;
  final bool showDots;
  final double minValue;
  final double maxValue;

  OrbitHealthChartPainter({
    required this.points,
    required this.lineColor,
    required this.gradientColor,
    this.showDots = true,
    double? minValue,
    double? maxValue,
  })  : minValue = minValue ?? _calcMin(points),
        maxValue = maxValue ?? _calcMax(points);

  static double _calcMin(List<HealthTrendPoint> pts) {
    if (pts.isEmpty) return 0;
    double min = pts.first.value;
    for (var p in pts) {
      if (p.value < min) min = p.value;
    }
    return min * 0.9;
  }

  static double _calcMax(List<HealthTrendPoint> pts) {
    if (pts.isEmpty) return 100;
    double max = pts.first.value;
    for (var p in pts) {
      if (p.value > max) max = p.value;
    }
    return max == 0 ? 100 : max * 1.1;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) {
      _drawEmptyState(canvas, size);
      return;
    }

    if (points.length == 1) {
      _drawSinglePointState(canvas, size, points.first);
      return;
    }

    final double rangeY = maxValue - minValue == 0 ? 1 : maxValue - minValue;
    final double stepX = size.width / (points.length - 1);

    final Path path = Path();
    final Path fillPath = Path();

    final List<Offset> offsets = [];

    for (int i = 0; i < points.length; i++) {
      final x = i * stepX;
      final normalizedY = (points[i].value - minValue) / rangeY;
      final y = size.height - (normalizedY * size.height);
      offsets.add(Offset(x, y));
    }

    path.moveTo(offsets.first.dx, offsets.first.dy);
    fillPath.moveTo(offsets.first.dx, size.height);
    fillPath.lineTo(offsets.first.dx, offsets.first.dy);

    for (int i = 0; i < offsets.length - 1; i++) {
      final p1 = offsets[i];
      final p2 = offsets[i + 1];
      final controlPoint1 = Offset(p1.dx + (p2.dx - p1.dx) / 2, p1.dy);
      final controlPoint2 = Offset(p1.dx + (p2.dx - p1.dx) / 2, p2.dy);

      path.cubicTo(
        controlPoint1.dx, controlPoint1.dy,
        controlPoint2.dx, controlPoint2.dy,
        p2.dx, p2.dy,
      );

      fillPath.cubicTo(
        controlPoint1.dx, controlPoint1.dy,
        controlPoint2.dx, controlPoint2.dy,
        p2.dx, p2.dy,
      );
    }

    fillPath.lineTo(offsets.last.dx, size.height);
    fillPath.close();

    // Draw gradient fill
    final Paint fillPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(0, size.height),
        [
          gradientColor.withValues(alpha: 0.35),
          gradientColor.withValues(alpha: 0.0),
        ],
      );
    canvas.drawPath(fillPath, fillPaint);

    // Draw line
    final Paint linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);

    // Draw data points
    if (showDots) {
      final Paint dotOuterPaint = Paint()..color = lineColor;
      final Paint dotInnerPaint = Paint()..color = Colors.white;

      for (var offset in offsets) {
        canvas.drawCircle(offset, 4.0, dotOuterPaint);
        canvas.drawCircle(offset, 2.0, dotInnerPaint);
      }
    }
  }

  void _drawEmptyState(Canvas canvas, Size size) {
    final Paint gridPaint = Paint()
      ..color = OrbitColors.warmGray300.withValues(alpha: 0.3)
      ..strokeWidth = 1.0;

    // Draw subtle grid lines
    const int lines = 4;
    final stepY = size.height / lines;
    for (int i = 0; i <= lines; i++) {
      canvas.drawLine(Offset(0, i * stepY), Offset(size.width, i * stepY), gridPaint);
    }
  }

  void _drawSinglePointState(Canvas canvas, Size size, HealthTrendPoint point) {
    final center = Offset(size.width / 2, size.height / 2);
    final Paint dotPaint = Paint()..color = lineColor;
    final Paint glowPaint = Paint()..color = lineColor.withValues(alpha: 0.2);

    canvas.drawCircle(center, 12.0, glowPaint);
    canvas.drawCircle(center, 5.0, dotPaint);
  }

  @override
  bool shouldRepaint(covariant OrbitHealthChartPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.gradientColor != gradientColor;
  }
}
