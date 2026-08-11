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

/// Combined Profile + Settings destination with premium styling.
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
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? null : OrbitColors.warmWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Profile & Settings',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            letterSpacing: 0.3,
          ),
        ),
        centerTitle: true,
      ),
      body: prefsAsync.when(
        data: (prefs) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: OrbitSpacing.pagePadding),
          child: Column(
            children: [
              const SizedBox(height: 8),
              // ─── Profile Header ───
              _buildProfileHeader(context, prefs),
              const SizedBox(height: 28),

              // ─── Score & Streak Cards ───
              _buildStatsRow(context, scoreAsync, streakAsync, isDark),
              const SizedBox(height: 28),

              // ─── Personal Records ───
              _buildPersonalRecords(context, recordsAsync, isDark),
              const SizedBox(height: 28),

              // ─── Appearance ───
              _buildAppearanceSection(context, ref, prefs, isDark),
              const SizedBox(height: 28),

              // ─── Integrations ───
              _buildIntegrationsSection(context, ref, healthAuthAsync, stravaStateAsync, isDark),
              const SizedBox(height: 28),

              // ─── Preferences ───
              _buildPreferencesSection(context, ref, prefs, isDark),
              const SizedBox(height: 28),

              // ─── About Orbit ───
              _buildAboutSection(context, isDark),
              const SizedBox(height: 48),
            ],
          ),
        ),
        loading: () => Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: OrbitColors.copper500,
          ),
        ),
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
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Icon(
                Icons.person_rounded,
                size: 42,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: OrbitColors.copper500,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          prefs.userName,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          prefs.userTagline,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(
    BuildContext context,
    AsyncValue scoreAsync,
    AsyncValue<int> streakAsync,
    bool isDark,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final scoreVal = scoreAsync.asData?.value.totalScore ?? 0;
    final streakVal = streakAsync.asData?.value ?? 0;

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? OrbitColors.darkElevated : OrbitColors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: OrbitShadows.card,
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : OrbitColors.warmGray200.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Text(
                  '$scoreVal',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.primary,
                        letterSpacing: -1,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Orbit Score',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface.withValues(alpha: 0.45),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? OrbitColors.darkElevated : OrbitColors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: OrbitShadows.card,
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : OrbitColors.warmGray200.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$streakVal',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: OrbitColors.copper500,
                            letterSpacing: -1,
                          ),
                    ),
                    const SizedBox(width: 4),
                    const Text('🔥', style: TextStyle(fontSize: 20)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Day Streak',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface.withValues(alpha: 0.45),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalRecords(BuildContext context, AsyncValue recordsAsync, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrbitSectionHeader(title: 'Personal Records'),
        const SizedBox(height: 10),
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
          loading: () => Center(
            child: CircularProgressIndicator(strokeWidth: 1.5, color: OrbitColors.copper500),
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildAppearanceSection(
    BuildContext context,
    WidgetRef ref,
    dynamic prefs,
    bool isDark,
  ) {
    final currentMode = ref.watch(appThemeModeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrbitSectionHeader(title: 'Appearance'),
        const SizedBox(height: 10),
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
    bool isDark,
  ) {
    final isHealthConnected = healthAuthAsync.asData?.value ?? false;
    final stravaStatus = stravaState?.status ?? StravaConnectionStatus.notConnected;
    final isStravaConnected = stravaStatus == StravaConnectionStatus.connected ||
        stravaStatus == StravaConnectionStatus.syncing;
    final isStravaError = stravaStatus == StravaConnectionStatus.error;

    String stravaSubtitle;
    if (isStravaError) {
      stravaSubtitle = stravaState?.errorMessage ?? 'Authentication required';
    } else if (stravaStatus == StravaConnectionStatus.syncing) {
      stravaSubtitle = 'Syncing...';
    } else if (isStravaConnected) {
      stravaSubtitle = 'Connected (${stravaState?.athleteName ?? 'User'})';
    } else {
      stravaSubtitle = 'Activity & workout sync';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrbitSectionHeader(title: 'Integrations'),
        const SizedBox(height: 10),
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
              subtitle: stravaSubtitle,
              trailing: isStravaError
                  ? TextButton(
                      onPressed: () async {
                        await ref.read(stravaAuthNotifierProvider.notifier).connect();
                      },
                      child: const Text('Reconnect', style: TextStyle(color: OrbitColors.copper500)),
                    )
                  : (isStravaConnected
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
                        )),
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
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrbitSectionHeader(title: 'Preferences'),
        const SizedBox(height: 10),
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

  Widget _buildAboutSection(BuildContext context, bool isDark) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrbitSectionHeader(title: 'About Orbit'),
        const SizedBox(height: 10),
        OrbitGroupCard(
          children: [
            OrbitInfoTile(
              title: 'Philosophy',
              subtitle: 'Become better than yesterday.',
              icon: Icons.auto_awesome_outlined,
            ),
            const Divider(height: 1),
            OrbitInfoTile(
              title: 'Version',
              trailing: Text(
                '7.1 Certified',
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                  fontSize: 13,
                ),
              ),
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
