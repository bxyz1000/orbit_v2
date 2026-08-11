import '../entities/health_snapshot.dart';
import '../entities/health_sample.dart';

abstract class IHealthService {
  Future<bool> isAuthorized();
  Future<bool> requestAuthorization();
  Future<HealthSnapshot> getHealthSnapshot(DateTime date);
  Future<List<HeartRateSample>> getHeartRateSamples(DateTime date);
  Future<List<double>> getHourlyStepIntensity(DateTime date);
}
