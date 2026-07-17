import 'package:flutter/material.dart';

class OrbitColors {
  // Common Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  // Accents (Light Blue)
  static const Color blue50 = Color(0xFFF0F7FF);
  static const Color blue100 = Color(0xFFE0EFFF);
  static const Color blue500 = Color(0xFF007AFF); // Apple-like Blue
  static const Color blue600 = Color(0xFF0062CC);

  // Grays (Linear-like)
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);
  static const Color gray950 = Color(0xFF030712);

  // Dark Mode Palette (70% Black/Dark Gray + 30% White)
  static const Color darkBackground = Color(0xFF0A0A0A);
  static const Color darkSurface = Color(0xFF141414);
  static const Color darkElevated = Color(0xFF1C1C1E);

  // Color Schemes
  static final lightColorScheme = ColorScheme.fromSeed(
    seedColor: blue500,
    brightness: Brightness.light,
    surface: white,
    onSurface: gray950,
    primary: blue500,
    onPrimary: white,
    secondary: gray900,
    onSecondary: white,
    error: Colors.redAccent,
    onError: white,
    outline: gray200,
  );

  static final darkColorScheme = ColorScheme.fromSeed(
    seedColor: blue500,
    brightness: Brightness.dark,
    surface: darkBackground,
    onSurface: Colors.white.withValues(alpha: 0.9),
    primary: blue500,
    onPrimary: white,
    secondary: Colors.white,
    onSecondary: black,
    error: Colors.redAccent,
    onError: white,
    outline: Colors.white24,
  ).copyWith(
    surface: darkBackground,
    onSurface: Colors.white.withValues(alpha: 0.9),
    surfaceContainerHighest: darkSurface,
  );
}
