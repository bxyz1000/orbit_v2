import 'package:flutter/material.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../core/theme/orbit_radius.dart';
import '../../../shared/widgets/orbit_section_header.dart';
import '../../../shared/widgets/orbit_info_tile.dart';
import '../../../shared/widgets/orbit_group_card.dart';
import '../../../app/orbit_app.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(OrbitSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGeneralSection(textTheme, colorScheme),
            OrbitSpacing.gapXl,
            _buildSection(
              title: 'Productivity',
              items: [
                _SettingItem(title: 'Default Home Screen', icon: Icons.home_outlined),
                _SettingItem(title: 'Daily Reminder', icon: Icons.alarm_outlined),
                _SettingItem(title: 'Planner Settings', icon: Icons.calendar_month_outlined),
              ],
              textTheme: textTheme,
              colorScheme: colorScheme,
            ),
            OrbitSpacing.gapXl,
            _buildSection(
              title: 'Privacy',
              items: [
                _SettingItem(title: 'Local Storage', icon: Icons.storage_outlined),
                _SettingItem(title: 'Permissions', icon: Icons.security_outlined),
                _SettingItem(title: 'Backup', icon: Icons.cloud_upload_outlined),
              ],
              textTheme: textTheme,
              colorScheme: colorScheme,
            ),
            OrbitSpacing.gapXl,
            _buildSection(
              title: 'Support',
              items: [
                _SettingItem(title: 'Help Center', icon: Icons.help_outline),
                _SettingItem(title: 'Send Feedback', icon: Icons.feedback_outlined),
                _SettingItem(title: 'About Orbit', icon: Icons.info_outline),
              ],
              textTheme: textTheme,
              colorScheme: colorScheme,
            ),
            OrbitSpacing.gapXxl,
            Center(
              child: Text(
                'Orbit MVP 0.1.0',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ),
            OrbitSpacing.gapXxl,
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralSection(TextTheme textTheme, ColorScheme colorScheme) {
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
        ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (context, mode, _) {
            return OrbitGroupCard(
              borderRadius: OrbitRadius.brLg,
              children: [
                OrbitInfoTile(
                  icon: Icons.language_outlined,
                  title: 'Language',
                  trailing: const Icon(Icons.chevron_right, size: 20),
                ),
                const Divider(height: 1, indent: OrbitSpacing.huge),
                OrbitInfoTile(
                  icon: Icons.palette_outlined,
                  title: 'Theme',
                  trailing: Text(
                    mode.name[0].toUpperCase() + mode.name.substring(1),
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
                const Divider(height: 1, indent: OrbitSpacing.huge),
                OrbitInfoTile(
                  icon: Icons.notifications_none_outlined,
                  title: 'Notifications',
                  trailing: const Icon(Icons.chevron_right, size: 20),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<_SettingItem> items,
    required TextTheme textTheme,
    required ColorScheme colorScheme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: OrbitSpacing.sm,
            bottom: OrbitSpacing.sm,
          ),
          child: OrbitSectionHeader(
            title: title,
            titleStyle: textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        OrbitGroupCard(
          borderRadius: OrbitRadius.brLg,
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == items.length - 1;

            return Column(
              children: [
                OrbitInfoTile(
                  icon: item.icon,
                  title: item.title,
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: () {},
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    indent: OrbitSpacing.huge,
                    endIndent: OrbitSpacing.md,
                    color: colorScheme.outline.withOpacity(0.1),
                  ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SettingItem {
  final String title;
  final IconData icon;

  _SettingItem({required this.title, required this.icon});
}
