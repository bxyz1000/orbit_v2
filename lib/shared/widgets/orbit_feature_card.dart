import 'dart:ui';

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

  /// Optional asset path for a photographic card background
  /// (e.g. 'assets/images/strava_run.jpg'), drawn under a legibility scrim.
  final String? backgroundImage;

  /// Stat entries for the photo-card footer glass pill
  /// (reference: Strava distance / time / pace).
  final List<OrbitCardStat>? stats;

  /// Tag chips for the photo-card footer glass pill
  /// (reference: "Organize • Plan • Get things done").
  final List<String>? tags;

  /// Leading icon inside the tag pill (defaults to a checklist glyph).
  final IconData? footerIcon;

  /// Show the circular glass chevron button (top-right).
  /// Defaults to true for photo cards.
  final bool? showChevron;

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
    this.backgroundImage,
    this.stats,
    this.tags,
    this.footerIcon,
    this.showChevron,
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
    final hasImage = widget.backgroundImage != null;
    // Photo-card mode: reference layout with brand icon chip, header
    // title/subtitle, chevron button, and a footer glass pill.
    final isPhoto = hasImage;
    // Frosted-glass treatment for flat cards (reference glassmorphism).
    // Never behind a photo — the blur would be hidden under the artwork
    // while still costing GPU time.
    final isGlass = !hasGradient && !hasImage;
    final onArtwork = hasGradient || hasImage;
    final textColor =
        (hasGradient || hasImage) ? Colors.white : colorScheme.onSurface;
    final accentColor = widget.iconColor ?? colorScheme.primary;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.10)
        : Colors.white.withValues(alpha: 0.60);

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
                : (isDark
                    ? OrbitColors.darkElevated.withValues(alpha: 0.35)
                    : Colors.white.withValues(alpha: 0.35)),
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: _isPressed ? OrbitShadows.glass : OrbitShadows.card,
            border: (hasGradient || hasImage)
                ? null
                : Border.all(color: borderColor),
          ),
          child: Stack(
            children: [
              // Frosted glass: backdrop blur + translucent sheen fill
              if (isGlass)
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [
                                  Colors.white.withValues(alpha: 0.09),
                                  Colors.white.withValues(alpha: 0.02),
                                ]
                              : [
                                  Colors.white.withValues(alpha: 0.45),
                                  Colors.white.withValues(alpha: 0.12),
                                ],
                        ),
                      ),
                    ),
                  ),
                ),
              // Photographic background artwork with legibility scrim
              if (hasImage) ...[
                Positioned.fill(
                  child: Image.asset(
                    widget.backgroundImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.35),
                          Colors.black.withValues(alpha: 0.70),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              // Decorative background painter
              if (widget.backgroundPainter != null)
                Positioned.fill(
                  child: CustomPaint(
                    painter: widget.backgroundPainter!,
                  ),
                ),
              // Subtle accent glow in top-right
              if (!hasGradient && !hasImage)
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
              if (isPhoto)
                _buildPhotoContent(context)
              else
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
                            color: onArtwork
                                ? Colors.white.withValues(alpha: 0.2)
                                : accentColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Icon(
                            widget.icon,
                            size: 19,
                            color: onArtwork ? Colors.white : accentColor,
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
                            color: textColor.withValues(alpha: onArtwork ? 0.9 : 0.65),
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
                                color: textColor.withValues(alpha: onArtwork ? 0.72 : 0.4),
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

  /// Reference-style photo-card content: solid brand icon chip + bold
  /// title/subtitle header, glass chevron button, and a footer glass pill
  /// holding either stats or tag chips.
  Widget _buildPhotoContent(BuildContext context) {
    final accentColor =
        widget.iconColor ?? Theme.of(context).colorScheme.primary;
    final showChevron = widget.showChevron ?? true;
    final stats = widget.stats;
    final tags = widget.tags;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // spaceBetween pins the footer pill to the card bottom when the
        // height is bounded, and degrades gracefully when unbounded
        // (a Spacer would throw with infinite height constraints).
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(widget.icon, size: 24, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              letterSpacing: -0.4,
                              color: Colors.white,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.subtitle != null)
                        Text(
                          widget.subtitle!,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                fontSize: 12.5,
                                color: Colors.white.withValues(alpha: 0.75),
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ),
              if (widget.badge != null) ...[
                const SizedBox(width: 8),
                widget.badge!,
              ],
              if (showChevron) ...[
                const SizedBox(width: 8),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.22),
                    ),
                  ),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ],
          ),
          if (stats != null && stats.isNotEmpty)
            _OrbitStatPill(stats: stats)
          else if (tags != null && tags.isNotEmpty)
            _OrbitTagPill(tags: tags, icon: widget.footerIcon),
        ],
      ),
    );
  }
}

/// One stat entry inside a photo card's footer glass pill.
class OrbitCardStat {
  final IconData icon;
  final String value;
  final String label;

  const OrbitCardStat({
    required this.icon,
    required this.value,
    required this.label,
  });
}

/// Frosted stat pill (reference: Strava distance / time / pace footer).
class _OrbitStatPill extends StatelessWidget {
  final List<OrbitCardStat> stats;

  const _OrbitStatPill({required this.stats});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.20),
                Colors.white.withValues(alpha: 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < stats.length; i++) ...[
                if (i > 0)
                  Container(
                    width: 1,
                    height: 26,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                Row(
                  children: [
                    Icon(
                      stats[i].icon,
                      size: 16,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stats[i].value,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          stats[i].label,
                          style: TextStyle(
                            fontSize: 9.5,
                            color: Colors.white.withValues(alpha: 0.65),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Frosted tag pill (reference: "Organize • Plan • Get things done").
class _OrbitTagPill extends StatelessWidget {
  final List<String> tags;
  final IconData? icon;

  const _OrbitTagPill({required this.tags, this.icon});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.20),
                Colors.white.withValues(alpha: 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon ?? Icons.checklist_rounded,
                size: 15,
                color: Colors.white.withValues(alpha: 0.85),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  tags.join('   •   '),
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
