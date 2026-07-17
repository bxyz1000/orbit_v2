class Achievement {
  final String achievementId;
  final String title;
  final String description;
  final String category;
  final String tier;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  Achievement({
    required this.achievementId,
    required this.title,
    required this.description,
    required this.category,
    required this.tier,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  Achievement copyWith({
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      achievementId: achievementId,
      title: title,
      description: description,
      category: category,
      tier: tier,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  static Achievement create({
    required String achievementId,
    required String title,
    required String description,
    required String category,
    required String tier,
    bool isUnlocked = false,
  }) {
    return Achievement(
      achievementId: achievementId,
      title: title,
      description: description,
      category: category,
      tier: tier,
      isUnlocked: isUnlocked,
    );
  }
}
