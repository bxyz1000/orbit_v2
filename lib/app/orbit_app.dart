import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/orbit_theme.dart';
import 'app_shell.dart';
import '../features/settings/presentation/providers/preferences_providers.dart';

class OrbitApp extends ConsumerWidget {
  const OrbitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);

    return MaterialApp(
      title: 'Orbit',
      debugShowCheckedModeBanner: false,
      theme: OrbitTheme.light,
      darkTheme: OrbitTheme.dark,
      themeMode: themeMode,
      home: const AppShell(),
    );
  }
}
