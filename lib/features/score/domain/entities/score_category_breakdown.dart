/// Representation of a single category's scoring breakdown in Score Engine V2.
class ScoreCategoryBreakdown {
  final String categoryName;
  final double rawValue;
  final double normalizedValue; // 0.0 to 100.0
  final double weightedContribution; // Point contribution to final score
  final double maxContribution; // Maximum points this category can contribute
  final bool isActive; // false if integration or hardware is unavailable
  final String explanation;

  const ScoreCategoryBreakdown({
    required this.categoryName,
    required this.rawValue,
    required this.normalizedValue,
    required this.weightedContribution,
    required this.maxContribution,
    required this.isActive,
    required this.explanation,
  });
}
