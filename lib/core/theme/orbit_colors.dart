import 'package:flutter/material.dart';

class OrbitColors {
  // Common Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  // ─── Warm Copper Accent Palette ───
  static const Color copper50 = Color(0xFFFFF5EE);
  static const Color copper100 = Color(0xFFFFE8D6);
  static const Color copper200 = Color(0xFFFFD4B0);
  static const Color copper300 = Color(0xFFE8A878);
  static const Color copper400 = Color(0xFFD4885C);
  static const Color copper500 = Color(0xFFCC7A4A); // Primary Orbit Copper
  static const Color copper600 = Color(0xFFB8734A);
  static const Color copper700 = Color(0xFF9A5F3C);
  static const Color copper800 = Color(0xFF7A4B2E);
  static const Color copper900 = Color(0xFF5C3822);

  // ─── Warm Neutrals ───
  static const Color warmWhite = Color(0xFFFFFAF5);
  static const Color cream = Color(0xFFF8F2EB);
  static const Color warmGray50 = Color(0xFFF5F0EB);
  static const Color warmGray100 = Color(0xFFEDE6DE);
  static const Color warmGray200 = Color(0xFFDDD5CC);
  static const Color warmGray300 = Color(0xFFC4BAB0);
  static const Color warmGray400 = Color(0xFFA69A8E);
  static const Color warmGray500 = Color(0xFF8A7E72);
  static const Color warmGray600 = Color(0xFF6E645A);
  static const Color warmGray700 = Color(0xFF524A42);
  static const Color warmGray800 = Color(0xFF362F28);
  static const Color warmGray900 = Color(0xFF1C1816);

  // ─── Semantic Colors ───
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF42A5F5);

  // ─── Dark Mode Palette ───
  static const Color darkBackground = Color(0xFF121010);
  static const Color darkSurface = Color(0xFF1C1816);
  static const Color darkElevated = Color(0xFF262220);

  // ─── Color Schemes ───
  static final lightColorScheme = ColorScheme.fromSeed(
    seedColor: copper500,
    brightness: Brightness.light,
    surface: warmWhite,
    onSurface: warmGray900,
    primary: copper500,
    onPrimary: white,
    secondary: warmGray800,
    onSecondary: white,
    error: error,
    onError: white,
    outline: warmGray200,
  ).copyWith(
    surfaceContainerHighest: cream,
    primaryContainer: copper100,
    onPrimaryContainer: copper800,
    secondaryContainer: warmGray100,
    onSecondaryContainer: warmGray800,
  );

  static final darkColorScheme = ColorScheme.fromSeed(
    seedColor: copper400,
    brightness: Brightness.dark,
    surface: darkBackground,
    onSurface: Colors.white.withValues(alpha: 0.9),
    primary: copper400,
    onPrimary: white,
    secondary: Colors.white,
    onSecondary: black,
    error: error,
    onError: white,
    outline: Colors.white24,
  ).copyWith(
    surface: darkBackground,
    onSurface: Colors.white.withValues(alpha: 0.9),
    surfaceContainerHighest: darkSurface,
    primaryContainer: copper800,
    onPrimaryContainer: copper200,
  );
}
