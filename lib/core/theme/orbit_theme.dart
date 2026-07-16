import 'package:flutter/material.dart';
import 'orbit_colors.dart';
import 'orbit_spacing.dart';
import 'orbit_radius.dart';
import 'orbit_typography.dart';

class OrbitAnimations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 600);

  static const Curve curve = Curves.easeInOutCubic;
  static const Curve emphasizedCurve = Cubic(0.2, 0, 0, 1);
}

class OrbitTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: OrbitColors.lightColorScheme,
      textTheme: OrbitTypography.textTheme,
      scaffoldBackgroundColor: OrbitColors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: OrbitColors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: OrbitColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: OrbitRadius.brMd,
          side: const BorderSide(color: OrbitColors.gray200, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: OrbitColors.gray50,
        border: OutlineInputBorder(
          borderRadius: OrbitRadius.brMd,
          borderSide: BorderSide(color: OrbitColors.gray200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: OrbitRadius.brMd,
          borderSide: BorderSide(color: OrbitColors.gray200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: OrbitRadius.brMd,
          borderSide: BorderSide(color: OrbitColors.blue500, width: 2),
        ),
      ),
      extensions: [
        OrbitSpacingExtension.light,
        OrbitRadiusExtension.light,
      ],
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      colorScheme: OrbitColors.darkColorScheme,
      textTheme: OrbitTypography.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      scaffoldBackgroundColor: OrbitColors.darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: OrbitColors.darkBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: OrbitColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: OrbitRadius.brMd,
          side: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: OrbitColors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: OrbitRadius.brMd,
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: OrbitRadius.brMd,
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: OrbitRadius.brMd,
          borderSide: const BorderSide(color: OrbitColors.blue500, width: 2),
        ),
      ),
      extensions: [
        OrbitSpacingExtension.dark,
        OrbitRadiusExtension.dark,
      ],
    );
  }
}

class OrbitSpacingExtension extends ThemeExtension<OrbitSpacingExtension> {
  final double padding;
  final double elementGap;

  const OrbitSpacingExtension({
    required this.padding,
    required this.elementGap,
  });

  static const light = OrbitSpacingExtension(
    padding: OrbitSpacing.padding,
    elementGap: OrbitSpacing.elementGap,
  );

  static const dark = OrbitSpacingExtension(
    padding: OrbitSpacing.padding,
    elementGap: OrbitSpacing.elementGap,
  );

  @override
  ThemeExtension<OrbitSpacingExtension> copyWith({
    double? padding,
    double? elementGap,
  }) {
    return OrbitSpacingExtension(
      padding: padding ?? this.padding,
      elementGap: elementGap ?? this.elementGap,
    );
  }

  @override
  ThemeExtension<OrbitSpacingExtension> lerp(
    covariant ThemeExtension<OrbitSpacingExtension>? other,
    double t,
  ) {
    if (other is! OrbitSpacingExtension) return this;
    return OrbitSpacingExtension(
      padding: _lerpDouble(padding, other.padding, t) ?? padding,
      elementGap: _lerpDouble(elementGap, other.elementGap, t) ?? elementGap,
    );
  }
}

class OrbitRadiusExtension extends ThemeExtension<OrbitRadiusExtension> {
  final double sm;
  final double md;
  final double lg;

  const OrbitRadiusExtension({
    required this.sm,
    required this.md,
    required this.lg,
  });

  static const light = OrbitRadiusExtension(
    sm: OrbitRadius.sm,
    md: OrbitRadius.md,
    lg: OrbitRadius.lg,
  );

  static const dark = OrbitRadiusExtension(
    sm: OrbitRadius.sm,
    md: OrbitRadius.md,
    lg: OrbitRadius.lg,
  );

  @override
  ThemeExtension<OrbitRadiusExtension> copyWith({
    double? sm,
    double? md,
    double? lg,
  }) {
    return OrbitRadiusExtension(
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
    );
  }

  @override
  ThemeExtension<OrbitRadiusExtension> lerp(
    covariant ThemeExtension<OrbitRadiusExtension>? other,
    double t,
  ) {
    if (other is! OrbitRadiusExtension) return this;
    return OrbitRadiusExtension(
      sm: _lerpDouble(sm, other.sm, t) ?? sm,
      md: _lerpDouble(md, other.md, t) ?? md,
      lg: _lerpDouble(lg, other.lg, t) ?? lg,
    );
  }
}

double? _lerpDouble(double? a, double? b, double t) {
  if (a == null && b == null) return null;
  a ??= 0.0;
  b ??= 0.0;
  return a + (b - a) * t;
}
