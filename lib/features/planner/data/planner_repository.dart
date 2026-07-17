import 'package:isar_community/isar_community.dart';
import '../domain/planner_event.dart';

class PlannerRepository {
  final Isar _isar;

  PlannerRepository(this._isar);

  Future<List<PlannerEvent>> getAllEvents() async {
    return await _isar.plannerEvents.where().findAll();
  }

  Future<void> saveEvent(PlannerEvent event) async {
    await _isar.writeTxn(() async {
      await _isar.plannerEvents.put(event);
    });
  }

  Future<void> saveEvents(List<PlannerEvent> events) async {
    await _isar.writeTxn(() async {
      await _isar.plannerEvents.putAll(events);
    });
  }

  Future<void> deleteEvent(Id id) async {
    await _isar.writeTxn(() async {
      await _isar.plannerEvents.delete(id);
    });
  }

  Stream<void> watchEvents() => _isar.plannerEvents.watchLazy();
}
