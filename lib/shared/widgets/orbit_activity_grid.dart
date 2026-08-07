import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/orbit_colors.dart';

/// Premium stacked square block activity grid visualization.
/// Inspired by wearable health reference — rounded copper intensity blocks.
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

    // Grid: 24 columns (hours) x 6 rows (intensity levels)
    const rows = 6;

    return Column(
      children: [
        // Activity label
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ACTIVITY',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
            Text(
              'Today',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Stacked square block grid
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return SizedBox(
              height: 120,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(24, (col) {
                  final intensity = data[col];
                  final normalizedHeight = maxVal > 0
                      ? (intensity / maxVal).clamp(0.0, 1.0)
                      : 0.0;

                  // Stagger animation per column
                  final delay = col / 30.0;
                  final progress =
                      (_controller.value - delay).clamp(0.0, 1.0);

                  // How many rows to fill based on intensity
                  final filledRows = intensity > 0
                      ? (normalizedHeight * rows * progress).ceil().clamp(1, rows)
                      : 0;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: List.generate(rows, (row) {
                          final rowFromBottom = rows - 1 - row;
                          final isActive = rowFromBottom < filledRows;

                          // Intensity fades toward the top
                          final cellOpacity = isActive
                              ? (0.3 + (rowFromBottom / filledRows) * 0.7)
                                  .clamp(0.3, 1.0)
                              : 0.0;

                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(0.5),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? colorScheme.primary
                                        .withValues(alpha: cellOpacity)
                                    : (isDark
                                        ? Colors.white.withValues(alpha: 0.03)
                                        : OrbitColors.warmGray100
                                            .withValues(alpha: 0.4)),
                                borderRadius: BorderRadius.circular(2.5),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  );
                }),
              ),
            );
          },
        ),
        const SizedBox(height: 8),

        // X-axis labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _axisLabel('12 AM', colorScheme),
            _axisLabel('6 AM', colorScheme),
            _axisLabel('12 PM', colorScheme),
            _axisLabel('6 PM', colorScheme),
            _axisLabel('12 AM', colorScheme),
          ],
        ),
      ],
    );
  }

  Widget _axisLabel(String text, ColorScheme colorScheme) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface.withValues(alpha: 0.35),
      ),
    );
  }
}
