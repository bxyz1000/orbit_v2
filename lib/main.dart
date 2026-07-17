import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/orbit_app.dart';
import 'core/database/isar_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await IsarDatabase.init();
  } catch (e) {
    debugPrint('Isar initialization failed: $e');
  }

  runApp(
    const ProviderScope(
      child: OrbitApp(),
    ),
  );
}
