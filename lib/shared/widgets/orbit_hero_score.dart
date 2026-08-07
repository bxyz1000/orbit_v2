import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/orbit_colors.dart';
import '../../core/theme/orbit_typography.dart';
import '../../core/theme/orbit_spacing.dart';

/// Refined arc score meter with tick marks, gradient, glow, animated count-up.
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
            color: colorScheme.onSurface.withValues(alpha: 0.45),
            letterSpacing: 2.0,
          ),
        ),
        OrbitSpacing.vGapLg,

        // Hero arc + score number
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return ScaleTransition(
              scale: _scaleAnim,
              child: SizedBox(
                width: 280,
                height: 200,
                child: CustomPaint(
                  painter: _ScoreArcPainter(
                    progress: _progressAnim.value,
                    accentColor: colorScheme.primary,
                    trackColor: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : OrbitColors.warmGray100,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        '${_scoreAnim.value}',
                        style: OrbitTypography.scoreHero.copyWith(
                          color: colorScheme.onSurface,
                          shadows: [
                            Shadow(
                              color: colorScheme.primary.withValues(alpha: 0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // Baseline comparison
        if (widget.baselineText != null) ...[
          OrbitSpacing.vGapSm,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.trending_up_rounded,
                  size: 14,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  widget.baselineText!,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],

        // Motivation section
        if (widget.motivationTitle != null) ...[
          OrbitSpacing.vGapXl,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: OrbitSpacing.xl,
              vertical: OrbitSpacing.md,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : OrbitColors.warmGray50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : OrbitColors.warmGray200.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('⭐', style: TextStyle(fontSize: 16)),
                OrbitSpacing.hGapSm,
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.motivationTitle!,
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      if (widget.motivationSubtitle != null)
                        Text(
                          widget.motivationSubtitle!,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurface
                                        .withValues(alpha: 0.5),
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

class _ScoreArcPainter extends CustomPainter {
  final double progress;
  final Color accentColor;
  final Color trackColor;

  _ScoreArcPainter({
    required this.progress,
    required this.accentColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.85);
    final radius = size.width * 0.45;
    const strokeWidth = 11.0;
    const startAngle = pi + 0.3;
    const totalSweep = pi - 0.6;

    // Outer subtle track
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

    // Tick marks
    const tickCount = 40;
    for (int i = 0; i <= tickCount; i++) {
      final angle = startAngle + (totalSweep * i / tickCount);
      final isLargeTick = i % 8 == 0;
      final innerR = radius - strokeWidth / 2 - (isLargeTick ? 10 : 5);
      final outerR = radius - strokeWidth / 2 - 2;

      final start = Offset(
        center.dx + innerR * cos(angle),
        center.dy + innerR * sin(angle),
      );
      final end = Offset(
        center.dx + outerR * cos(angle),
        center.dy + outerR * sin(angle),
      );

      final tickPaint = Paint()
        ..color = trackColor.withValues(alpha: isLargeTick ? 0.5 : 0.25)
        ..strokeWidth = isLargeTick ? 1.5 : 0.8
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
            accentColor.withValues(alpha: 0.5),
            accentColor,
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

      // Glow dot at the end
      final endAngle = startAngle + totalSweep * progress.clamp(0.0, 1.0);
      final dotCenter = Offset(
        center.dx + radius * cos(endAngle),
        center.dy + radius * sin(endAngle),
      );

      canvas.drawCircle(
        dotCenter,
        strokeWidth / 2 + 3,
        Paint()..color = accentColor.withValues(alpha: 0.25),
      );
      canvas.drawCircle(
        dotCenter,
        strokeWidth / 2,
        Paint()..color = accentColor,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ScoreArcPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
