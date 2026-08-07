import 'package:flutter/material.dart';

class OrbitShadows {
  /// Subtle card shadow
  static List<BoxShadow> get card => [
    BoxShadow(
      color: const Color(0xFF1C1816).withValues(alpha: 0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: const Color(0xFF1C1816).withValues(alpha: 0.02),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  /// Elevated card shadow (feature cards, hero elements)
  static List<BoxShadow> get elevated => [
    BoxShadow(
      color: const Color(0xFF1C1816).withValues(alpha: 0.06),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: const Color(0xFF1C1816).withValues(alpha: 0.03),
      blurRadius: 32,
      offset: const Offset(0, 12),
    ),
  ];

  /// Bottom navigation bar shadow
  static List<BoxShadow> get navBar => [
    BoxShadow(
      color: const Color(0xFF1C1816).withValues(alpha: 0.08),
      blurRadius: 24,
      offset: const Offset(0, -4),
    ),
  ];

  /// Soft glow for score meter
  static List<BoxShadow> scoreGlow(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.25),
      blurRadius: 32,
      spreadRadius: 4,
    ),
  ];

  /// Glass card shadow
  static List<BoxShadow> get glass => [
    BoxShadow(
      color: const Color(0xFF1C1816).withValues(alpha: 0.05),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
}
