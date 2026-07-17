import 'package:isar_community/isar_community.dart';
import '../domain/focus_session.dart';

class FocusRepository {
  final Isar _isar;

  FocusRepository(this._isar);

  Future<List<FocusSession>> getAllSessions() async {
    return await _isar.focusSessions.where().sortByStartedAtDesc().findAll();
  }

  Future<List<FocusSession>> getTodaySessions() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    return await _isar.focusSessions
        .filter()
        .startedAtGreaterThan(todayStart)
        .sortByStartedAtDesc()
        .findAll();
  }

  Future<void> saveSession(FocusSession session) async {
    await _isar.writeTxn(() async {
      await _isar.focusSessions.put(session);
    });
  }

  Future<void> deleteSession(Id id) async {
    await _isar.writeTxn(() async {
      await _isar.focusSessions.delete(id);
    });
  }

  Stream<void> watchSessions() => _isar.focusSessions.watchLazy();
}
