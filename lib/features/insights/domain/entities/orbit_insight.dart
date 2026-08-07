import 'insight_priority.dart';
import 'insight_type.dart';

/// Immutable domain representation of a deterministic Orbit Insight.
class OrbitInsight {
  final String id;
  final InsightType type;
  final InsightPriority priority;
  final String title;
  final String description;
  final String? category;
  final double? currentValue;
  final double? previousValue;
  final double? change;
  final DateTime date;
  final Map<String, dynamic> supportingData;

  const OrbitInsight({
    required this.id,
    required this.type,
    required this.priority,
    required this.title,
    required this.description,
    this.category,
    this.currentValue,
    this.previousValue,
    this.change,
    required this.date,
    this.supportingData = const {},
  });
}
