import 'package:flutter/material.dart';
import '../../../../core/theme/orbit_colors.dart';
import '../../../../core/theme/orbit_shadows.dart';
import '../providers/health_providers.dart';

class OrbitHealthMetricCard extends StatelessWidget {
  final String title;
  final String metricValue;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;
  final HealthMetricStatus status;
  final VoidCallback? onTap;
  final VoidCallback? onConnectTap;
  final Widget? customContent;

  const OrbitHealthMetricCard({
    super.key,
    required this.title,
    required this.metricValue,
    this.subtitle,
    required this.icon,
    required this.iconColor,
    this.status = HealthMetricStatus.available,
    this.onTap,
    this.onConnectTap,
    this.customContent,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? OrbitColors.darkElevated : OrbitColors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: OrbitShadows.card,
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : OrbitColors.warmGray200.withValues(alpha: 0.4),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: status == HealthMetricStatus.available ? onTap : onConnectTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: iconColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icon, color: iconColor, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                    _buildStatusBadge(context),
                  ],
                ),
                const SizedBox(height: 14),

                // Main Content depending on status
                _buildBodyContent(context, colorScheme),

                if (customContent != null && status == HealthMetricStatus.available) ...[
                  const SizedBox(height: 12),
                  customContent!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    switch (status) {
      case HealthMetricStatus.loading:
        return const SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(strokeWidth: 2, color: OrbitColors.copper500),
        );
      case HealthMetricStatus.notConnected:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: OrbitColors.copper500.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Not Connected',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: OrbitColors.copper500),
          ),
        );
      case HealthMetricStatus.permissionRequired:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Permission Required',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.amber),
          ),
        );
      case HealthMetricStatus.error:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Error',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.redAccent),
          ),
        );
      case HealthMetricStatus.noData:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'No Data',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey),
          ),
        );
      case HealthMetricStatus.available:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBodyContent(BuildContext context, ColorScheme colorScheme) {
    if (status == HealthMetricStatus.notConnected || status == HealthMetricStatus.permissionRequired) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Connect Health Connect',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap to grant permission and enable real-time $title tracking.',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      );
    }

    if (status == HealthMetricStatus.noData) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No Data Recorded',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          metricValue,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: colorScheme.onSurface,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ],
    );
  }
}
