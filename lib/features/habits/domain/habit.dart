import 'package:flutter/material.dart';
import 'package:isar_community/isar.dart';

part 'habit.g.dart';

@collection
class Habit {
  Id id = Isar.autoIncrement;

  late String title;
  late int iconCodePoint;
  late int colorValue;
  late bool completedToday;
  late int currentStreak;
  late int bestStreak;
  late DateTime createdAt;

  @ignore
  IconData get icon {
    return _getIconFromCodePoint(iconCodePoint);
  }

  set icon(IconData value) => iconCodePoint = value.codePoint;

  static IconData _getIconFromCodePoint(int codePoint) {
    // Explicit switch with constant values to ensure icon tree-shaking works correctly.
    // Each case must be a constant expression.
    if (codePoint == Icons.star.codePoint) return Icons.star;
    if (codePoint == Icons.favorite.codePoint) return Icons.favorite;
    if (codePoint == Icons.fitness_center.codePoint) return Icons.fitness_center;
    if (codePoint == Icons.book.codePoint) return Icons.book;
    if (codePoint == Icons.water_drop.codePoint) return Icons.water_drop;
    if (codePoint == Icons.wb_sunny.codePoint) return Icons.wb_sunny;
    if (codePoint == Icons.nightlight.codePoint) return Icons.nightlight;
    if (codePoint == Icons.self_improvement.codePoint) return Icons.self_improvement;
    if (codePoint == Icons.brush.codePoint) return Icons.brush;
    if (codePoint == Icons.code.codePoint) return Icons.code;
    if (codePoint == Icons.music_note.codePoint) return Icons.music_note;
    if (codePoint == Icons.restaurant.codePoint) return Icons.restaurant;
    
    return Icons.star;
  }

  @ignore
  Color get color => Color(colorValue);
  set color(Color value) => colorValue = value.value;

  Habit();

  Habit.create({
    required this.title,
    required IconData icon,
    required Color color,
    this.completedToday = false,
    this.currentStreak = 0,
    this.bestStreak = 0,
    DateTime? createdAt,
  }) {
    this.icon = icon;
    this.color = color;
    this.createdAt = createdAt ?? DateTime.now();
  }

  Habit copyWith({
    Id? id,
    String? title,
    IconData? icon,
    Color? color,
    bool? completedToday,
    int? currentStreak,
    int? bestStreak,
    DateTime? createdAt,
  }) {
    final habit = Habit()
      ..id = id ?? this.id
      ..title = title ?? this.title
      ..iconCodePoint = icon?.codePoint ?? this.iconCodePoint
      ..colorValue = color?.value ?? this.colorValue
      ..completedToday = completedToday ?? this.completedToday
      ..currentStreak = currentStreak ?? this.currentStreak
      ..bestStreak = bestStreak ?? this.bestStreak
      ..createdAt = createdAt ?? this.createdAt;
    return habit;
  }
}
