import 'package:isar_community/isar.dart';
import '../domain/user_preferences.dart';

class PreferencesRepository {
  final Isar _isar;

  PreferencesRepository(this._isar);

  Future<UserPreferences> getPreferences() async {
    final prefs = await _isar.userPreferences.get(0);
    if (prefs == null) {
      final defaultPrefs = UserPreferences.defaultValues();
      await savePreferences(defaultPrefs);
      return defaultPrefs;
    }
    return prefs;
  }

  Future<void> savePreferences(UserPreferences prefs) async {
    await _isar.writeTxn(() async {
      await _isar.userPreferences.put(prefs);
    });
  }

  Stream<UserPreferences?> watchPreferences() => _isar.userPreferences.watchObject(0);
}
