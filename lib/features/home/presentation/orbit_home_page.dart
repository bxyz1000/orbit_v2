import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../core/theme/orbit_radius.dart';
import '../../../shared/widgets/orbit_section_header.dart';
import '../../../shared/widgets/orbit_group_card.dart';
import '../../../shared/widgets/orbit_stat_card.dart';
import '../../../shared/widgets/orbit_info_tile.dart';
import '../../score/score.dart';
import '../../../shared/providers/data_providers.dart';
import '../../health/presentation/providers/health_providers.dart';
import '../../health/presentation/providers/health_sync_provider.dart';
import 'widgets/score_progress_ring.dart';
import 'widgets/weekly_score_chart.dart';
import 'widgets/score_breakdown_bars.dart';
import 'widgets/consistency_heatmap.dart';

class OrbitHomePage extends ConsumerStatefulWidget {
  final VoidCallback onProfileTap;

  const OrbitHomePage({super.key, required this.onProfileTap});

  @override
  ConsumerState<OrbitHomePage> createState() => _OrbitHomePageState();
}

class _OrbitHomePageState extends ConsumerState<OrbitHomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshHealth();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshHealth();
    }
  }

  Future<void> _refreshHealth() async {
    // Trigger sync
    ref.read(healthSyncProvider);
  }

  @override
  Widget build(BuildContext context) {
    final scoreAsync = ref.watch(currentDailyScoreProvider);
    final yesterdayScoreAsync = ref.watch(yesterdayScoreProvider);
    final healthAuthorized = ref.watch(healthAuthorizationProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('ORBIT', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2)),
        actions: [
          IconButton(
            icon: CircleAvatar(
              radius: 14, 
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: const Icon(Icons.person, size: 18)
            ),
            onPressed: widget.onProfileTap,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: scoreAsync.when(
        data: (score) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(currentDailyScoreProvider);
            ref.invalidate(yesterdayScoreProvider);
            ref.invalidate(pendingTasksProvider);
            ref.invalidate(todayEventsProvider);
            ref.invalidate(healthSyncProvider);
            await ref.read(healthSyncProvider.future);
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(OrbitSpacing.xl),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroSection(context, score, yesterdayScoreAsync.asData?.value),
                OrbitSpacing.gapXxl,
                _buildNextBestAction(context, score, yesterdayScoreAsync.asData?.value),
                OrbitSpacing.gapXxl,
                if (healthAuthorized.asData?.value == false) ...[
                  _buildHealthConnectBanner(context, ref),
                  OrbitSpacing.gapXxl,
                ],
                const OrbitSectionHeader(title: "Today's Mission"),
                OrbitSpacing.gapLg,
                _buildDailyMission(ref, context),
                OrbitSpacing.gapXxl,
                _buildUpcomingEvent(ref, context),
                OrbitSpacing.gapXxl,
                const OrbitSectionHeader(title: "Current Progress"),
                OrbitSpacing.gapLg,
                _buildProgressGrid(ref, score),
                OrbitSpacing.gapXxl,
                const OrbitSectionHeader(title: "Consistency Heatmap"),
                OrbitSpacing.gapLg,
                const OrbitGroupCard(
                  padding: EdgeInsets.all(OrbitSpacing.lg),
                  children: [ConsistencyHeatmap()],
                ),
                OrbitSpacing.gapXxl,
                const OrbitSectionHeader(title: "Performance Trends"),
                OrbitSpacing.gapLg,
                _buildCharts(ref),
                OrbitSpacing.gapXxl,
                const OrbitSectionHeader(title: "Milestones"),
                OrbitSpacing.gapLg,
                _buildMilestones(ref),
                const SizedBox(height: OrbitSpacing.huge),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildHealthConnectBanner(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return OrbitGroupCard(
      padding: const EdgeInsets.all(OrbitSpacing.lg),
      children: [
        Row(
          children: [
            Icon(Icons.health_and_safety, color: colorScheme.primary, size: 32),
            OrbitSpacing.gapLg,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Connect Health to unlock your real activity",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Sync steps, sleep, and workouts automatically.",
                    style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.6)),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final success = await ref.read(healthServiceProvider).requestAuthorization();
                if (success) {
                  ref.invalidate(healthAuthorizationProvider);
                  ref.read(healthSyncProvider);
                }
              },
              child: const Text("Connect"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroSection(BuildContext context, DailyScore score, DailyScore? yesterday) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final diff = yesterday != null ? score.totalScore - yesterday.totalScore : 0;
    final toBeat = yesterday != null ? (yesterday.totalScore + 1) - score.totalScore : 50 - score.totalScore;
    final completionPct = (score.totalScore / 100).clamp(0.0, 1.0);

    return Center(
      child: Column(
        children: [
          ScoreProgressRing(
            score: score.totalScore,
            progress: completionPct,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: score.totalScore),
                  duration: const Duration(seconds: 2),
                  builder: (context, value, child) {
                    return Text(
                      '$value',
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: colorScheme.onSurface,
                        fontSize: 64,
                      ),
                    );
                  },
                ),
                Text(
                  'ORBIT SCORE',
                  style: theme.textTheme.labelMedium?.copyWith(
                    letterSpacing: 1,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          OrbitSpacing.gapLg,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (yesterday != null) ...[
                Icon(
                  diff >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 16,
                  color: diff >= 0 ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  '${diff.abs()} vs yesterday',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: diff >= 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Text(
                toBeat > 0 ? '$toBeat to beat yesterday' : 'Yesterday beaten! 🎉',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNextBestAction(BuildContext context, DailyScore score, DailyScore? yesterday) {
    String recommendation = "One focus session will unlock today's potential.";
    IconData icon = Icons.timer_outlined;
    Color accentColor = Theme.of(context).colorScheme.primary;

    if (score.taskScore == 0) {
      recommendation = "Complete your first task to start your daily climb.";
      icon = Icons.check_circle_outline;
    } else if (yesterday != null && score.totalScore < yesterday.totalScore) {
      final diff = (yesterday.totalScore + 1) - score.totalScore;
      recommendation = "You are only $diff points away from beating yesterday.";
      icon = Icons.auto_awesome;
      accentColor = Colors.orange;
    }

    return OrbitGroupCard(
      padding: const EdgeInsets.all(OrbitSpacing.lg),
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 20),
            ),
            OrbitSpacing.gapLg,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "NEXT BEST ACTION",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: accentColor,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    recommendation,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDailyMission(WidgetRef ref, BuildContext context) {
    final pendingTasksAsync = ref.watch(pendingTasksProvider);

    return pendingTasksAsync.when(
      data: (tasks) {
        if (tasks.isEmpty) {
          return const OrbitGroupCard(
            children: [
              OrbitInfoTile(
                icon: Icons.celebration,
                title: "Mission Accomplished!",
                subtitle: "You've completed all your primary tasks for today.",
              ),
            ],
          );
        }

        return OrbitGroupCard(
          children: tasks.take(3).map((task) => Column(
            children: [
              OrbitInfoTile(
                icon: Icons.circle_outlined,
                title: task.title,
                subtitle: "Mission: Complete this task",
                trailing: const Icon(Icons.chevron_right, size: 16),
              ),
              if (tasks.indexOf(task) < min(tasks.length, 3) - 1) const Divider(height: 1),
            ],
          )).toList(),
        );
      },
      loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SizedBox(),
    );
  }

  Widget _buildUpcomingEvent(WidgetRef ref, BuildContext context) {
    final eventsAsync = ref.watch(todayEventsProvider);
    
    return eventsAsync.when(
      data: (events) {
        final upcoming = events.where((e) => !e.isCompleted).firstOrNull;

        if (upcoming == null) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const OrbitSectionHeader(title: "Upcoming Event"),
            OrbitSpacing.gapLg,
            OrbitGroupCard(
              padding: const EdgeInsets.all(OrbitSpacing.lg),
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(upcoming.time, style: Theme.of(context).textTheme.labelSmall),
                        Text(upcoming.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Spacer(),
                    _CountdownWidget(startTime: upcoming.time),
                  ],
                ),
              ],
            ),
          ],
        );
      },
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
    );
  }

  Widget _buildProgressGrid(WidgetRef ref, DailyScore score) {
    final tasksAsync = ref.watch(pendingTasksProvider);
    final habitsAsync = ref.watch(allHabitsProvider);
    final completedHabitsCount = ref.watch(completedHabitsTodayCountProvider);
    final sessionsAsync = ref.watch(todaySessionsProvider);
    final healthSnapshotAsync = ref.watch(todayHealthSnapshotProvider);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: tasksAsync.when(
                data: (pending) {
                  final completed = score.taskScore ~/ 10;
                  final total = completed + pending.length;
                  return OrbitStatCard(
                    title: 'Tasks', 
                    value: '$completed/$total', 
                    icon: Icons.task_alt
                  );
                },
                loading: () => const OrbitStatCard(title: 'Tasks', value: '...', icon: Icons.task_alt),
                error: (_, __) => const OrbitStatCard(title: 'Tasks', value: 'Err', icon: Icons.task_alt),
              ),
            ),
            const SizedBox(width: OrbitSpacing.md),
            Expanded(
              child: sessionsAsync.when(
                data: (sessions) {
                   final focusMinutes = sessions.fold<int>(0, (sum, s) => sum + s.duration);
                   return OrbitStatCard(
                    title: 'Focus', 
                    value: '${focusMinutes}m', 
                    icon: Icons.timer
                  );
                },
                loading: () => const OrbitStatCard(title: 'Focus', value: '...', icon: Icons.timer),
                error: (_, __) => const OrbitStatCard(title: 'Focus', value: 'Err', icon: Icons.timer),
              ),
            ),
          ],
        ),
        const SizedBox(height: OrbitSpacing.md),
        Row(
          children: [
            Expanded(
              child: habitsAsync.when(
                data: (habits) {
                  final completed = completedHabitsCount.asData?.value ?? 0;
                  return OrbitStatCard(
                    title: 'Habits', 
                    value: '$completed/${habits.length}', 
                    icon: Icons.repeat
                  );
                },
                loading: () => const OrbitStatCard(title: 'Habits', value: '...', icon: Icons.repeat),
                error: (_, __) => const OrbitStatCard(title: 'Habits', value: 'Err', icon: Icons.repeat),
              ),
            ),
            const SizedBox(width: OrbitSpacing.md),
            Expanded(
              child: healthSnapshotAsync.when(
                data: (snapshot) => OrbitStatCard(
                  title: 'Steps', 
                  value: '${snapshot.steps}', 
                  icon: Icons.directions_walk
                ),
                loading: () => const OrbitStatCard(title: 'Steps', value: '...', icon: Icons.directions_walk),
                error: (_, __) => const OrbitStatCard(title: 'Steps', value: 'Err', icon: Icons.directions_walk),
              ),
            ),
          ],
        ),
        const SizedBox(height: OrbitSpacing.md),
        healthSnapshotAsync.when(
          data: (snapshot) => Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: OrbitStatCard(
                      title: 'Calories', 
                      value: '${snapshot.calories.toInt()} kcal', 
                      icon: Icons.local_fire_department
                    ),
                  ),
                  const SizedBox(width: OrbitSpacing.md),
                  Expanded(
                    child: OrbitStatCard(
                      title: 'Sleep', 
                      value: snapshot.sleepMinutes > 0 
                        ? '${snapshot.sleepMinutes ~/ 60}h ${snapshot.sleepMinutes % 60}m' 
                        : '0m', 
                      icon: Icons.nightlight_round
                    ),
                  ),
                ],
              ),
              const SizedBox(height: OrbitSpacing.md),
              Row(
                children: [
                   Expanded(
                    child: OrbitStatCard(
                      title: 'Distance', 
                      value: '${(snapshot.distance / 1000).toStringAsFixed(2)} km', 
                      icon: Icons.map
                    ),
                  ),
                  const SizedBox(width: OrbitSpacing.md),
                  Expanded(
                    child: OrbitStatCard(
                      title: 'Active', 
                      value: '${snapshot.activeMinutes}m', 
                      icon: Icons.bolt
                    ),
                  ),
                ],
              ),
            ],
          ),
          loading: () => const SizedBox(),
          error: (_, __) => const SizedBox(),
        ),
      ],
    );
  }

  Widget _buildCharts(WidgetRef ref) {
    return Column(
      children: [
        OrbitGroupCard(
          padding: const EdgeInsets.all(OrbitSpacing.xl),
          children: [
            const Text('WEEKLY PERFORMANCE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
            const SizedBox(height: 16),
            const SizedBox(height: 140, child: WeeklyScoreChart()),
          ],
        ),
        OrbitSpacing.gapLg,
        OrbitGroupCard(
          padding: const EdgeInsets.all(OrbitSpacing.xl),
          children: [
            const Text('SCORE CONTRIBUTION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
            const SizedBox(height: 16),
            Consumer(builder: (context, ref, _) {
              final score = ref.watch(currentDailyScoreProvider).asData?.value;
              if (score == null) return const SizedBox();
              return ScoreBreakdownBars(score: score);
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildMilestones(WidgetRef ref) {
    final achievementsAsync = ref.watch(unlockedAchievementsProvider);

    return achievementsAsync.when(
      data: (achievements) => OrbitGroupCard(
        children: [
          if (achievements.isEmpty)
            const OrbitInfoTile(title: "No milestones yet", subtitle: "Complete your first task to start.")
          else
            ...achievements.take(2).map((a) => OrbitInfoTile(
              icon: Icons.stars,
              title: a.title,
              subtitle: a.description,
              trailing: const Icon(Icons.check_circle, color: Colors.green, size: 16),
            )),
        ],
      ),
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
    );
  }
}

class _CountdownWidget extends StatefulWidget {
  final String startTime;

  const _CountdownWidget({required this.startTime});

  @override
  State<_CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<_CountdownWidget> {
  late Timer _timer;
  String _timeRemaining = "";

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    try {
      final now = DateTime.now();
      final parts = widget.startTime.split(' ');
      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);
      if (parts[1] == "PM" && hour != 12) hour += 12;
      if (parts[1] == "AM" && hour == 12) hour = 0;

      final eventTime = DateTime(now.year, now.month, now.day, hour, minute);
      final diff = eventTime.difference(now);

      if (diff.isNegative) {
        _timeRemaining = "Active";
      } else {
        if (diff.inHours > 0) {
          _timeRemaining = "${diff.inHours}h ${diff.inMinutes % 60}m";
        } else {
          _timeRemaining = "${diff.inMinutes}m";
        }
      }
      if (mounted) setState(() {});
    } catch (e) {
      _timeRemaining = "Soon";
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text("Starts in", style: Theme.of(context).textTheme.labelSmall),
        Text(_timeRemaining, style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w900,
          color: Theme.of(context).colorScheme.primary,
        )),
      ],
    );
  }
}
