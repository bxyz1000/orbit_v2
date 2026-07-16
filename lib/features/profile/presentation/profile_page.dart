import 'package:flutter/material.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../core/theme/orbit_radius.dart';
import '../../../shared/widgets/orbit_section_header.dart';
import '../../../shared/widgets/orbit_stat_card.dart';
import '../../../shared/widgets/orbit_info_tile.dart';
import '../../../shared/widgets/orbit_group_card.dart';
import '../../../app/orbit_app.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final bool _notifications = true;
  final bool _aiAssistant = true;
  final bool _plannerSync = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(OrbitSpacing.xl),
        child: Column(
          children: [
            _buildHeader(textTheme, colorScheme),
            OrbitSpacing.gapXxl,
            _buildQuickStats(),
            OrbitSpacing.gapXxl,
            _buildThemeSelection(textTheme, colorScheme),
            OrbitSpacing.gapXxl,
            _buildPreferences(),
            OrbitSpacing.gapXxl,
            _buildAbout(colorScheme),
            OrbitSpacing.gapXxl,
            _buildBottomButton(),
            OrbitSpacing.gapXxl,
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: colorScheme.primaryContainer,
          child: Icon(
            Icons.person,
            size: 50,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        OrbitSpacing.gapMd,
        Text(
          'Bhavik',
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          'AI Productivity Enthusiast',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return const Row(
      children: [
        Expanded(
          child: OrbitStatCard(title: 'Tasks Completed', value: '18'),
        ),
        OrbitSpacing.gapMd,
        Expanded(
          child: OrbitStatCard(title: 'Current Streak', value: '5 Days'),
        ),
        OrbitSpacing.gapMd,
        Expanded(
          child: OrbitStatCard(title: 'Focus Hours', value: '42h'),
        ),
      ],
    );
  }

  Widget _buildThemeSelection(TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrbitSectionHeader(title: 'Appearance'),
        OrbitSpacing.gapMd,
        ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (context, currentMode, _) {
            return OrbitGroupCard(
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text('System'),
                  value: ThemeMode.system,
                  groupValue: currentMode,
                  onChanged: (mode) => themeNotifier.value = mode!,
                  secondary: const Icon(Icons.settings_brightness_outlined),
                ),
                const Divider(height: 1),
                RadioListTile<ThemeMode>(
                  title: const Text('Light'),
                  value: ThemeMode.light,
                  groupValue: currentMode,
                  onChanged: (mode) => themeNotifier.value = mode!,
                  secondary: const Icon(Icons.light_mode_outlined),
                ),
                const Divider(height: 1),
                RadioListTile<ThemeMode>(
                  title: const Text('Dark'),
                  value: ThemeMode.dark,
                  groupValue: currentMode,
                  onChanged: (mode) => themeNotifier.value = mode!,
                  secondary: const Icon(Icons.dark_mode_outlined),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildPreferences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrbitSectionHeader(title: 'Preferences'),
        OrbitSpacing.gapMd,
        OrbitGroupCard(
          children: [
            OrbitInfoTile(
              icon: Icons.notifications_none,
              title: 'Notifications',
              trailing: Switch(
                value: _notifications,
                onChanged: (v) {}, // Functional implementation not required
              ),
            ),
            const Divider(height: 1),
            OrbitInfoTile(
              icon: Icons.auto_awesome_outlined,
              title: 'AI Assistant',
              trailing: Switch(
                value: _aiAssistant,
                onChanged: (v) {},
              ),
            ),
            const Divider(height: 1),
            OrbitInfoTile(
              icon: Icons.sync,
              title: 'Planner Sync',
              trailing: Switch(
                value: _plannerSync,
                onChanged: (v) {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAbout(ColorScheme colorScheme) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrbitSectionHeader(title: 'About Orbit'),
        OrbitSpacing.gapMd,
        OrbitGroupCard(
          children: [
            OrbitInfoTile(
              title: 'Version',
              trailing: Text(
                '0.1.0 MVP',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
            const Divider(height: 1),
            OrbitInfoTile(
              title: 'Developer',
              trailing: Text(
                'Bhavik',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: OrbitSpacing.lg),
          shape: const RoundedRectangleBorder(borderRadius: OrbitRadius.brMd),
        ),
        child: const Text('Coming Soon'),
      ),
    );
  }
}
