import 'package:flutter/material.dart';
import '../../core/theme/orbit_colors.dart';

/// Day / Week / Month period selector with animated pill indicator.
class OrbitPeriodSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final List<String> labels;

  const OrbitPeriodSelector({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
    this.labels = const ['Day', 'Week', 'Month'],
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : const Color(0xFFEDE6DF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final isSelected = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOutCubic,
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? OrbitColors.darkElevated : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    labels[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? colorScheme.onSurface
                          : colorScheme.onSurface.withValues(alpha: 0.42),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
