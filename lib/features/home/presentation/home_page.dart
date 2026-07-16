import 'package:flutter/material.dart';
import '../../../app/app_shell.dart';
import '../../../core/storage/storage_service.dart';

class HomePage extends StatelessWidget {
  final StorageService storageService;

  const HomePage({
    super.key,
    required this.storageService,
  });

  @override
  Widget build(BuildContext context) {
    return AppShell(storageService: storageService);
  }
}
