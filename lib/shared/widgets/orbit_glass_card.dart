import 'dart:ui';

import 'package:flutter/material.dart';

/// Frosted-glass surface used across the Orbit UI (reference-style
/// glassmorphism): backdrop blur + translucent gradient fill +
/// luminous gradient hairline border + soft ambient shadow.
///
/// Use [dark] for surfaces floating over the dark hub background,
/// and the default light variant over warm-white pages.
class OrbitGlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double radius;
  final bool dark;
  final EdgeInsetsGeometry padding;

  const OrbitGlassCard({
    super.key,
    required this.child,
    this.blur = 24,
    this.radius = 24,
    this.dark = false,
    this.padding = const EdgeInsets.all(18),
  });

  @override
  Widget build(BuildContext context) {
    final List<Color> fills = dark
        ? [
            Colors.white.withValues(alpha: 0.10),
            Colors.white.withValues(alpha: 0.04),
          ]
        : [
            Colors.white.withValues(alpha: 0.60),
            Colors.white.withValues(alpha: 0.28),
          ];
    final Color borderColor = dark
        ? Colors.white.withValues(alpha: 0.16)
        : Colors.white.withValues(alpha: 0.75);
    final Color sheenColor =
        Colors.white.withValues(alpha: dark ? 0.30 : 0.95);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF14100E)
                .withValues(alpha: dark ? 0.30 : 0.08),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: CustomPaint(
            foregroundPainter: _GlassBorderPainter(
              radius: radius,
              borderColor: borderColor,
              sheenColor: sheenColor,
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: fills,
                ),
              ),
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Paints a 1px gradient hairline around the glass edge — brighter along
/// the top-left (specular sheen), fading toward the bottom-right.
class _GlassBorderPainter extends CustomPainter {
  final double radius;
  final Color borderColor;
  final Color sheenColor;

  _GlassBorderPainter({
    required this.radius,
    required this.borderColor,
    required this.sheenColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(0.5),
      Radius.circular(radius - 0.5),
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [sheenColor, borderColor],
      ).createShader(rect);
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_GlassBorderPainter oldDelegate) =>
      oldDelegate.radius != radius ||
      oldDelegate.borderColor != borderColor ||
      oldDelegate.sheenColor != sheenColor;
}