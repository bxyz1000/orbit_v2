import 'package:flutter/material.dart';
import '../../domain/entities/integration.dart';
import '../../../../core/theme/orbit_spacing.dart';

class IntegrationListItem extends StatelessWidget {
  final Integration integration;
  final VoidCallback? onTap;

  const IntegrationListItem({
    super.key,
    required this.integration,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      onTap: integration.isSupported ? onTap : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: OrbitSpacing.lg, vertical: 4),
      leading: _buildIcon(colorScheme),
      title: Text(
        integration.name,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: integration.isSupported ? null : colorScheme.onSurface.withOpacity(0.5),
        ),
      ),
      subtitle: _buildSubtitle(theme, colorScheme),
      trailing: _buildTrailing(colorScheme),
    );
  }

  Widget _buildIcon(ColorScheme colorScheme) {
    IconData iconData;
    Color iconColor;

    switch (integration.id) {
      case 'health_connect':
        iconData = Icons.health_and_safety;
        iconColor = Colors.green;
        break;
      case 'strava':
        iconData = Icons.directions_run;
        iconColor = Colors.orange;
        break;
      case 'apple_health':
        iconData = Icons.favorite;
        iconColor = Colors.red;
        break;
      case 'google_calendar':
        iconData = Icons.calendar_today;
        iconColor = Colors.blue;
        break;
      default:
        iconData = Icons.integration_instructions;
        iconColor = colorScheme.primary;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: integration.isSupported ? iconColor : Colors.grey,
        size: 24,
      ),
    );
  }

  Widget _buildSubtitle(ThemeData theme, ColorScheme colorScheme) {
    if (!integration.isSupported) {
      return Text(
        'Coming Soon',
        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
      );
    }

    String statusText;
    IconData statusIcon;
    Color statusColor;

    switch (integration.status) {
      case IntegrationStatus.connected:
        statusText = 'Connected';
        statusIcon = Icons.check_circle;
        statusColor = Colors.green;
        break;
      case IntegrationStatus.syncing:
        statusText = 'Syncing';
        statusIcon = Icons.sync;
        statusColor = Colors.amber;
        break;
      case IntegrationStatus.error:
        statusText = 'Error';
        statusIcon = Icons.error;
        statusColor = Colors.red;
        break;
      case IntegrationStatus.notConnected:
        statusText = 'Not Connected';
        statusIcon = Icons.radio_button_unchecked;
        statusColor = colorScheme.onSurface.withOpacity(0.4);
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(statusIcon, size: 12, color: statusColor),
            const SizedBox(width: 4),
            Text(
              statusText,
              style: theme.textTheme.bodySmall?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (integration.status == IntegrationStatus.connected && integration.lastSync != null) ...[
          const SizedBox(height: 2),
          Text(
            'Last Sync: ${_formatLastSync(integration.lastSync!)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ],
    );
  }

  Widget? _buildTrailing(ColorScheme colorScheme) {
    if (!integration.isSupported) return null;

    if (integration.status == IntegrationStatus.notConnected) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Connect',
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          Icon(Icons.chevron_right, size: 16, color: colorScheme.primary),
        ],
      );
    }

    return const Icon(Icons.chevron_right, size: 20);
  }

  String _formatLastSync(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final syncDate = DateTime(time.year, time.month, time.day);

    String dateStr;
    if (syncDate == today) {
      dateStr = 'Today';
    } else if (syncDate == today.subtract(const Duration(days: 1))) {
      dateStr = 'Yesterday';
    } else {
      dateStr = '${time.day}/${time.month}';
    }

    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final minute = time.minute.toString().padLeft(2, '0');

    return '$dateStr • $hour:$minute $period';
  }
}
