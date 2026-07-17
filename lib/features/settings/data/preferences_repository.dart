import 'package:isar_community/isar.dart';
import '../domain/user_preferences.dart';

class PreferencesRepository {
  final Isar _isar;

  PreferencesRepository(this._isar);

  IsarCollection<UserPreferences> get _collection => _isar.collection<UserPreferences>();

  Future<UserPreferences> getPreferences() async {
    final prefs = await _collection.get(0);
    if (prefs == null) {
      final defaultPrefs = UserPreferences.defaultValues();
      await savePreferences(defaultPrefs);
      return defaultPrefs;
    }
    return prefs;
  }

  Future<void> savePreferences(UserPreferences prefs) async {
    await _isar.writeTxn(() async {
      await _collection.put(prefs);
    });
  }

  Stream<UserPreferences?> watchPreferences() => _collection.watchObject(0);
}
