import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/orbit_colors.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../core/theme/orbit_shadows.dart';
import '../../../shared/widgets/orbit_section_header.dart';
import '../../../shared/widgets/orbit_group_card.dart';
import '../../../shared/widgets/orbit_info_tile.dart';
import '../../settings/presentation/providers/preferences_providers.dart';
import '../../score/presentation/providers/score_providers.dart';
import '../../health/presentation/providers/health_providers.dart';
import '../../integrations/strava/presentation/providers/strava_providers.dart';
import '../../integrations/strava/domain/entities/strava_auth_state.dart';

/// Combined Profile + Settings destination.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(userPreferencesProvider);
    final scoreAsync = ref.watch(currentDailyScoreProvider);
    final streakAsync = ref.watch(currentStreakProvider);
    final recordsAsync = ref.watch(personalRecordsProvider);
    final healthAuthAsync = ref.watch(healthAuthorizationProvider);
    final stravaStateAsync = ref.watch(stravaAuthStateStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
        centerTitle: true,
      ),
      body: prefsAsync.when(
        data: (prefs) => SingleChildScrollView(
          padding: const EdgeInsets.all(OrbitSpacing.pagePadding),
          child: Column(
            children: [
              // ─── Profile Header ───
              _buildProfileHeader(context, prefs),
              OrbitSpacing.vGapXxl,

              // ─── Score & Streak Cards ───
              _buildStatsRow(context, scoreAsync, streakAsync),
              OrbitSpacing.vGapXxl,

              // ─── Personal Records ───
              _buildPersonalRecords(context, recordsAsync),
              OrbitSpacing.vGapXxl,

              // ─── Appearance ───
              _buildAppearanceSection(context, ref, prefs),
              OrbitSpacing.vGapXxl,

              // ─── Integrations ───
              _buildIntegrationsSection(context, ref, healthAuthAsync, stravaStateAsync),
              OrbitSpacing.vGapXxl,

              // ─── Preferences ───
              _buildPreferencesSection(context, ref, prefs),
              OrbitSpacing.vGapXxl,

              // ─── About Orbit ───
              _buildAboutSection(context),
              OrbitSpacing.vGapXxxl,
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading profile: $e')),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, dynamic prefs) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 46,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(
                Icons.person_rounded,
                size: 46,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: OrbitColors.copper500,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        OrbitSpacing.vGapMd,
        Text(
          prefs.userName,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        OrbitSpacing.vGapXs,
        Text(
          prefs.userTagline,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(
    BuildContext context,
    AsyncValue scoreAsync,
    AsyncValue<int> streakAsync,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final scoreVal = scoreAsync.asData?.value.totalScore ?? 0;
    final streakVal = streakAsync.asData?.value ?? 0;

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(OrbitSpacing.lg),
            decoration: BoxDecoration(
              color: isDark ? OrbitColors.darkElevated : OrbitColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: OrbitShadows.card,
            ),
            child: Column(
              children: [
                Text(
                  '$scoreVal',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.primary,
                      ),
                ),
                OrbitSpacing.vGapXs,
                Text(
                  'Orbit Score',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(OrbitSpacing.lg),
            decoration: BoxDecoration(
              color: isDark ? OrbitColors.darkElevated : OrbitColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: OrbitShadows.card,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$streakVal',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: OrbitColors.copper500,
                          ),
                    ),
                    const SizedBox(width: 4),
                    const Text('🔥', style: TextStyle(fontSize: 20)),
                  ],
                ),
                OrbitSpacing.vGapXs,
                Text(
                  'Day Streak',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalRecords(BuildContext context, AsyncValue recordsAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrbitSectionHeader(title: 'Personal Records'),
        OrbitSpacing.vGapMd,
        recordsAsync.when(
          data: (records) {
            if (records.isEmpty) {
              return const OrbitGroupCard(
                children: [
                  OrbitInfoTile(
                    icon: Icons.emoji_events_outlined,
                    title: 'No personal records yet',
                    subtitle: 'Keep using Orbit to set new records!',
                  ),
                ],
              );
            }
            return OrbitGroupCard(
              children: (records as List).take(3).map<Widget>((r) {
                return OrbitInfoTile(
                  icon: Icons.emoji_events_rounded,
                  title: r.recordType.replaceAll('_', ' ').toUpperCase(),
                  subtitle: 'Achieved on ${_formatDate(r.achievedAt)}',
                  trailing: Text(
                    '${r.value.toInt()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: OrbitColors.success,
                    ),
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildAppearanceSection(
    BuildContext context,
    WidgetRef ref,
    dynamic prefs,
  ) {
    final currentMode = ref.watch(appThemeModeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrbitSectionHeader(title: 'Appearance'),
        OrbitSpacing.vGapMd,
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

  Widget _buildIntegrationsSection(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<bool> healthAuthAsync,
    AsyncValue<StravaAuthState> stravaStateAsync,
  ) {
    final isHealthConnected = healthAuthAsync.asData?.value ?? false;
    final stravaState = stravaStateAsync.asData?.value;
    final isStravaConnected = stravaState?.status == StravaConnectionStatus.connected ||
        stravaState?.status == StravaConnectionStatus.syncing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrbitSectionHeader(title: 'Integrations'),
        OrbitSpacing.vGapMd,
        OrbitGroupCard(
          children: [
            OrbitInfoTile(
              icon: Icons.health_and_safety_outlined,
              title: 'Health Connect',
              subtitle: isHealthConnected ? 'Connected & syncing' : 'Tap to connect',
              trailing: Switch(
                value: isHealthConnected,
                onChanged: (val) async {
                  if (val) {
                    await ref.read(healthServiceProvider).requestAuthorization();
                    ref.invalidate(healthAuthorizationProvider);
                  }
                },
              ),
            ),
            const Divider(height: 1),
            OrbitInfoTile(
              icon: Icons.directions_run_outlined,
              title: 'Strava',
              subtitle: isStravaConnected
                  ? 'Connected (${stravaState?.athleteName ?? 'User'})'
                  : 'Activity & workout sync',
              trailing: isStravaConnected
                  ? TextButton(
                      onPressed: () async {
                        await ref.read(stravaSyncNotifierProvider.notifier).disconnect();
                      },
                      child: const Text('Disconnect', style: TextStyle(color: Colors.redAccent)),
                    )
                  : TextButton(
                      onPressed: () async {
                        await ref.read(stravaAuthNotifierProvider.notifier).connect();
                      },
                      child: const Text('Connect'),
                    ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(
    BuildContext context,
    WidgetRef ref,
    dynamic prefs,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrbitSectionHeader(title: 'Preferences'),
        OrbitSpacing.vGapMd,
        OrbitGroupCard(
          children: [
            OrbitInfoTile(
              icon: Icons.notifications_none_rounded,
              title: 'Notifications',
              trailing: Switch(
                value: prefs.notificationsEnabled,
                onChanged: (v) => ref.read(preferencesNotifierProvider.notifier).updatePreferences(
                  prefs.copyWith(notificationsEnabled: v),
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
                  prefs.copyWith(aiAssistantEnabled: v),
                ),
              ),
            ),
            const Divider(height: 1),
            OrbitInfoTile(
              icon: Icons.sync_rounded,
              title: 'Planner Sync',
              trailing: Switch(
                value: prefs.plannerSyncEnabled,
                onChanged: (v) => ref.read(preferencesNotifierProvider.notifier).updatePreferences(
                  prefs.copyWith(plannerSyncEnabled: v),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrbitSectionHeader(title: 'About Orbit'),
        OrbitSpacing.vGapMd,
        const OrbitGroupCard(
          children: [
            OrbitInfoTile(
              title: 'Philosophy',
              subtitle: 'Become better than yesterday.',
            ),
            Divider(height: 1),
            OrbitInfoTile(
              title: 'Version',
              trailing: Text('7.1 Certified', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
