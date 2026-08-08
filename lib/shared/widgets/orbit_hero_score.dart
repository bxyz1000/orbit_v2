import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/orbit_colors.dart';

/// Hero score gauge matching Image 3 & Image 4 pixel-for-pixel.
class OrbitHeroScore extends StatefulWidget {
  final int score;
  final double progress; // 0.0 - 1.0
  final String? baselineText;
  final String? motivationTitle;
  final String? motivationSubtitle;

  const OrbitHeroScore({
    super.key,
    required this.score,
    required this.progress,
    this.baselineText,
    this.motivationTitle,
    this.motivationSubtitle,
  });

  @override
  State<OrbitHeroScore> createState() => _OrbitHeroScoreState();
}

class _OrbitHeroScoreState extends State<OrbitHeroScore>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnim;
  late Animation<int> _scoreAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _setupAnimations();
    _controller.forward();
  }

  void _setupAnimations() {
    _progressAnim = Tween<double>(begin: 0, end: widget.progress).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _scoreAnim = IntTween(begin: 0, end: widget.score).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void didUpdateWidget(OrbitHeroScore oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score ||
        oldWidget.progress != widget.progress) {
      _progressAnim =
          Tween<double>(begin: oldWidget.progress, end: widget.progress)
              .animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _scoreAnim =
          IntTween(begin: oldWidget.score, end: widget.score).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // ORBIT SCORE label
        Text(
          'ORBIT SCORE',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
            color: colorScheme.onSurface.withValues(alpha: 0.45),
          ),
        ),
        const SizedBox(height: 4),

        // Large hero score number
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Text(
              '${_scoreAnim.value}',
              style: TextStyle(
                fontSize: 84,
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
                letterSpacing: -3,
                height: 1.0,
              ),
            );
          },
        ),
        const SizedBox(height: 8),

        // Baseline comparison pill badge
        if (widget.baselineText != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: OrbitColors.copper500.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              widget.baselineText!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: OrbitColors.copper500,
              ),
            ),
          ),
        const SizedBox(height: 16),

        // Semicircular score arc gauge with fine tick marks and glowing dot
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return SizedBox(
              width: 320,
              height: 140,
              child: CustomPaint(
                painter: _ScoreArcGaugePainter(
                  progress: _progressAnim.value,
                  accentColor: OrbitColors.copper500,
                  trackColor: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : OrbitColors.warmGray200.withValues(alpha: 0.5),
                  isDark: isDark,
                ),
              ),
            );
          },
        ),

        // Motivation card below arc gauge
        if (widget.motivationTitle != null) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.add_rounded,
                size: 16,
                color: OrbitColors.copper500,
              ),
              const SizedBox(width: 4),
              Text(
                widget.motivationTitle!.replaceAll('+ ', ''),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          if (widget.motivationSubtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              widget.motivationSubtitle!,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ],
      ],
    );
  }
}

class _ScoreArcGaugePainter extends CustomPainter {
  final double progress;
  final Color accentColor;
  final Color trackColor;
  final bool isDark;

  _ScoreArcGaugePainter({
    required this.progress,
    required this.accentColor,
    required this.trackColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.9);
    final radius = size.width * 0.44;
    const strokeWidth = 5.0;
    const startAngle = pi + 0.25;
    const totalSweep = pi - 0.5;

    // Track arc
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      totalSweep,
      false,
      trackPaint,
    );

    // Fine tick marks (50 radial ticks with 0, 25, 50, 75, 100 markers)
    const tickCount = 60;
    for (int i = 0; i <= tickCount; i++) {
      final angle = startAngle + (totalSweep * i / tickCount);
      final isMajor = i % 15 == 0;
      final tickLength = isMajor ? 9.0 : 4.0;
      final outerR = radius - strokeWidth / 2 - 3;
      final innerR = outerR - tickLength;

      final start = Offset(
        center.dx + innerR * cos(angle),
        center.dy + innerR * sin(angle),
      );
      final end = Offset(
        center.dx + outerR * cos(angle),
        center.dy + outerR * sin(angle),
      );

      final isInProgress = (i / tickCount) <= progress;
      final tickPaint = Paint()
        ..color = isInProgress
            ? accentColor.withValues(alpha: isMajor ? 0.8 : 0.4)
            : trackColor.withValues(alpha: isMajor ? 0.4 : 0.2)
        ..strokeWidth = isMajor ? 1.5 : 0.8;

      canvas.drawLine(start, end, tickPaint);
    }

    // Progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 1
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          center: Alignment.center,
          startAngle: startAngle,
          endAngle: startAngle + totalSweep,
          colors: [
            accentColor.withValues(alpha: 0.5),
            accentColor,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius));

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        totalSweep * progress.clamp(0.0, 1.0),
        false,
        progressPaint,
      );

      // Glowing dot endpoint marker
      final endAngle = startAngle + totalSweep * progress.clamp(0.0, 1.0);
      final dotCenter = Offset(
        center.dx + radius * cos(endAngle),
        center.dy + radius * sin(endAngle),
      );

      // Outer glow circle
      canvas.drawCircle(
        dotCenter,
        8,
        Paint()..color = accentColor.withValues(alpha: 0.25),
      );
      // Main dot
      canvas.drawCircle(
        dotCenter,
        5,
        Paint()..color = accentColor,
      );
      // White inner core
      canvas.drawCircle(
        dotCenter,
        2.5,
        Paint()..color = Colors.white,
      );
    }

    // Tick labels: 0, 25, 50, 75, 100
    final labelStyle = TextStyle(
      fontSize: 9,
      fontWeight: FontWeight.w500,
      color: trackColor.withValues(alpha: 0.6),
    );

    const labels = ['0', '25', '50', '75', '100'];
    for (int i = 0; i < labels.length; i++) {
      final angle = startAngle + (totalSweep * i / (labels.length - 1));
      final pos = Offset(
        center.dx + (radius - 20) * cos(angle),
        center.dy + (radius - 20) * sin(angle),
      );
      _drawText(canvas, labels[i], pos, labelStyle);
    }
  }

  void _drawText(Canvas canvas, String text, Offset position, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(position.dx - textPainter.width / 2,
          position.dy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _ScoreArcGaugePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
