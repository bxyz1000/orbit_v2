import 'package:flutter/material.dart';

/// Dot page indicator for the 3-page horizontal pager.
class OrbitPageIndicator extends StatelessWidget {
  final int pageCount;
  final int currentPage;

  const OrbitPageIndicator({
    super.key,
    required this.pageCount,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(pageCount, (index) {
        final isActive = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: isActive
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.15),
          ),
        );
      }),
    );
  }
}
