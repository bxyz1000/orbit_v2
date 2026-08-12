import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/orbit_colors.dart';

/// Floating pill bottom navigation bar matching Image 3 & Image 4 pixel-for-pixel.
class OrbitBottomNav extends StatelessWidget {
  final int currentIndex;
  final bool isDarkSurface;
  final ValueChanged<int> onTap;

  const OrbitBottomNav({
    super.key,
    required this.currentIndex,
    required this.isDarkSurface,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final surface = isDarkSurface ? OrbitColors.darkElevated : const Color(0xFFF8F1EA);
    final border = isDarkSurface
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFE1D6CB).withValues(alpha: 0.7);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        bottomPadding > 0 ? bottomPadding + 10 : 18,
      ),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              height: 64,
              constraints: const BoxConstraints(maxWidth: 360),
              decoration: BoxDecoration(
                color: surface.withValues(alpha: isDarkSurface ? 0.92 : 0.96),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1C1816).withValues(alpha: isDarkSurface ? 0.10 : 0.06),
                    blurRadius: 28,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(color: border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NavItem(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    isSelected: currentIndex == 0,
                    isDarkSurface: isDarkSurface,
                    onTap: () => onTap(0),
                  ),
                  _NavItem(
                    icon: Icons.auto_awesome_rounded,
                    label: 'AI Assistant',
                    isSelected: currentIndex == 1,
                    isDarkSurface: isDarkSurface,
                    onTap: () => onTap(1),
                  ),
                  _NavItem(
                    icon: Icons.person_rounded,
                    label: 'Profile',
                    isSelected: currentIndex == 2,
                    isDarkSurface: isDarkSurface,
                    onTap: () => onTap(2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isDarkSurface;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isDarkSurface,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selectedColor = OrbitColors.copper500;
    final unselectedColor = isDarkSurface ? Colors.white54 : const Color(0xFF7D746B);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 21,
              color: isSelected ? selectedColor : unselectedColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? selectedColor : unselectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
