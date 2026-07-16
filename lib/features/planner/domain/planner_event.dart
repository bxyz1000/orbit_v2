import 'package:flutter/material.dart';
import 'package:isar_community/isar_community.dart';

part 'planner_event.g.dart';

@collection
class PlannerEvent {
  Id id = Isar.autoIncrement;

  late String time;
  late String title;
  
  @ignore
  Color get color => Color(colorValue);
  set color(Color value) => colorValue = value.value;

  late int colorValue;

  PlannerEvent();

  PlannerEvent.create({
    required this.time,
    required this.title,
    required Color color,
  }) {
    this.color = color;
  }
}
