import 'package:flutter/material.dart';
import 'package:isar_community/isar_community.dart';

part 'planner_event.g.dart';

@collection
class PlannerEvent {
  Id id = Isar.autoIncrement;

  late DateTime date;
  late String startTime;
  late String endTime;
  late String title;
  String? description;
  bool isCompleted = false;
  
  @ignore
  Color get color => Color(colorValue);
  set color(Color value) => colorValue = value.value;

  late int colorValue;

  PlannerEvent();

  PlannerEvent.create({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.title,
    this.description,
    required Color color,
  }) {
    this.color = color;
  }

  PlannerEvent copyWith({
    Id? id,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? title,
    String? description,
    Color? color,
  }) {
    final event = PlannerEvent()
      ..id = id ?? this.id
      ..date = date ?? this.date
      ..startTime = startTime ?? this.startTime
      ..endTime = endTime ?? this.endTime
      ..title = title ?? this.title
      ..description = description ?? this.description
      ..color = color ?? this.color;
    return event;
  }
}
