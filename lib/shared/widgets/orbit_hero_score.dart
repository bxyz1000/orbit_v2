import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/orbit_colors.dart';
import '../../core/theme/orbit_typography.dart';
import '../../core/theme/orbit_spacing.dart';

/// Premium semicircular score arc with fine tick marks, gradient progress,
/// glow dot, animated count-up, and restrained copper accent.
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
  late Animation<double> _scaleAnim;

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
    _scaleAnim = Tween<double>(begin: 0.92, end: 1.0).animate(
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
        // Score label
        Text(
          'ORBIT SCORE',
          style: OrbitTypography.sectionLabel.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.4),
            letterSpacing: 2.5,
            fontSize: 10,
          ),
        ),
        OrbitSpacing.vGapMd,

        // Large score number above the arc
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Text(
              '${_scoreAnim.value}',
              style: OrbitTypography.scoreHero.copyWith(
                color: colorScheme.onSurface,
                fontSize: 88,
                fontWeight: FontWeight.w800,
                letterSpacing: -3,
              ),
            );
          },
        ),
        const SizedBox(height: 4),

        // Hero arc gauge
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return ScaleTransition(
              scale: _scaleAnim,
              child: SizedBox(
                width: 300,
                height: 140,
                child: CustomPaint(
                  painter: _PremiumScoreArcPainter(
                    progress: _progressAnim.value,
                    accentColor: colorScheme.primary,
                    trackColor: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : OrbitColors.warmGray100.withValues(alpha: 0.7),
                    isDark: isDark,
                  ),
                ),
              ),
            );
          },
        ),

        // Baseline comparison
        if (widget.baselineText != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.trending_up_rounded,
                  size: 13,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  widget.baselineText!,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                ),
              ],
            ),
          ),
        ],

        // Motivation section
        if (widget.motivationTitle != null) ...[
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.03)
                  : OrbitColors.warmGray50.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : OrbitColors.warmGray200.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                ),
                OrbitSpacing.hGapMd,
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.motivationTitle!,
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                      ),
                      if (widget.motivationSubtitle != null)
                        Text(
                          widget.motivationSubtitle!,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurface
                                        .withValues(alpha: 0.45),
                                    fontSize: 12,
                                  ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _PremiumScoreArcPainter extends CustomPainter {
  final double progress;
  final Color accentColor;
  final Color trackColor;
  final bool isDark;

  _PremiumScoreArcPainter({
    required this.progress,
    required this.accentColor,
    required this.trackColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.95);
    final radius = size.width * 0.44;
    const strokeWidth = 8.0;
    const startAngle = pi + 0.25;
    const totalSweep = pi - 0.5;

    // Track arc (inactive)
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

    // Fine tick marks — 50 ticks
    const tickCount = 50;
    for (int i = 0; i <= tickCount; i++) {
      final angle = startAngle + (totalSweep * i / tickCount);
      final isLargeTick = i % 10 == 0;
      final isMediumTick = i % 5 == 0;
      final tickLength = isLargeTick ? 10.0 : (isMediumTick ? 6.0 : 3.5);
      final outerR = radius - strokeWidth / 2 - 4;
      final innerR = outerR - tickLength;

      final start = Offset(
        center.dx + innerR * cos(angle),
        center.dy + innerR * sin(angle),
      );
      final end = Offset(
        center.dx + outerR * cos(angle),
        center.dy + outerR * sin(angle),
      );

      // Ticks within progress range get accent color
      final isInProgress = (i / tickCount) <= progress;
      final tickOpacity = isLargeTick ? 0.5 : (isMediumTick ? 0.3 : 0.15);

      final tickPaint = Paint()
        ..color = isInProgress
            ? accentColor.withValues(alpha: tickOpacity + 0.3)
            : trackColor.withValues(alpha: tickOpacity + 0.1)
        ..strokeWidth = isLargeTick ? 1.5 : (isMediumTick ? 1.0 : 0.6)
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(start, end, tickPaint);
    }

    // Progress arc with gradient
    if (progress > 0) {
      final progressPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          center: Alignment.center,
          startAngle: startAngle,
          endAngle: startAngle + totalSweep,
          colors: [
            accentColor.withValues(alpha: 0.4),
            accentColor.withValues(alpha: 0.7),
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

      // Soft outer glow behind progress
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 12
        ..strokeCap = StrokeCap.round
        ..color = accentColor.withValues(alpha: 0.06);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        totalSweep * progress.clamp(0.0, 1.0),
        false,
        glowPaint,
      );

      // Glow dot at the end of progress
      final endAngle = startAngle + totalSweep * progress.clamp(0.0, 1.0);
      final dotCenter = Offset(
        center.dx + radius * cos(endAngle),
        center.dy + radius * sin(endAngle),
      );

      // Outer glow
      canvas.drawCircle(
        dotCenter,
        strokeWidth / 2 + 5,
        Paint()..color = accentColor.withValues(alpha: 0.15),
      );
      // Inner glow
      canvas.drawCircle(
        dotCenter,
        strokeWidth / 2 + 2,
        Paint()..color = accentColor.withValues(alpha: 0.3),
      );
      // Dot
      canvas.drawCircle(
        dotCenter,
        strokeWidth / 2,
        Paint()..color = accentColor,
      );
      // White center
      canvas.drawCircle(
        dotCenter,
        2.5,
        Paint()..color = isDark ? const Color(0xFF1C1816) : Colors.white,
      );
    }

    // Min / Max labels below arc endpoints
    final labelStyle = TextStyle(
      fontSize: 9,
      fontWeight: FontWeight.w500,
      color: trackColor.withValues(alpha: 0.6),
    );

    // "0" label
    final startLabelAngle = startAngle;
    final startLabelPos = Offset(
      center.dx + (radius + 18) * cos(startLabelAngle),
      center.dy + (radius + 18) * sin(startLabelAngle),
    );
    _drawText(canvas, '0', startLabelPos, labelStyle);

    // "100" label
    final endLabelAngle = startAngle + totalSweep;
    final endLabelPos = Offset(
      center.dx + (radius + 18) * cos(endLabelAngle),
      center.dy + (radius + 18) * sin(endLabelAngle),
    );
    _drawText(canvas, '100', endLabelPos, labelStyle);
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
  bool shouldRepaint(covariant _PremiumScoreArcPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
