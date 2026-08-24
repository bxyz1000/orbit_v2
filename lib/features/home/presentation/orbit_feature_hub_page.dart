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
import '../../integrations/strava/domain/entities/strava_activity.dart';
import '../../notes/presentation/notes_page.dart';
import '../../planner/presentation/planner_page.dart';
import '../../habits/presentation/habits_page.dart';
import '../../focus/presentation/focus_page.dart';
import '../../tasks/presentation/tasks_page.dart';
import '../../analytics/presentation/insights_page.dart';
import '../../profile/presentation/profile_page.dart';

/// LEFT PAGE — Feature Hub ("Your Orbit").
/// Displays real feature counts, health metrics, and Strava integration status.
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

    final notesCount = notesCountAsync.asData?.value ?? 0;
    final eventsCount = todayEventsAsync.asData?.value.length ?? 0;
    final pendingTasksCount = pendingTasksAsync.asData?.value.length ?? 0;
    final totalHabitsCount = habitsAsync.asData?.value.length ?? 0;
    final completedHabitsCount = completedHabitsCountAsync.asData?.value ?? 0;
    final dashboardState = dashboardAsync.asData?.value;
    final focusMin = dashboardState?.focusMinutesCompleted ?? 0;
    final goalsCount = dashboardState?.goalsCompleted ?? 0;
    final orbitScoreVal = dashboardState?.orbitScore.totalScore ?? 0;

    final focusMetricStr = focusMin >= 60
        ? '${focusMin ~/ 60}h ${focusMin % 60}m'
        : '${focusMin}m';

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
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ProfilePage()),
                  );
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
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
                    // Notification dot per reference design
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: OrbitColors.copper500,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? OrbitColors.darkBackground : Colors.white,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                  subtitle: 'Capture your thoughts',
                  backgroundImage: 'assets/images/notes_paper.jpg',
                  icon: Icons.description_outlined,
                  iconColor: const Color(0xFF7C5CFC),
                  tags: const ['Organize', 'Plan', 'Get things done'],
                  footerIcon: Icons.checklist_rounded,
                  backgroundPainter: DotsGridPainter(),
                  badge: notesCount > 0
                      ? Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: OrbitColors.copper500,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$notesCount',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        )
                      : null,
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
                  // Default Pomodoro preset from FocusPage ([15, 25, 45, 60]).
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
                  metric: '$eventsCount',
                  subtitle: 'Plan your day',
                  backgroundImage: 'assets/images/planner_calendar.jpg',
                  icon: Icons.calendar_today_rounded,
                  iconColor: const Color(0xFF22A45D),
                  tags: const ['Schedule', 'Track', 'Stay consistent'],
                  footerIcon: Icons.calendar_today_rounded,
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
                  metric: focusMetricStr,
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
                  metric: '$completedHabitsCount / $totalHabitsCount',
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
                  metric: '$pendingTasksCount',
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
                  metric: '$goalsCount',
                  subtitle: 'Achieve more',
                  backgroundImage: 'assets/images/goals_mountain.jpg',
                  icon: Icons.flag_rounded,
                  iconColor: const Color(0xFF2F6FEB),
                  tags: const ['Set', 'Focus', 'Win'],
                  footerIcon: Icons.emoji_events_rounded,
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
                  metric: '$orbitScoreVal',
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
                ? '${_formatNumber(healthAsync.asData?.value.steps ?? 0)} Steps Today'
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
    final status = stravaState?.status ?? StravaConnectionStatus.notConnected;

    if (status == StravaConnectionStatus.error) {
      final errorMsg = stravaState?.errorMessage ?? 'Tap to reconnect';
      return OrbitFeatureCard(
        title: 'Strava Run',
        metric: 'Auth Error',
        subtitle: errorMsg,
        icon: Icons.error_outline_rounded,
        iconColor: Colors.redAccent,
        isWide: true,
        tags: const ['Connect', 'Sync', 'Track'],
        footerIcon: Icons.directions_run_rounded,
        backgroundPainter: StravaRoutePainter(),
        backgroundImage: 'assets/images/strava_run.jpg',
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

    if (status == StravaConnectionStatus.syncing) {
      return OrbitFeatureCard(
        title: 'Strava Run',
        metric: 'Syncing...',
        subtitle: 'Fetching activities',
        icon: Icons.directions_run_rounded,
        iconColor: const Color(0xFFFC5200),
        isWide: true,
        tags: const ['Connect', 'Sync', 'Track'],
        footerIcon: Icons.directions_run_rounded,
        backgroundPainter: StravaRoutePainter(),
        backgroundImage: 'assets/images/strava_run.jpg',
      );
    }

    if (status == StravaConnectionStatus.notConnected) {
      return OrbitFeatureCard(
        title: 'Strava Run',
        metric: 'Not Connected',
        subtitle: 'Tap to connect Strava',
        icon: Icons.directions_run_rounded,
        iconColor: const Color(0xFFFC5200),
        isWide: true,
        tags: const ['Connect', 'Sync', 'Track'],
        footerIcon: Icons.directions_run_rounded,
        backgroundPainter: StravaRoutePainter(),
        backgroundImage: 'assets/images/strava_run.jpg',
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

    // Connected state
    return stravaActivitiesAsync.when(
      data: (activities) {
        final activityList = activities as List;
        if (activityList.isEmpty) {
          return OrbitFeatureCard(
            title: 'Strava Run',
            metric: 'No activities',
            subtitle: 'No recent activities',
            icon: Icons.directions_run_rounded,
            iconColor: const Color(0xFFFC5200),
            isWide: true,
            tags: const ['Connect', 'Sync', 'Track'],
            footerIcon: Icons.directions_run_rounded,
            backgroundPainter: StravaRoutePainter(),
            backgroundImage: 'assets/images/strava_run.jpg',
            onTap: () async {
              try {
                await ref.read(stravaSyncNotifierProvider.notifier).sync();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Strava sync: $e')),
                  );
                }
              }
            },
          );
        }

        final StravaActivity latest = activityList.first;
        final distanceKm = (latest.distanceMeters / 1000).toStringAsFixed(2);

        return OrbitFeatureCard(
          title: 'Strava Run',
          subtitle: 'Track your runs',
          icon: Icons.directions_run_rounded,
          iconColor: const Color(0xFFFC5200),
          isWide: true,
          stats: [
            OrbitCardStat(
              icon: Icons.route_rounded,
              value: '$distanceKm km',
              label: 'Distance',
            ),
            OrbitCardStat(
              icon: Icons.timer_outlined,
              value: _formatMovingTime(latest.movingTimeSeconds),
              label: 'Time',
            ),
            OrbitCardStat(
              icon: Icons.speed_rounded,
              value:
                  _formatPace(latest.distanceMeters, latest.movingTimeSeconds),
              label: 'Avg Pace /km',
            ),
          ],
          backgroundPainter: StravaRoutePainter(),
          backgroundImage: 'assets/images/strava_run.jpg',
          onTap: () async {
            try {
              await ref.read(stravaSyncNotifierProvider.notifier).sync();
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Strava sync: $e')),
                );
              }
            }
          },
        );
      },
      loading: () => OrbitFeatureCard(
        title: 'Strava Run',
        metric: 'Syncing...',
        subtitle: 'Loading activities',
        icon: Icons.directions_run_rounded,
        iconColor: const Color(0xFFFC5200),
        isWide: true,
        tags: const ['Connect', 'Sync', 'Track'],
        footerIcon: Icons.directions_run_rounded,
        backgroundPainter: StravaRoutePainter(),
        backgroundImage: 'assets/images/strava_run.jpg',
      ),
      error: (err, _) => OrbitFeatureCard(
        title: 'Strava Run',
        metric: 'Connected',
        subtitle: 'Tap to sync workouts',
        icon: Icons.directions_run_rounded,
        iconColor: const Color(0xFFFC5200),
        isWide: true,
        tags: const ['Connect', 'Sync', 'Track'],
        footerIcon: Icons.directions_run_rounded,
        backgroundPainter: StravaRoutePainter(),
        backgroundImage: 'assets/images/strava_run.jpg',
        onTap: () async {
          try {
            await ref.read(stravaSyncNotifierProvider.notifier).sync();
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Strava sync: $e')),
              );
            }
          }
        },
      ),
    );
  }

  String _formatMovingTime(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) {
      return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  /// Average pace in min/km from total meters + moving seconds.
  String _formatPace(double distanceMeters, int movingSeconds) {
    final distanceKm = distanceMeters / 1000;
    if (distanceKm <= 0 || movingSeconds <= 0) return '--:--';
    final secPerKm = movingSeconds / distanceKm;
    final m = secPerKm ~/ 60;
    final s = (secPerKm % 60).round();
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
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
