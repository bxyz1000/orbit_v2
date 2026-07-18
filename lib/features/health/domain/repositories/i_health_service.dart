import '../entities/health_snapshot.dart';

abstract class IHealthService {
  Future<bool> isAuthorized();
  Future<bool> requestAuthorization();
  Future<HealthSnapshot> getHealthSnapshot(DateTime date);
}
