import 'package:flutter/material.dart';
import 'orbit_colors.dart';

class OrbitGradients {
  /// Hero score meter background gradient (warm copper arc)
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      OrbitColors.copper300,
      OrbitColors.copper500,
      OrbitColors.copper700,
    ],
  );

  /// Soft copper glow behind score
  static const RadialGradient scoreGlow = RadialGradient(
    center: Alignment.center,
    radius: 0.8,
    colors: [
      Color(0x30D4885C),
      Color(0x00D4885C),
    ],
  );

  /// Feature card overlay gradient
  static const LinearGradient cardOverlay = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x08D4885C),
      Color(0x03D4885C),
    ],
  );

  /// Warm surface gradient for premium backgrounds
  static const LinearGradient warmSurface = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      OrbitColors.warmWhite,
      OrbitColors.cream,
    ],
  );

  /// Glass effect gradient
  static const LinearGradient glass = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x20FFFFFF),
      Color(0x08FFFFFF),
    ],
  );

  /// Bottom nav gradient background
  static const LinearGradient navBar = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x00F5F0EB),
      Color(0xFFF5F0EB),
    ],
  );

  /// Strava brand gradient
  static const LinearGradient strava = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFC4C02),
      Color(0xFFE34402),
    ],
  );

  /// Dark mode hero gradient
  static const LinearGradient heroDark = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFE8A878),
      Color(0xFFD4885C),
      Color(0xFF9A5F3C),
    ],
  );
}
