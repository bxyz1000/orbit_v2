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
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _auraController;
  late Animation<double> _progressAnim;
  late Animation<int> _scoreAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    // Slow breathing cycle for the ambient copper aura (felt, not seen).
    _auraController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);
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
    _auraController.dispose();
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
            fontWeight: FontWeight.w800,
            letterSpacing: 2.0,
            color: colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 2),

        // Large hero score number with breathing ambient copper radial glow
        Stack(
          alignment: Alignment.center,
          children: [
            // Focused radial ambient copper glow (slow breathing cycle)
            AnimatedBuilder(
              animation: _auraController,
              builder: (context, child) {
                final t = Curves.easeInOut.transform(_auraController.value);
                final baseAlpha = isDark ? 0.20 : 0.13;
                final alpha = baseAlpha + 0.07 * t;
                return Container(
                  width: 180,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        OrbitColors.copper500.withValues(alpha: alpha),
                        OrbitColors.copper500.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Text(
                  '${_scoreAnim.value}',
                  style: TextStyle(
                    fontSize: 104,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                    letterSpacing: -4,
                    height: 0.95,
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Baseline comparison pill badge
        if (widget.baselineText != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: OrbitColors.copper500.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: OrbitColors.copper500.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: Text(
              widget.baselineText!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: OrbitColors.copper500,
                letterSpacing: -0.2,
              ),
            ),
          ),
        const SizedBox(height: 14),

        // Flowing orbital arc curve underneath score with glowing node point
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return SizedBox(
              width: 300,
              height: 70,
              child: CustomPaint(
                painter: _ScoreArcGaugePainter(
                  progress: _progressAnim.value,
                  accentColor: OrbitColors.copper500,
                  trackColor: isDark
                      ? Colors.white.withValues(alpha: 0.16)
                      : OrbitColors.warmGray200.withValues(alpha: 0.95),
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
    final center = Offset(size.width / 2, size.height * -0.6);
    final radius = size.width * 0.72;
    const strokeWidth = 3.0;
    const startAngle = pi * 0.28;
    const totalSweep = pi * 0.44;

    // Track orbital curve line
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

    // Dynamic progress curve line
    if (progress > 0) {
      final activeSweep = totalSweep * progress.clamp(0.0, 1.0);
      final progressPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 0.5
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          center: Alignment.center,
          startAngle: startAngle,
          endAngle: startAngle + totalSweep,
          colors: [
            accentColor.withValues(alpha: 0.35),
            accentColor,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius));

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        activeSweep,
        false,
        progressPaint,
      );

      // Glowing dot endpoint marker
      final endAngle = startAngle + activeSweep;
      final dotCenter = Offset(
        center.dx + radius * cos(endAngle),
        center.dy + radius * sin(endAngle),
      );

      // Outer glow circle
      canvas.drawCircle(
        dotCenter,
        7,
        Paint()..color = accentColor.withValues(alpha: 0.28),
      );
      // Main dot
      canvas.drawCircle(
        dotCenter,
        4.5,
        Paint()..color = accentColor,
      );
      // White inner core
      canvas.drawCircle(
        dotCenter,
        2.0,
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ScoreArcGaugePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
