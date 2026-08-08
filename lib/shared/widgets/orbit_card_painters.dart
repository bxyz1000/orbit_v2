import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/orbit_colors.dart';

/// Decorative background painters for feature cards.
/// These add subtle visual richness matching the premium reference style.

/// Timer / Clock face painter — concentric arcs + tick marks
class TimerCardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.78;
    final cy = size.height * 0.45;
    final r = size.width * 0.22;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Outer ring
    paint.color = Colors.deepOrange.withValues(alpha: 0.08);
    canvas.drawCircle(Offset(cx, cy), r, paint);

    // Inner ring
    paint.color = Colors.deepOrange.withValues(alpha: 0.05);
    canvas.drawCircle(Offset(cx, cy), r * 0.65, paint);

    // Tick marks
    for (int i = 0; i < 12; i++) {
      final angle = (i / 12) * 2 * pi - pi / 2;
      final inner = r * 0.82;
      final outer = r * 0.95;
      final p1 = Offset(cx + inner * cos(angle), cy + inner * sin(angle));
      final p2 = Offset(cx + outer * cos(angle), cy + outer * sin(angle));
      paint.color = Colors.deepOrange.withValues(alpha: i % 3 == 0 ? 0.12 : 0.06);
      paint.strokeWidth = i % 3 == 0 ? 1.5 : 0.8;
      canvas.drawLine(p1, p2, paint);
    }

    // Clock hands
    paint.color = Colors.deepOrange.withValues(alpha: 0.15);
    paint.strokeWidth = 1.5;
    paint.strokeCap = StrokeCap.round;
    // Minute hand
    canvas.drawLine(
      Offset(cx, cy),
      Offset(cx + r * 0.5 * cos(-pi / 3), cy + r * 0.5 * sin(-pi / 3)),
      paint,
    );
    // Hour hand
    paint.strokeWidth = 2.0;
    canvas.drawLine(
      Offset(cx, cy),
      Offset(cx + r * 0.35 * cos(-pi / 6), cy + r * 0.35 * sin(-pi / 6)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Focus wave painter — sine waves
class FocusWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    for (int w = 0; w < 3; w++) {
      final path = Path();
      final yBase = size.height * (0.3 + w * 0.2);
      final opacity = 0.12 - w * 0.03;
      paint.color = Colors.indigo.withValues(alpha: opacity);

      path.moveTo(size.width * 0.5, yBase);
      for (double x = size.width * 0.5; x <= size.width; x += 1) {
        final progress = (x - size.width * 0.5) / (size.width * 0.5);
        final y = yBase + sin(progress * 2 * pi + w * 0.7) * (8 + w * 4);
        path.lineTo(x, y);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Dots grid painter — ambient dot pattern for notes
class DotsGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    const spacing = 14.0;
    final startX = size.width * 0.55;
    final startY = size.height * 0.1;

    for (double x = startX; x < size.width - 4; x += spacing) {
      for (double y = startY; y < size.height - 4; y += spacing) {
        final distFromCenter = sqrt(pow(x - size.width * 0.75, 2) + pow(y - size.height * 0.5, 2));
        final opacity = (0.12 - distFromCenter * 0.001).clamp(0.03, 0.12);
        paint.color = Colors.amber.withValues(alpha: opacity);
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Calendar grid painter — small calendar outline
class CalendarGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = Colors.purple.withValues(alpha: 0.07);

    final left = size.width * 0.6;
    final top = size.height * 0.15;
    final cellW = (size.width - left - 8) / 5;
    final cellH = (size.height - top - 8) / 4;

    for (int r = 0; r < 4; r++) {
      for (int c = 0; c < 5; c++) {
        final rect = Rect.fromLTWH(
          left + c * cellW,
          top + r * cellH,
          cellW - 2,
          cellH - 2,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(3)),
          paint,
        );

        // Fill some cells randomly based on position
        if ((r + c) % 3 == 0) {
          final fillPaint = Paint()
            ..style = PaintingStyle.fill
            ..color = Colors.purple.withValues(alpha: 0.04);
          canvas.drawRRect(
            RRect.fromRectAndRadius(rect, const Radius.circular(3)),
            fillPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Strava route painter — curved path with dots
class StravaRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..color = OrbitColors.copper500.withValues(alpha: 0.15);

    final path = Path();
    path.moveTo(size.width * 0.1, size.height * 0.7);
    path.cubicTo(
      size.width * 0.3, size.height * 0.2,
      size.width * 0.6, size.height * 0.8,
      size.width * 0.9, size.height * 0.3,
    );
    canvas.drawPath(path, paint);

    // Dots along path
    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = OrbitColors.copper500.withValues(alpha: 0.12);
    
    for (double t = 0; t <= 1.0; t += 0.2) {
      final x = size.width * (0.1 + t * 0.8);
      final y = size.height * (0.7 - t * 0.4 + sin(t * pi) * 0.3);
      canvas.drawCircle(Offset(x, y), 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Health heartbeat painter — ECG line
class HeartbeatPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..color = Colors.redAccent.withValues(alpha: 0.12);

    final path = Path();
    final midY = size.height * 0.5;
    path.moveTo(0, midY);

    // Flat line
    path.lineTo(size.width * 0.2, midY);
    // Small bump
    path.lineTo(size.width * 0.25, midY - 8);
    path.lineTo(size.width * 0.28, midY + 4);
    // Big spike
    path.lineTo(size.width * 0.35, midY - 25);
    path.lineTo(size.width * 0.4, midY + 15);
    // Recovery
    path.lineTo(size.width * 0.45, midY - 6);
    path.lineTo(size.width * 0.5, midY);
    // Flat + repeat
    path.lineTo(size.width * 0.6, midY);
    path.lineTo(size.width * 0.65, midY - 8);
    path.lineTo(size.width * 0.68, midY + 4);
    path.lineTo(size.width * 0.75, midY - 20);
    path.lineTo(size.width * 0.8, midY + 12);
    path.lineTo(size.width * 0.85, midY - 4);
    path.lineTo(size.width * 0.9, midY);
    path.lineTo(size.width, midY);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Habits ring painter — concentric progress rings
class HabitsRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.78;
    final cy = size.height * 0.5;

    final rings = [
      (r: size.width * 0.2, sweep: 0.75, color: Colors.green),
      (r: size.width * 0.14, sweep: 0.6, color: Colors.teal),
      (r: size.width * 0.08, sweep: 0.9, color: Colors.lightGreen),
    ];

    for (final ring in rings) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round
        ..color = ring.color.withValues(alpha: 0.12);

      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: ring.r),
        -pi / 2,
        ring.sweep * 2 * pi,
        false,
        paint,
      );

      // Track
      final trackPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..color = ring.color.withValues(alpha: 0.04);
      canvas.drawCircle(Offset(cx, cy), ring.r, trackPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Tasks checklist painter — checkboxes  
class TasksCheckPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final boxSize = 10.0;
    final startX = size.width * 0.65;
    final startY = size.height * 0.15;
    final spacing = 16.0;

    for (int i = 0; i < 5; i++) {
      final y = startY + i * spacing;
      final isChecked = i < 3;

      // Checkbox
      paint.color = Colors.blue.withValues(alpha: isChecked ? 0.15 : 0.08);
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(startX, y, boxSize, boxSize),
        const Radius.circular(3),
      );
      canvas.drawRRect(rect, paint);

      if (isChecked) {
        // Fill
        final fillPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.blue.withValues(alpha: 0.06);
        canvas.drawRRect(rect, fillPaint);

        // Checkmark
        paint.strokeWidth = 1.5;
        paint.strokeCap = StrokeCap.round;
        paint.color = Colors.blue.withValues(alpha: 0.2);
        canvas.drawLine(
          Offset(startX + 2.5, y + 5),
          Offset(startX + 4.5, y + 7.5),
          paint,
        );
        canvas.drawLine(
          Offset(startX + 4.5, y + 7.5),
          Offset(startX + 8, y + 2.5),
          paint,
        );
        paint.strokeWidth = 1.0;
      }

      // Line after checkbox
      paint.color = Colors.blue.withValues(alpha: isChecked ? 0.06 : 0.04);
      paint.strokeWidth = 1.2;
      canvas.drawLine(
        Offset(startX + boxSize + 6, y + boxSize / 2),
        Offset(size.width - 8, y + boxSize / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Analytics chart painter — mini bar chart
class AnalyticsChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final barHeights = [0.4, 0.6, 0.8, 0.5, 0.7, 0.9, 0.65];
    final barWidth = 4.0;
    final gap = 6.0;
    final totalW = barHeights.length * (barWidth + gap);
    final startX = size.width - totalW - 8;
    final baseY = size.height * 0.85;
    final maxH = size.height * 0.55;

    for (int i = 0; i < barHeights.length; i++) {
      final x = startX + i * (barWidth + gap);
      final h = maxH * barHeights[i];
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = OrbitColors.copper500.withValues(alpha: 0.08 + barHeights[i] * 0.08);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, baseY - h, barWidth, h),
          const Radius.circular(2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Goals flag painter — flag on pole
class GoalsFlagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.8;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..color = Colors.teal.withValues(alpha: 0.12);

    // Pole
    canvas.drawLine(
      Offset(cx, size.height * 0.15),
      Offset(cx, size.height * 0.85),
      paint,
    );

    // Flag
    final flagPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.teal.withValues(alpha: 0.06);
    final flagPath = Path();
    flagPath.moveTo(cx, size.height * 0.2);
    flagPath.lineTo(cx + 20, size.height * 0.3);
    flagPath.lineTo(cx, size.height * 0.4);
    flagPath.close();
    canvas.drawPath(flagPath, flagPaint);
    canvas.drawPath(flagPath, paint..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
