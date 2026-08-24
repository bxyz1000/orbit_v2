import 'package:flutter/animation.dart';
import 'package:flutter/services.dart';

/// Central motion & haptics policy for the Orbit design system.
/// One source of truth so every page shares the same feel.
class OrbitMotion {
  OrbitMotion._();

  // ── Durations ──
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration base = Duration(milliseconds: 250);
  static const Duration emphasized = Duration(milliseconds: 350);
  static const Duration hero = Duration(milliseconds: 1400);
  static const Duration glint = Duration(milliseconds: 900);

  // ── Curves ──
  static const Curve curve = Curves.easeOutCubic;
  static const Curve curveEmphasized = Curves.easeInOutCubic;

  // ── Haptics ──
  /// Subtle tick for selecting between peer items (day strip, carousel).
  static void selection() => HapticFeedback.selectionClick();

  /// Light tap for opening things (sheets, cards).
  static void light() => HapticFeedback.lightImpact();

  /// Confirmed action completed (pull-to-refresh settled).
  static void medium() => HapticFeedback.mediumImpact();
}
