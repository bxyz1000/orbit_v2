import 'package:flutter/material.dart';
import '../core/theme/orbit_theme.dart';
import '../core/storage/storage_service.dart';
import '../features/home/presentation/home_page.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

class OrbitApp extends StatelessWidget {
  final StorageService storageService;

  const OrbitApp({
    super.key,
    required this.storageService,
  });

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
          home: HomePage(storageService: storageService),
        );
      },
    );
  }
}
