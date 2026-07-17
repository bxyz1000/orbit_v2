import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/preferences_repository.dart';
import '../../domain/user_preferences.dart';
import '../../../../core/database/isar_database.dart';
import 'package:flutter/material.dart';

final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  return PreferencesRepository(IsarDatabase.instance);
});

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

class PreferencesNotifier extends StateNotifier<AsyncValue<UserPreferences>> {
  final PreferencesRepository _repository;

  PreferencesNotifier(this._repository) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    state = const AsyncValue.loading();
    try {
      final prefs = await _repository.getPreferences();
      state = AsyncValue.data(prefs);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updatePreferences(UserPreferences prefs) async {
    try {
      await _repository.savePreferences(prefs);
      state = AsyncValue.data(prefs);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (state.hasValue) {
      final modeString = mode.name;
      final newPrefs = state.value!.copyWith(themeMode: modeString);
      await updatePreferences(newPrefs);
    }
  }
}

final preferencesNotifierProvider = StateNotifierProvider<PreferencesNotifier, AsyncValue<UserPreferences>>((ref) {
  return PreferencesNotifier(ref.watch(preferencesRepositoryProvider));
});
