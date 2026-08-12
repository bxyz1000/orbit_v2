import 'package:flutter/material.dart';
import '../../core/theme/orbit_colors.dart';
import '../../core/theme/orbit_shadows.dart';

/// Premium feature hub card with icon, metric, label, gradient background,
/// optional decorative painter, and tactile press micro-interaction.
class OrbitFeatureCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String? metric;
  final IconData icon;
  final Color? iconColor;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final Widget? badge;
  final bool isWide;
  final double? height;
  final CustomPainter? backgroundPainter;

  const OrbitFeatureCard({
    super.key,
    required this.title,
    this.subtitle,
    this.metric,
    required this.icon,
    this.iconColor,
    this.gradient,
    this.onTap,
    this.badge,
    this.isWide = false,
    this.height,
    this.backgroundPainter,
  });

  @override
  State<OrbitFeatureCard> createState() => _OrbitFeatureCardState();
}

class _OrbitFeatureCardState extends State<OrbitFeatureCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final hasGradient = widget.gradient != null;
    final textColor = hasGradient ? Colors.white : colorScheme.onSurface;
    final accentColor = widget.iconColor ?? colorScheme.primary;
    final surfaceColor = isDark
        ? OrbitColors.darkElevated
        : const Color(0xFFFDF9F5);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : const Color(0xFFE8DDD3).withValues(alpha: 0.9);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: hasGradient
                ? null
                : surfaceColor,
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: _isPressed ? OrbitShadows.glass : OrbitShadows.card,
            border: hasGradient
                ? null
                : Border.all(color: borderColor),
          ),
          child: Stack(
            children: [
              // Decorative background painter
              if (widget.backgroundPainter != null)
                Positioned.fill(
                  child: CustomPaint(
                    painter: widget.backgroundPainter!,
                  ),
                ),
              // Subtle accent glow in top-right
              if (!hasGradient)
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          accentColor.withValues(alpha: 0.06),
                          accentColor.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
              // Card content
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: hasGradient
                                ? Colors.white.withValues(alpha: 0.2)
                                : accentColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Icon(
                            widget.icon,
                            size: 19,
                            color: hasGradient ? Colors.white : accentColor,
                          ),
                        ),
                        if (widget.badge != null) widget.badge!,
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (widget.metric != null)
                      Text(
                        widget.metric!,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: textColor,
                              fontSize: 21,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 2),
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: textColor.withValues(alpha: hasGradient ? 0.85 : 0.65),
                            fontSize: 13,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(
                          widget.subtitle!,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: textColor.withValues(alpha: hasGradient ? 0.7 : 0.4),
                                fontSize: 11,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
