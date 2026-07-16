import 'package:flutter/material.dart';
import '../../core/theme/orbit_radius.dart';

class OrbitGroupCard extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const OrbitGroupCard({
    super.key,
    required this.children,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? OrbitRadius.brMd,
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
