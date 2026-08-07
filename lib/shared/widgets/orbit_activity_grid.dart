import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/orbit_colors.dart';

/// Custom step activity grid visualization showing hourly activity intensity.
/// Inspired by the reference healthcare wearable UI.
class OrbitActivityGrid extends StatefulWidget {
  /// 24 values (one per hour, 0 AM - 11 PM), each 0.0 to 1.0 intensity.
  final List<double> hourlyIntensity;
  final int maxSteps;

  const OrbitActivityGrid({
    super.key,
    required this.hourlyIntensity,
    this.maxSteps = 0,
  });

  @override
  State<OrbitActivityGrid> createState() => _OrbitActivityGridState();
}

class _OrbitActivityGridState extends State<OrbitActivityGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(OrbitActivityGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hourlyIntensity != widget.hourlyIntensity) {
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

    // Ensure we have 24 values
    final data = List<double>.generate(24, (i) {
      if (i < widget.hourlyIntensity.length) {
        return widget.hourlyIntensity[i].clamp(0.0, 1.0);
      }
      return 0.0;
    });

    final maxVal = data.reduce(max);

    return Column(
      children: [
        // Y-axis labels + grid
        SizedBox(
          height: 160,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Y-axis labels
              if (widget.maxSteps > 0)
                SizedBox(
                  width: 30,
                  height: 160,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatK(widget.maxSteps),
                        style: TextStyle(
                          fontSize: 9,
                          color: colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                      Text(
                        _formatK(widget.maxSteps ~/ 2),
                        style: TextStyle(
                          fontSize: 9,
                          color: colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],
                  ),
                ),
              if (widget.maxSteps > 0) const SizedBox(width: 6),
              // Grid columns
              Expanded(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(24, (i) {
                        final normalizedHeight = maxVal > 0
                            ? (data[i] / maxVal).clamp(0.0, 1.0)
                            : 0.0;

                        // Stagger animation per column
                        final delay = i / 24;
                        final progress = (_controller.value - delay * 0.3)
                            .clamp(0.0, 1.0);

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            child: _ActivityColumn(
                              intensity: data[i],
                              height: normalizedHeight * progress,
                              accentColor: colorScheme.primary,
                              isDark: isDark,
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // X-axis labels
        Padding(
          padding: EdgeInsets.only(left: widget.maxSteps > 0 ? 36 : 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _axisLabel('12 AM', colorScheme),
              _axisLabel('6 AM', colorScheme),
              _axisLabel('12 PM', colorScheme),
              _axisLabel('6 PM', colorScheme),
              _axisLabel('12 AM', colorScheme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _axisLabel(String text, ColorScheme colorScheme) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 9,
        color: colorScheme.onSurface.withValues(alpha: 0.4),
      ),
    );
  }

  String _formatK(int value) {
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}K';
    return '$value';
  }
}

class _ActivityColumn extends StatelessWidget {
  final double intensity;
  final double height;
  final Color accentColor;
  final bool isDark;

  const _ActivityColumn({
    required this.intensity,
    required this.height,
    required this.accentColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final maxHeight = 140.0;
    final barHeight = max(height * maxHeight, height > 0 ? 4.0 : 0.0);

    // Color intensity based on value
    final opacity = (0.2 + intensity * 0.8).clamp(0.2, 1.0);

    return Container(
      height: barHeight,
      decoration: BoxDecoration(
        color: intensity > 0
            ? accentColor.withValues(alpha: opacity)
            : (isDark
                ? Colors.white.withValues(alpha: 0.04)
                : OrbitColors.warmGray100),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
