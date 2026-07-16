import 'package:flutter/material.dart';

class OrbitRadius {
  static const double none = 0;
  static const double xs = 4;
  static const double sm = 8; // Small buttons, tags
  static const double md = 12; // Cards, Input fields
  static const double lg = 16; // Large cards, modals
  static const double xl = 24; // Containers
  static const double circular = 999;

  // BorderRadius objects
  static const BorderRadius brXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius brSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius brMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius brLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius brXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius brCircular = BorderRadius.all(Radius.circular(circular));
}
