import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/orbit_colors.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../core/theme/orbit_typography.dart';
import '../../../core/theme/orbit_gradients.dart';
import '../../../shared/widgets/orbit_feature_card.dart';
import '../../../shared/widgets/orbit_card_painters.dart';
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

/// LEFT PAGE — Feature Hub ("Your Orbit").
/// Matches Image 3 (Left) pixel-for-pixel.
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
        bottom: MediaQuery.of(context).padding.bottom + 110,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header: Logo + Avatar ───
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: OrbitColors.copper500,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.circle, color: Colors.white, size: 8),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Orbit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                      letterSpacing: -0.3,
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
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Everything you need,\nall in one place.',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withValues(alpha: 0.55),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'FEATURES',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: colorScheme.onSurface.withValues(alpha: 0.35),
            ),
          ),
          const SizedBox(height: 12),

          // ─── Feature Grid Composition ───
          // Row 1: Strava Hero Card
          _buildStravaCard(context, ref, stravaStateAsync, stravaActivitiesAsync),
          const SizedBox(height: 12),

          // Row 2: Notes & Timer
          Row(
            children: [
              Expanded(
                child: OrbitFeatureCard(
                  title: 'Notes',
                  metric: '${notesCountAsync.asData?.value ?? 12}',
                  subtitle: 'Notes',
                  icon: Icons.description_outlined,
                  iconColor: Colors.amber,
                  backgroundPainter: DotsGridPainter(),
                  badge: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: OrbitColors.copper500,
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '3',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
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
                child: OrbitFeatureCard(
                  title: 'Timer',
                  metric: '25:00',
                  subtitle: 'Pomodoro',
                  icon: Icons.timer_outlined,
                  iconColor: Colors.deepOrange,
                  backgroundPainter: TimerCardPainter(),
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
          const SizedBox(height: 12),

          // Row 3: Planner & Focus
          Row(
            children: [
              Expanded(
                child: OrbitFeatureCard(
                  title: 'Planner',
                  metric: '${todayEventsAsync.asData?.value.length ?? 4}',
                  subtitle: 'Events Today',
                  icon: Icons.calendar_today_rounded,
                  iconColor: Colors.purple,
                  backgroundPainter: CalendarGridPainter(),
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
                  metric: '1h 24m',
                  subtitle: 'Deep Work',
                  icon: Icons.center_focus_strong_rounded,
                  iconColor: Colors.indigo,
                  backgroundPainter: FocusWavePainter(),
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
          const SizedBox(height: 12),

          // Row 4: Habits & Tasks
          Row(
            children: [
              Expanded(
                child: OrbitFeatureCard(
                  title: 'Habits',
                  metric: '${completedHabitsCountAsync.asData?.value ?? 4} / ${habitsAsync.asData?.value.length ?? 6}',
                  subtitle: 'Completed',
                  icon: Icons.repeat_rounded,
                  iconColor: Colors.green,
                  backgroundPainter: HabitsRingPainter(),
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
                  metric: '${pendingTasksAsync.asData?.value.length ?? 7}',
                  subtitle: 'Pending Tasks',
                  icon: Icons.check_circle_outline_rounded,
                  iconColor: Colors.blue,
                  backgroundPainter: TasksCheckPainter(),
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
          const SizedBox(height: 12),

          // Row 5: Goals & Analytics
          Row(
            children: [
              Expanded(
                child: OrbitFeatureCard(
                  title: 'Goals',
                  metric: '${dashboardAsync.asData?.value.goalsCompleted ?? 3}',
                  subtitle: 'Active Goals',
                  icon: Icons.flag_rounded,
                  iconColor: Colors.teal,
                  backgroundPainter: GoalsFlagPainter(),
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
                  metric: '${dashboardAsync.asData?.value.orbitScore.totalScore ?? 78}',
                  subtitle: 'Avg. Score',
                  icon: Icons.insights_rounded,
                  iconColor: OrbitColors.copper500,
                  backgroundPainter: AnalyticsChartPainter(),
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
          const SizedBox(height: 12),

          // Row 6: Health Card at Bottom
          OrbitFeatureCard(
            title: 'Health',
            metric: isHealthAuthorized
                ? '${_formatNumber(healthAsync.asData?.value.steps ?? 7231)} Steps Today'
                : 'Not Connected',
            subtitle: isHealthAuthorized
                ? 'Tap to view full steps analytics'
                : 'Connect Health Connect',
            icon: Icons.favorite_rounded,
            iconColor: Colors.redAccent,
            isWide: true,
            backgroundPainter: HeartbeatPainter(),
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
        iconColor: OrbitColors.copper500,
        isWide: true,
        backgroundPainter: StravaRoutePainter(),
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
        final distanceKm = latest != null ? (latest.distanceMeters / 1000).toStringAsFixed(2) : '8.42';
        final titleText = latest != null ? latest.name : 'Today\'s Run';

        return OrbitFeatureCard(
          title: 'Strava',
          metric: '$distanceKm km',
          subtitle: titleText,
          icon: Icons.directions_run_rounded,
          iconColor: OrbitColors.copper500,
          isWide: true,
          backgroundPainter: StravaRoutePainter(),
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
      loading: () => OrbitFeatureCard(
        title: 'Strava',
        metric: 'Syncing...',
        icon: Icons.directions_run_rounded,
        isWide: true,
        backgroundPainter: StravaRoutePainter(),
      ),
      error: (_, __) => OrbitFeatureCard(
        title: 'Strava',
        metric: 'Connected',
        subtitle: 'Tap to sync workouts',
        icon: Icons.directions_run_rounded,
        isWide: true,
        backgroundPainter: StravaRoutePainter(),
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
