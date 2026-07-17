import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../core/theme/orbit_radius.dart';
import '../../../shared/widgets/orbit_section_header.dart';
import '../../../shared/widgets/orbit_stat_card.dart';
import '../../../shared/widgets/orbit_info_tile.dart';
import '../../../shared/widgets/orbit_group_card.dart';
import '../../settings/presentation/providers/preferences_providers.dart';
import '../../score/presentation/providers/score_providers.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(userPreferencesProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: prefsAsync.when(
        data: (prefs) => SingleChildScrollView(
          padding: const EdgeInsets.all(OrbitSpacing.xl),
          child: Column(
            children: [
              _buildHeader(textTheme, colorScheme, prefs),
              OrbitSpacing.gapXxl,
              _buildQuickStats(ref),
              OrbitSpacing.gapXxl,
              _buildThemeSelection(textTheme, colorScheme, ref, prefs),
              OrbitSpacing.gapXxl,
              _buildPreferences(textTheme, colorScheme, ref, prefs),
              OrbitSpacing.gapXxl,
              _buildAbout(colorScheme),
              OrbitSpacing.gapXxl,
              _buildBottomButton(),
              OrbitSpacing.gapXxl,
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading profile: $e')),
      ),
    );
  }

  Widget _buildHeader(TextTheme textTheme, ColorScheme colorScheme, dynamic prefs) {
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
          prefs.userName,
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          prefs.userTagline,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(WidgetRef ref) {
    final scoreAsync = ref.watch(currentDailyScoreProvider);
    final streakAsync = ref.watch(currentStreakProvider);
    final sessionsAsync = ref.watch(todaySessionsProvider);

    return Row(
      children: [
        Expanded(
          child: scoreAsync.when(
            data: (score) => OrbitStatCard(title: 'Daily Score', value: '${score.totalScore}'),
            loading: () => const OrbitStatCard(title: 'Daily Score', value: '...'),
            error: (_, __) => const OrbitStatCard(title: 'Daily Score', value: 'Err'),
          ),
        ),
        OrbitSpacing.gapMd,
        Expanded(
          child: streakAsync.when(
            data: (streak) => OrbitStatCard(title: 'Streak', value: '$streak Days'),
            loading: () => const OrbitStatCard(title: 'Streak', value: '...'),
            error: (_, __) => const OrbitStatCard(title: 'Streak', value: 'Err'),
          ),
        ),
        OrbitSpacing.gapMd,
        Expanded(
          child: sessionsAsync.when(
            data: (sessions) {
              final totalMinutes = sessions.fold<int>(0, (sum, s) => sum + s.duration);
              final hours = totalMinutes / 60;
              return OrbitStatCard(title: 'Focus Hours', value: '${hours.toStringAsFixed(1)}h');
            },
            loading: () => const OrbitStatCard(title: 'Focus Hours', value: '...'),
            error: (_, __) => const OrbitStatCard(title: 'Focus Hours', value: 'Err'),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSelection(TextTheme textTheme, ColorScheme colorScheme, WidgetRef ref, dynamic prefs) {
    final currentMode = ref.watch(appThemeModeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrbitSectionHeader(title: 'Appearance'),
        OrbitSpacing.gapMd,
        OrbitGroupCard(
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('System'),
              value: ThemeMode.system,
              groupValue: currentMode,
              onChanged: (mode) => ref.read(preferencesNotifierProvider.notifier).setThemeMode(mode!),
              secondary: const Icon(Icons.settings_brightness_outlined),
            ),
            const Divider(height: 1),
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: currentMode,
              onChanged: (mode) => ref.read(preferencesNotifierProvider.notifier).setThemeMode(mode!),
              secondary: const Icon(Icons.light_mode_outlined),
            ),
            const Divider(height: 1),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: currentMode,
              onChanged: (mode) => ref.read(preferencesNotifierProvider.notifier).setThemeMode(mode!),
              secondary: const Icon(Icons.dark_mode_outlined),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPreferences(TextTheme textTheme, ColorScheme colorScheme, WidgetRef ref, dynamic prefs) {
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
                value: prefs.notificationsEnabled,
                onChanged: (v) => ref.read(preferencesNotifierProvider.notifier).updatePreferences(
                  prefs.copyWith(notificationsEnabled: v)
                ),
              ),
            ),
            const Divider(height: 1),
            OrbitInfoTile(
              icon: Icons.auto_awesome_outlined,
              title: 'AI Assistant',
              trailing: Switch(
                value: prefs.aiAssistantEnabled,
                onChanged: (v) => ref.read(preferencesNotifierProvider.notifier).updatePreferences(
                  prefs.copyWith(aiAssistantEnabled: v)
                ),
              ),
            ),
            const Divider(height: 1),
            OrbitInfoTile(
              icon: Icons.sync,
              title: 'Planner Sync',
              trailing: Switch(
                value: prefs.plannerSyncEnabled,
                onChanged: (v) => ref.read(preferencesNotifierProvider.notifier).updatePreferences(
                  prefs.copyWith(plannerSyncEnabled: v)
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAbout(ColorScheme colorScheme) {
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
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const Divider(height: 1),
            OrbitInfoTile(
              title: 'Developer',
              trailing: Text(
                'Bhavik',
                style: const TextStyle(color: Colors.grey),
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
