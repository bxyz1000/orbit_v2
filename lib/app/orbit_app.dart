import 'package:flutter/material.dart';
import '../core/theme/orbit_theme.dart';
import '../features/home/presentation/home_page.dart';

// Simple global notifier for theme state
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

class OrbitApp extends StatelessWidget {
  const OrbitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) {
        return MaterialApp(
          title: 'Orbit',
          debugShowCheckedModeBanner: false,
          theme: OrbitTheme.light,
          darkTheme: OrbitTheme.dark,
          themeMode: mode,
          home: const HomePage(),
        );
      },
    );
  }
}
