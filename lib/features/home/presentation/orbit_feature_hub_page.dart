import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/orbit_colors.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../core/theme/orbit_typography.dart';
import '../../../core/theme/orbit_gradients.dart';
import '../../../shared/widgets/orbit_feature_card.dart';
import '../../../shared/providers/repository_providers.dart';
import '../../../shared/providers/data_providers.dart';
import '../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../health/presentation/providers/health_providers.dart';
import '../../integrations/strava/presentation/providers/strava_providers.dart';
import '../../integrations/strava/domain/entities/strava_auth_state.dart';
import '../../notes/presentation/notes_page.dart';
import '../../planner/presentation/planner_page.dart';
import '../../habits/presentation/habits_page.dart';
import '../../focus/presentation/focus_page.dart';
import '../../tasks/presentation/tasks_page.dart';
import '../../analytics/presentation/insights_page.dart';

/// LEFT PAGE — Feature Hub ("Your Orbit"). Premium asymmetric feature composition.
class OrbitFeatureHubPage extends ConsumerWidget {
  final VoidCallback onNavigateToSteps;

  const OrbitFeatureHubPage({
    super.key,
    required this.onNavigateToSteps,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dashboardAsync = ref.watch(dashboardProvider);
    final healthAuthAsync = ref.watch(healthAuthorizationProvider);
    final healthAsync = ref.watch(todayHealthSnapshotProvider);
    final stravaStateAsync = ref.watch(stravaAuthStateStreamProvider);
    final stravaActivitiesAsync = ref.watch(stravaActivitiesProvider);
    final pendingTasksAsync = ref.watch(pendingTasksProvider);
    final todayEventsAsync = ref.watch(todayEventsProvider);
    final habitsAsync = ref.watch(allHabitsProvider);
    final completedHabitsCountAsync = ref.watch(completedHabitsTodayCountProvider);
    final notesCountAsync = ref.watch(allNotesCountProvider);

    final isHealthAuthorized = healthAuthAsync.asData?.value ?? false;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: OrbitSpacing.pagePadding,
        right: OrbitSpacing.pagePadding,
        bottom: MediaQuery.of(context).padding.bottom + 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header ───
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: OrbitColors.copper500,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.circle, color: Colors.white, size: 8),
                  ),
                  OrbitSpacing.hGapSm,
                  Text(
                    'Orbit',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: OrbitColors.copper500,
                          letterSpacing: 0.5,
                        ),
                  ),
                ],
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.person_rounded,
                  size: 18,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Your Orbit',
            style: OrbitTypography.userName.copyWith(
              color: colorScheme.onSurface,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Everything you need, all in one place.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  height: 1.3,
                ),
          ),
          const SizedBox(height: 24),

          Text(
            'FEATURE HUB',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: colorScheme.onSurface.withValues(alpha: 0.35),
            ),
          ),
          const SizedBox(height: 12),

          // ─── Asymmetric Feature Composition ───
          // Hero Row 1: Strava (Wide gradient card)
          _buildStravaCard(context, ref, stravaStateAsync, stravaActivitiesAsync),
          const SizedBox(height: 12),

          // Row 2: Notes (Tall aspect) & Timer/Focus (Compact)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 5,
                  child: OrbitFeatureCard(
                    title: 'Notes',
                    metric: '${notesCountAsync.asData?.value ?? 0}',
                    subtitle: 'Saved Notes',
                    icon: Icons.description_outlined,
                    iconColor: Colors.amber,
                    badge: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Active',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.amber.shade200 : Colors.amber.shade800,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NotesPage(
                            noteRepository: ref.read(noteRepositoryProvider),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 5,
                  child: OrbitFeatureCard(
                    title: 'Timer',
                    metric: '${dashboardAsync.asData?.value.focusMinutesCompleted ?? 0}m',
                    subtitle: 'Completed Today',
                    icon: Icons.timer_outlined,
                    iconColor: Colors.deepOrange,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FocusPage(
                            focusRepository: ref.read(focusRepositoryProvider),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Row 3: Planner & Focus
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: OrbitFeatureCard(
                    title: 'Planner',
                    metric: '${todayEventsAsync.asData?.value.length ?? 0}',
                    subtitle: 'Events Today',
                    icon: Icons.calendar_today_rounded,
                    iconColor: Colors.purple,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PlannerPage(
                            plannerRepository: ref.read(plannerRepositoryProvider),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OrbitFeatureCard(
                    title: 'Focus',
                    metric: '${dashboardAsync.asData?.value.focusMinutesCompleted ?? 0}m',
                    subtitle: 'Target: ${dashboardAsync.asData?.value.focusMinutesTarget ?? 120}m',
                    icon: Icons.center_focus_strong_rounded,
                    iconColor: Colors.indigo,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FocusPage(
                            focusRepository: ref.read(focusRepositoryProvider),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Row 4: Habits & Tasks
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: OrbitFeatureCard(
                    title: 'Habits',
                    metric: '${completedHabitsCountAsync.asData?.value ?? 0} / ${habitsAsync.asData?.value.length ?? 0}',
                    subtitle: 'Completed',
                    icon: Icons.repeat_rounded,
                    iconColor: Colors.green,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => HabitsPage(
                            habitRepository: ref.read(habitRepositoryProvider),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OrbitFeatureCard(
                    title: 'Tasks',
                    metric: '${pendingTasksAsync.asData?.value.length ?? 0}',
                    subtitle: 'Pending',
                    icon: Icons.check_circle_outline_rounded,
                    iconColor: Colors.blue,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TasksPage(
                            taskRepository: ref.read(taskRepositoryProvider),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Row 5: Goals & Analytics
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: OrbitFeatureCard(
                    title: 'Goals',
                    metric: '${dashboardAsync.asData?.value.goalsCompleted ?? 0}',
                    subtitle: 'Completed Goals',
                    icon: Icons.flag_rounded,
                    iconColor: Colors.teal,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const InsightsPage(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OrbitFeatureCard(
                    title: 'Analytics',
                    metric: '${dashboardAsync.asData?.value.orbitScore.totalScore ?? 0}',
                    subtitle: 'Current Score',
                    icon: Icons.insights_rounded,
                    iconColor: OrbitColors.copper500,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const InsightsPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Row 6: Health (Steps) - Wide bottom feature card
          OrbitFeatureCard(
            title: 'Health',
            metric: isHealthAuthorized
                ? '${_formatNumber(healthAsync.asData?.value.steps ?? 0)} Steps Today'
                : 'Not Connected',
            subtitle: isHealthAuthorized
                ? 'Tap to view full steps analytics'
                : 'Tap to connect Health Connect',
            icon: Icons.favorite_rounded,
            iconColor: Colors.redAccent,
            isWide: true,
            onTap: onNavigateToSteps,
          ),
        ],
      ),
    );
  }

  Widget _buildStravaCard(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<StravaAuthState> stravaStateAsync,
    AsyncValue stravaActivitiesAsync,
  ) {
    final stravaState = stravaStateAsync.asData?.value;
    final isConnected = stravaState?.status == StravaConnectionStatus.connected ||
        stravaState?.status == StravaConnectionStatus.syncing;

    if (!isConnected) {
      return OrbitFeatureCard(
        title: 'Strava',
        metric: 'Not Connected',
        subtitle: 'Tap to connect Strava',
        icon: Icons.directions_run_rounded,
        gradient: OrbitGradients.strava,
        iconColor: Colors.white,
        isWide: true,
        onTap: () async {
          try {
            await ref.read(stravaAuthNotifierProvider.notifier).connect();
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Strava connection: $e')),
              );
            }
          }
        },
      );
    }

    return stravaActivitiesAsync.when(
      data: (activities) {
        final latest = (activities as List).isNotEmpty ? activities.first : null;
        final distanceKm = latest != null ? (latest.distanceMeters / 1000).toStringAsFixed(2) : '0.00';
        final titleText = latest != null ? latest.name : 'Connected (${stravaState?.athleteName ?? 'User'})';

        return OrbitFeatureCard(
          title: 'Strava',
          metric: '$distanceKm km',
          subtitle: titleText,
          icon: Icons.directions_run_rounded,
          gradient: OrbitGradients.strava,
          iconColor: Colors.white,
          isWide: true,
          onTap: () async {
            try {
              await ref.read(stravaAuthNotifierProvider.notifier).connect();
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Strava connection: $e')),
                );
              }
            }
          },
        );
      },
      loading: () => const OrbitFeatureCard(
        title: 'Strava',
        metric: 'Syncing...',
        icon: Icons.directions_run_rounded,
        gradient: OrbitGradients.strava,
        isWide: true,
      ),
      error: (_, __) => const OrbitFeatureCard(
        title: 'Strava',
        metric: 'Connected',
        subtitle: 'Tap to sync workouts',
        icon: Icons.directions_run_rounded,
        gradient: OrbitGradients.strava,
        isWide: true,
      ),
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000) {
      final thousands = n ~/ 1000;
      final remainder = (n % 1000).toString().padLeft(3, '0');
      return '$thousands,$remainder';
    }
    return '$n';
  }
}
