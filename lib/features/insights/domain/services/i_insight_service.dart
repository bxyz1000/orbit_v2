import '../entities/orbit_insight.dart';

/// Abstract service contract for generating deterministic Orbit insights.
abstract class IInsightService {
  /// Generates a prioritized list of daily insights for [date] (defaults to today).
  Future<List<OrbitInsight>> generateDailyInsights([DateTime? date]);

  /// Generates category-specific breakdown insights for [date] (defaults to today).
  Future<List<OrbitInsight>> generateCategoryInsights([DateTime? date]);
}
