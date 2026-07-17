import 'package:flutter/material.dart';
import 'package:isar_community/isar_community.dart';

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
  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');
  set icon(IconData value) => iconCodePoint = value.codePoint;

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
