import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/preferences_repository.dart';
import '../../domain/user_preferences.dart';
import '../../../../core/database/isar_database.dart';
import 'package:flutter/material.dart';

final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  return PreferencesRepository(IsarDatabase.instance);
});

// Use a FutureProvider to get the initial value and then transition to watching changes
final userPreferencesProvider = FutureProvider<UserPreferences>((ref) async {
  final repo = ref.watch(preferencesRepositoryProvider);
  
  // We want to return a value immediately and then react to changes.
  // A clean way is to watch the stream but provide the initial future value.
  final initial = await repo.getPreferences();
  
  // We can use ref.listen to the repository's watch stream to invalidate if needed,
  // or just use a StreamProvider. Since we had issues with loading, 
  // let's ensure it resolves.
  
  return initial;
});

// A stream provider for real-time updates that doesn't block initial load
final userPreferencesStreamProvider = StreamProvider<UserPreferences>((ref) {
  final repo = ref.watch(preferencesRepositoryProvider);
  return repo.watchPreferences().map((event) => event ?? UserPreferences.defaultValues());
});

final appThemeModeProvider = Provider<ThemeMode>((ref) {
  final prefsAsync = ref.watch(userPreferencesStreamProvider);
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
      // Invalidate the future provider to refresh other listeners
      ref.invalidate(userPreferencesProvider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final currentPrefs = state.value ?? await ref.read(preferencesRepositoryProvider).getPreferences();
    final newPrefs = currentPrefs.copyWith(themeMode: mode.name);
    await updatePreferences(newPrefs);
  }
}

final preferencesNotifierProvider = NotifierProvider<PreferencesNotifier, AsyncValue<UserPreferences>>(() {
  return PreferencesNotifier();
});
