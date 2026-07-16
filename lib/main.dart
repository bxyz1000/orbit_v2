import 'package:flutter/material.dart';
import 'app/orbit_app.dart';
import 'core/storage/isar_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final storageService = IsarStorage();
  try {
    await storageService.init();
  } catch (e) {
    debugPrint('Isar initialization failed: $e');
    // Fallback to in-memory if needed or handle error
  }

  runApp(OrbitApp(storageService: storageService));
}
