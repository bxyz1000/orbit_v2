import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/orbit_colors.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../core/theme/orbit_radius.dart';
import '../../../shared/widgets/orbit_section_header.dart';
import '../../../shared/widgets/orbit_info_tile.dart';
import '../../../shared/widgets/orbit_group_card.dart';
import 'providers/preferences_providers.dart';
import '../../integrations/domain/entities/integration.dart';
import '../../integrations/presentation/providers/integration_providers.dart';
import '../../integrations/presentation/widgets/integration_list_item.dart';
import '../../integrations/presentation/pages/integration_detail_page.dart';
import '../../health/presentation/providers/health_providers.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(userPreferencesProvider);
    final integrationsAsync = ref.watch(integrationsStreamProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: prefsAsync.when(
        data: (prefs) => SingleChildScrollView(
          padding: const EdgeInsets.all(OrbitSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGeneralSection(textTheme, colorScheme, ref, prefs),
              OrbitSpacing.gapXl,
              _buildPrivacySection(context, textTheme, colorScheme, ref),
              OrbitSpacing.gapXl,
              _buildConnectionsSection(context, ref, textTheme, colorScheme, integrationsAsync),
              OrbitSpacing.gapXl,
              _buildSupportSection(context, textTheme, colorScheme),
              OrbitSpacing.gapXxl,
              Center(
                child: Text(
                  'Orbit 0.1.0+1',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
              OrbitSpacing.gapXxl,
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildConnectionsSection(
    BuildContext context,
    WidgetRef ref,
    TextTheme textTheme,
    ColorScheme colorScheme,
    AsyncValue<List<Integration>> integrationsAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: OrbitSpacing.sm, bottom: OrbitSpacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OrbitSectionHeader(
                title: 'Connections',
                titleStyle: textTheme.titleSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              integrationsAsync.when(
                data: (integrations) {
                  final connected = integrations.where((i) => i.status == IntegrationStatus.connected).length;
                  return Text(
                    'Connected: $connected / ${integrations.length}',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  );
                },
                loading: () => const SizedBox(),
                error: (_, _) => const SizedBox(),
              ),
            ],
          ),
        ),
        OrbitGroupCard(
          borderRadius: OrbitRadius.brLg,
          children: integrationsAsync.when(
            data: (integrations) => integrations.asMap().entries.map((entry) {
              final index = entry.key;
              final integration = entry.value;
              final isLast = index == integrations.length - 1;

              return Column(
                children: [
                  IntegrationListItem(
                    integration: integration,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => IntegrationDetailPage(integrationId: integration.id),
                        ),
                      );
                    },
                  ),
                  if (!isLast) const Divider(height: 1, indent: 72),
                ],
              );
            }).toList(),
            loading: () => [const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()))],
            error: (e, _) => [Padding(padding: const EdgeInsets.all(16.0), child: Text('Error: $e'))],
          ),
        ),
      ],
    );
  }

  Widget _buildGeneralSection(TextTheme textTheme, ColorScheme colorScheme, WidgetRef ref, dynamic prefs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: OrbitSpacing.sm, bottom: OrbitSpacing.sm),
          child: OrbitSectionHeader(
            title: 'General',
            titleStyle: textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        OrbitGroupCard(
          borderRadius: OrbitRadius.brLg,
          children: [
            OrbitInfoTile(
              icon: Icons.language_outlined,
              title: 'Language',
              trailing: Text(
                prefs.language,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            const Divider(height: 1, indent: 56),
            OrbitInfoTile(
              icon: Icons.palette_outlined,
              title: 'Theme',
              trailing: Text(
                prefs.themeMode[0].toUpperCase() + prefs.themeMode.substring(1),
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            const Divider(height: 1, indent: 56),
            OrbitInfoTile(
              icon: Icons.notifications_none_outlined,
              title: 'Notifications',
              trailing: Switch(
                value: prefs.notificationsEnabled,
                onChanged: (v) => ref.read(preferencesNotifierProvider.notifier).updatePreferences(
                  prefs.copyWith(notificationsEnabled: v)
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// PRIVACY — every tile does something real: live storage facts and
  /// live permission status with a deep-link to system settings.
  Widget _buildPrivacySection(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
    WidgetRef ref,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: OrbitSpacing.sm,
            bottom: OrbitSpacing.sm,
          ),
          child: OrbitSectionHeader(
            title: 'Privacy',
            titleStyle: textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        OrbitGroupCard(
          borderRadius: OrbitRadius.brLg,
          children: [
            OrbitInfoTile(
              icon: Icons.storage_outlined,
              title: 'Local Storage',
              subtitle: 'All data stays on this device',
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: () => _showStorageDialog(context, colorScheme),
            ),
            const Divider(height: 1, indent: 56),
            OrbitInfoTile(
              icon: Icons.security_outlined,
              title: 'Permissions',
              subtitle: 'Health Connect & system access',
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: () => _showPermissionsDialog(context, colorScheme, ref),
            ),
          ],
        ),
      ],
    );
  }

  /// SUPPORT — real content, real version, no dead ends.
  Widget _buildSupportSection(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: OrbitSpacing.sm,
            bottom: OrbitSpacing.sm,
          ),
          child: OrbitSectionHeader(
            title: 'Support',
            titleStyle: textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        OrbitGroupCard(
          borderRadius: OrbitRadius.brLg,
          children: [
            OrbitInfoTile(
              icon: Icons.help_outline,
              title: 'Help Center',
              subtitle: 'How Orbit works',
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: () => _showHelpSheet(context),
            ),
            const Divider(height: 1, indent: 56),
            OrbitInfoTile(
              icon: Icons.info_outline,
              title: 'About Orbit',
              subtitle: 'Version 0.1.0+1',
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: () => _showAboutDialog(context, colorScheme),
            ),
          ],
        ),
      ],
    );
  }

  void _showStorageDialog(BuildContext context, ColorScheme colorScheme) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Local Storage'),
        content: Text(
          'Orbit is local-first. Your tasks, habits, focus sessions, planner '
          'events, notes, goals, health data and Strava activities are stored '
          'in an Isar database on this device only.\n\n'
          'Nothing is uploaded to a server. Uninstalling the app removes all '
          'of your data with it.',
          style: TextStyle(
            height: 1.45,
            color: colorScheme.onSurface.withValues(alpha: 0.85),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showPermissionsDialog(
    BuildContext context,
    ColorScheme colorScheme,
    WidgetRef ref,
  ) {
    final healthAuthAsync = ref.watch(healthAuthorizationProvider);
    final healthConnected = healthAuthAsync.asData?.value ?? false;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Permissions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  healthConnected
                      ? Icons.check_circle_rounded
                      : Icons.error_outline_rounded,
                  size: 18,
                  color: healthConnected ? Colors.green : OrbitColors.copper500,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    healthConnected
                        ? 'Health Connect — connected'
                        : 'Health Connect — not connected',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              healthConnected
                  ? 'Steps, distance and sleep are syncing.'
                  : 'Grant access from the Steps page to enable health scoring.',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () async {
              await openAppSettings();
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: const Text('System settings'),
          ),
        ],
      ),
    );
  }
}

// __S3__

void _showHelpSheet(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) {
      return Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 34),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'How Orbit works',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            _helpRow(
              Icons.star_rounded,
              'Orbit Score',
              'A daily 0–100 score computed from your tasks, habits, focus '
              'time, planner, health and Strava activity. Beat yesterday.',
            ),
            _helpRow(
              Icons.favorite_rounded,
              'Health',
              'Connect Health Connect on the Steps page to feed steps, '
              'distance and sleep into your score.',
            ),
            _helpRow(
              Icons.directions_run_rounded,
              'Strava',
              'Connect Strava from the hub to sync workouts and earn '
              'workout points.',
            ),
            _helpRow(
              Icons.lock_rounded,
              'Privacy',
              'Everything is stored locally on your device. No account, '
              'no cloud, no tracking.',
            ),
          ],
        ),
      );
    },
  );
}

Widget _helpRow(IconData icon, String title, String body) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: OrbitColors.copper500),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(
                body,
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.4,
                  color: OrbitColors.warmGray600,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

void _showAboutDialog(BuildContext context, ColorScheme colorScheme) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Orbit'),
      content: Text(
        'Version 0.1.0+1\n\n'
        '"Become better than yesterday."\n\n'
        'Orbit is your personal operating system: one daily score that '
        'reflects everything you care about — tasks, habits, focus, '
        'planner, health and training — stored entirely on your device.',
        style: TextStyle(
          height: 1.45,
          color: colorScheme.onSurface.withValues(alpha: 0.85),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
