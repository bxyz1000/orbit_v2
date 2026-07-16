import 'package:flutter/material.dart';

class OrbitInfoTile extends StatelessWidget {
  final IconData? icon;
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? subtitleWidget;
  final TextStyle? titleStyle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final int? subtitleMaxLines;

  const OrbitInfoTile({
    super.key,
    this.icon,
    this.leading,
    required this.title,
    this.subtitle,
    this.subtitleWidget,
    this.titleStyle,
    this.trailing,
    this.onTap,
    this.subtitleMaxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: ListTile(
        leading: leading ?? (icon != null ? Icon(icon, size: 20) : null),
        title: Text(title, style: titleStyle),
        subtitle: subtitleWidget ??
            (subtitle != null
                ? Text(
                    subtitle!,
                    maxLines: subtitleMaxLines,
                    overflow: subtitleMaxLines != null
                        ? TextOverflow.ellipsis
                        : null,
                  )
                : null),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
