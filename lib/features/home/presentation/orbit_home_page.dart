import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../shared/widgets/orbit_section_header.dart';
import '../../../shared/widgets/orbit_group_card.dart';
import '../../../shared/widgets/orbit_stat_card.dart';
import '../../../shared/widgets/orbit_info_tile.dart';
import '../../health/presentation/providers/health_providers.dart';
import '../presentation/widgets/score_progress_ring.dart';
import '../presentation/widgets/weekly_score_chart.dart';
import '../presentation/widgets/score_breakdown_bars.dart';
import '../presentation/widgets/consistency_heatmap.dart';
import '../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../dashboard/domain/entities/dashboard_state.dart';
import '../../integrations/presentation/providers/integration_providers.dart';
import '../../integrations/domain/entities/integration.dart';
import '../../insights/presentation/widgets/todays_insights_section.dart';
import '../../insights/presentation/providers/insight_providers.dart';


class OrbitHomePage extends ConsumerStatefulWidget {
  final VoidCallback onProfileTap;

  const OrbitHomePage({super.key, required this.onProfileTap});

  @override
  ConsumerState<OrbitHomePage> createState() => _OrbitHomePageState();
}

class _OrbitHomePageState extends ConsumerState<OrbitHomePage> with WidgetsBindingObserver {
  Timer? _healthSyncTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshHealth();
    _startPeriodicHealthSync();
  }

  @override
  void dispose() {
    _healthSyncTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _startPeriodicHealthSync() {
    _healthSyncTimer?.cancel();
    _healthSyncTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      debugPrint('[HEALTH] OrbitHome: Periodic 30s sync check triggered');
      ref.read(healthSyncNotifierProvider.notifier).sync();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshHealth();
    }
  }

  Future<void> _refreshHealth() async {
    debugPrint('[HEALTH] OrbitHome: Refreshing health data on resume/init');
    await ref.read(healthSyncNotifierProvider.notifier).sync();
  }

  String _formatSyncTime(DateTime? dateTime) {
    if (dateTime == null) return 'Not synced yet';
    final diff = DateTime.now().difference(dateTime);
    if (diff.inSeconds < 60) {
      return 'Synced just now';
    } else if (diff.inMinutes < 60) {
      return 'Last synced ${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return 'Last synced ${diff.inHours}h ago';
    } else {
      return 'Last synced ${diff.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardAsync = ref.watch(dashboardProvider);
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
      body: dashboardAsync.when(
        data: (state) => RefreshIndicator(
          onRefresh: () async {
            await ref.read(healthSyncNotifierProvider.notifier).sync();
            ref.invalidate(dailyInsightsProvider);
            ref.invalidate(categoryInsightsProvider);
            ref.invalidate(dashboardProvider);
            await ref.read(dashboardProvider.future);
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(OrbitSpacing.xl),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroSection(context, state),
                OrbitSpacing.gapXxl,
                _buildNextBestAction(context, state),
                OrbitSpacing.gapXxl,
                const TodaysInsightsSection(),
                OrbitSpacing.gapXxl,
                if (healthAuthorized.asData?.value == false) ...[
                  _buildHealthConnectBanner(context, ref),
                  OrbitSpacing.gapXxl,
                ],

                const OrbitSectionHeader(title: "Today's Timeline"),
                OrbitSpacing.gapLg,
                _buildTimeline(context, state),
                OrbitSpacing.gapXxl,
                if (state.todayEvents.isNotEmpty) ...[
                  _buildUpcomingEvent(state, context),
                  OrbitSpacing.gapXxl,
                ],
                OrbitSectionHeader(
                  title: "Current Progress",
                  subtitle: _formatSyncTime(state.lastSyncedTime),
                ),
                OrbitSpacing.gapLg,
                _buildProgressGrid(state),
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
                _buildCharts(state),
                OrbitSpacing.gapXxl,
                const OrbitSectionHeader(title: "Milestones"),
                OrbitSpacing.gapLg,
                _buildMilestones(state),
                const SizedBox(height: OrbitSpacing.huge),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              OrbitSpacing.gapMd,
              Text('Error loading dashboard: $e'),
              TextButton(
                onPressed: () => ref.invalidate(dashboardProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
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
                    style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.6)),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  debugPrint('[HEALTH] Home banner connect button pressed');
                  final success = await ref.read(healthServiceProvider).requestAuthorization();
                  debugPrint('[HEALTH] requestAuthorization result: $success');
                  if (success) {
                    final integrationRepo = ref.read(integrationRepositoryProvider);
                    final integration = await integrationRepo.getIntegrationById('health_connect');
                    if (integration != null) {
                      final updated = integration.copyWith(
                        status: IntegrationStatus.connected,
                        lastSync: DateTime.now(),
                      );
                      await integrationRepo.updateIntegration(updated);
                      debugPrint('[HEALTH] integration status persisted: connected');
                    }

                    ref.invalidate(healthAuthorizationProvider);
                    ref.invalidate(integrationsStreamProvider);
                    ref.invalidate(integrationByIdProvider('health_connect'));
                    
                    ref.invalidate(healthSyncProvider);
                    ref.invalidate(todayHealthSnapshotProvider);
                    await ref.read(healthSyncProvider.future);
                    ref.invalidate(dashboardProvider);
                  }
                } catch (e, stack) {
                  debugPrint('[HEALTH] ERR Exception during home banner connect: $e');
                  debugPrint('[HEALTH] Stack: $stack');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                    );
                  }
                }
              },
              child: const Text("Connect"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroSection(BuildContext context, DashboardState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final toBeat = state.beatYesterdayScore;
    final completionPct = (state.orbitScore.totalScore / 100).clamp(0.0, 1.0);

    return Center(
      child: Column(
        children: [
          ScoreProgressRing(
            score: state.orbitScore.totalScore,
            progress: completionPct,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _CountupText(
                  value: state.orbitScore.totalScore,
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: colorScheme.onSurface,
                    fontSize: 64,
                  ),
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
              Icon(
                toBeat > 0 ? Icons.trending_up : Icons.stars,
                size: 16,
                color: toBeat > 0 ? colorScheme.primary : Colors.green,
              ),
              const SizedBox(width: 4),
              Text(
                toBeat > 0 ? '$toBeat to beat yesterday' : 'Yesterday beaten! 🎉',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: toBeat > 0 ? colorScheme.onSurface.withValues(alpha: 0.6) : Colors.green,
                  fontWeight: toBeat > 0 ? FontWeight.normal : FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNextBestAction(BuildContext context, DashboardState state) {
    String recommendation = "One focus session will unlock today's potential.";
    IconData icon = Icons.timer_outlined;
    Color accentColor = Theme.of(context).colorScheme.primary;

    if (state.orbitScore.taskScore == 0 && state.taskSummary.remaining > 0) {
      recommendation = "Complete your first task to start your daily climb.";
      icon = Icons.check_circle_outline;
    } else if (state.beatYesterdayScore > 0) {
      recommendation = "You are only ${state.beatYesterdayScore} points away from beating yesterday.";
      icon = Icons.auto_awesome;
      accentColor = Colors.orange;
    } else if (state.focusMinutesCompleted < state.focusMinutesTarget) {
      recommendation = "Maintain your momentum with another focus session.";
      icon = Icons.timer_outlined;
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

  Widget _buildTimeline(BuildContext context, DashboardState state) {
    if (state.todayTimeline.isEmpty) {
      return const OrbitGroupCard(
        children: [
          OrbitInfoTile(
            icon: Icons.auto_awesome_mosaic,
            title: "Your day is a blank canvas",
            subtitle: "Start an activity to see it here.",
          ),
        ],
      );
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 280),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16), // OrbitRadius.brMd
      ),
      child: OrbitGroupCard(
        children: [
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: state.todayTimeline.length,
              separatorBuilder: (context, index) => const Divider(height: 1, indent: 56),
              itemBuilder: (context, index) {
                final item = state.todayTimeline[index];
                return OrbitInfoTile(
                  icon: _getTimelineIcon(item.type),
                  title: item.title,
                  subtitle: item.subtitle ?? _formatTimestamp(item.timestamp),
                  trailing: item.isCompleted 
                      ? const Icon(Icons.check_circle, color: Colors.green, size: 16)
                      : const Icon(Icons.radio_button_unchecked, color: Colors.grey, size: 16),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTimelineIcon(TimelineItemType type) {
    switch (type) {
      case TimelineItemType.task: return Icons.check_circle_outline;
      case TimelineItemType.focus: return Icons.timer_outlined;
      case TimelineItemType.planner: return Icons.calendar_today_outlined;
      case TimelineItemType.health: return Icons.health_and_safety_outlined;
      case TimelineItemType.goal: return Icons.flag_outlined;
      case TimelineItemType.habit: return Icons.repeat;
    }
  }

  String _formatTimestamp(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:${dt.minute.toString().padLeft(2, '0')} $period';
  }

  Widget _buildUpcomingEvent(DashboardState state, BuildContext context) {
    final upcoming = state.todayEvents.where((e) => !e.isCompleted).firstOrNull;
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
                    Text(upcoming.startTime, style: Theme.of(context).textTheme.labelSmall),
                    Text(upcoming.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                const Spacer(),
                _CountdownWidget(startTime: upcoming.startTime),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressGrid(DashboardState state) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OrbitStatCard(
                title: 'Tasks', 
                value: '${state.tasksCompleted}/${state.tasksCompleted + state.tasksRemaining}', 
                icon: Icons.task_alt
              ),
            ),
            const SizedBox(width: OrbitSpacing.md),
            Expanded(
              child: OrbitStatCard(
                title: 'Focus', 
                value: '${state.focusMinutesCompleted}m', 
                icon: Icons.timer
              ),
            ),
          ],
        ),
        const SizedBox(height: OrbitSpacing.md),
        Row(
          children: [
            Expanded(
              child: OrbitStatCard(
                title: 'Goals', 
                value: '${state.goalsCompleted}/${state.goalsCompleted + state.goalsRemaining}', 
                icon: Icons.flag
              ),
            ),
            const SizedBox(width: OrbitSpacing.md),
            Expanded(
              child: OrbitStatCard(
                title: 'Steps', 
                value: '${state.healthSteps}', 
                icon: Icons.directions_walk
              ),
            ),
          ],
        ),
        const SizedBox(height: OrbitSpacing.md),
        Row(
          children: [
            Expanded(
              child: OrbitStatCard(
                title: 'Calories', 
                value: '${state.healthCalories.toInt()}', 
                icon: Icons.local_fire_department
              ),
            ),
            const SizedBox(width: OrbitSpacing.md),
            Expanded(
              child: OrbitStatCard(
                title: 'Sleep', 
                value: state.healthSleepMinutes > 0 
                  ? '${state.healthSleepMinutes ~/ 60}h ${state.healthSleepMinutes % 60}m' 
                  : '0m', 
                icon: Icons.nightlight_round
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCharts(DashboardState state) {
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
            ScoreBreakdownBars(score: state.orbitScore),
          ],
        ),
      ],
    );
  }

  Widget _buildMilestones(DashboardState state) {
    if (state.personalRecords.isEmpty) {
       return const OrbitGroupCard(
        children: [
          OrbitInfoTile(title: "No milestones yet", subtitle: "Stay consistent to unlock rewards.")
        ],
      );
    }

    return OrbitGroupCard(
      children: state.personalRecords.take(2).map((a) => Column(
        children: [
          OrbitInfoTile(
            icon: Icons.stars,
            title: a.recordType.replaceAll('_', ' ').toUpperCase(),
            subtitle: "Record achieved!",
            trailing: Text(
              '${a.value.toInt()}', 
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)
            ),
          ),
          if (state.personalRecords.indexOf(a) < math.min(state.personalRecords.length, 2) - 1) 
            const Divider(height: 1, indent: 56),
        ],
      )).toList(),
    );
  }
}

class _CountupText extends StatelessWidget {
  final int value;
  final TextStyle? style;

  const _CountupText({required this.value, this.style});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: const Duration(seconds: 1),
      curve: Curves.easeOutCubic,
      builder: (context, val, child) {
        return Text('$val', style: style);
      },
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
