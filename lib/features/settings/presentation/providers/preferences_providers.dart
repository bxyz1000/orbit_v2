import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/preferences_repository.dart';
import '../../domain/user_preferences.dart';
import '../../../../core/database/isar_database.dart';
import 'package:flutter/material.dart';

final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  return PreferencesRepository(IsarDatabase.instance);
});

// StreamProvider remains to watch the database changes reactively
final userPreferencesProvider = StreamProvider<UserPreferences>((ref) {
  final repo = ref.watch(preferencesRepositoryProvider);
  return repo.watchPreferences().map((event) => event ?? UserPreferences.defaultValues());
});

final appThemeModeProvider = StateProvider<ThemeMode>((ref) {
  final prefsAsync = ref.watch(userPreferencesProvider);
  return prefsAsync.when(
    data: (prefs) {
      switch (prefs.themeMode) {
        case 'light': return ThemeMode.light;
        case 'dark': return ThemeMode.dark;
        default: return ThemeMode.system;
      }
    },
    loading: () => ThemeMode.system,
    error: (_, __) => ThemeMode.system,
  );
});

// Refactored to Notifier for better compatibility with Riverpod 3.0.3
class PreferencesNotifier extends Notifier<AsyncValue<UserPreferences>> {
  @override
  AsyncValue<UserPreferences> build() {
    _load();
    return const AsyncValue.loading();
  }

  Future<void> _load() async {
    try {
      final prefs = await ref.read(preferencesRepositoryProvider).getPreferences();
      state = AsyncValue.data(prefs);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updatePreferences(UserPreferences prefs) async {
    try {
      await ref.read(preferencesRepositoryProvider).savePreferences(prefs);
      state = AsyncValue.data(prefs);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final currentPrefs = state.value;
    if (currentPrefs != null) {
      final newPrefs = currentPrefs.copyWith(themeMode: mode.name);
      await updatePreferences(newPrefs);
    }
  }
}

final preferencesNotifierProvider = NotifierProvider<PreferencesNotifier, AsyncValue<UserPreferences>>(() {
  return PreferencesNotifier();
});
