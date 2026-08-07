import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../core/theme/orbit_typography.dart';
import '../../../shared/widgets/orbit_hero_score.dart';
import '../../../shared/widgets/orbit_metric_card.dart';
import '../../../shared/widgets/orbit_insight_card_v2.dart';
import '../../../shared/providers/data_providers.dart';
import '../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../dashboard/domain/entities/dashboard_state.dart';
import '../../insights/presentation/providers/insight_providers.dart';
import '../../settings/presentation/providers/preferences_providers.dart';
import '../../score/presentation/providers/score_providers.dart';
import '../../health/presentation/providers/health_providers.dart';

/// CENTER PAGE — Orbit Score Home. The default landing page.
class OrbitScorePage extends ConsumerWidget {
  const OrbitScorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final prefsAsync = ref.watch(userPreferencesProvider);
    final sevenDaysAsync = ref.watch(lastSevenDaysScoresProvider);
    final healthAuthAsync = ref.watch(healthAuthorizationProvider);
    final allHabitsAsync = ref.watch(allHabitsProvider);
    final completedHabitsCountAsync = ref.watch(completedHabitsTodayCountProvider);

    return dashboardAsync.when(
      data: (state) {
        final userName = prefsAsync.asData?.value.userName ?? 'there';
        final greeting = _getGreeting();
        final isHealthAuthorized = healthAuthAsync.asData?.value ?? false;

        // Compute 7-day baseline comparison
        String? baselineText;
        final sevenDays = sevenDaysAsync.asData?.value;
        if (sevenDays != null && sevenDays.length >= 7) {
          final avg7 = sevenDays
              .take(6)
              .fold<int>(0, (s, d) => s + d.totalScore) / 6;
          if (avg7 > 0) {
            final pctChange =
                ((state.orbitScore.totalScore - avg7) / avg7 * 100);
            final sign = pctChange >= 0 ? '↑' : '↓';
            baselineText =
                '$sign ${pctChange.abs().toStringAsFixed(1)}% vs your 7-day baseline';
          }
        }

        // Motivation text
        String motivationTitle;
        String? motivationSubtitle;
        if (state.beatYesterdayScore <= 0) {
          motivationTitle = "You're ahead of yesterday";
          motivationSubtitle = "Keep building momentum.";
        } else {
          motivationTitle =
              "${state.beatYesterdayScore} points to beat yesterday";
          motivationSubtitle = "You've got this.";
        }

        return RefreshIndicator(
          onRefresh: () async {
            await ref.read(healthSyncNotifierProvider.notifier).sync();
            ref.invalidate(dailyInsightsProvider);
            ref.invalidate(dashboardProvider);
            await ref.read(dashboardProvider.future);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              left: OrbitSpacing.pagePadding,
              right: OrbitSpacing.pagePadding,
              bottom: 120,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Greeting + Avatar ───
                _buildHeader(context, greeting, userName),
                OrbitSpacing.vGapXxl,

                // ─── Hero Score ───
                Center(
                  child: OrbitHeroScore(
                    score: state.orbitScore.totalScore,
                    progress:
                        (state.orbitScore.totalScore / 100).clamp(0.0, 1.0),
                    baselineText: baselineText,
                    motivationTitle: motivationTitle,
                    motivationSubtitle: motivationSubtitle,
                  ),
                ),
                OrbitSpacing.vGapXxl,

                // ─── Category Metrics Grid ───
                _buildCategoryGrid(
                  context,
                  state,
                  isHealthAuthorized,
                  allHabitsAsync.asData?.value.length ?? 0,
                  completedHabitsCountAsync.asData?.value ?? 0,
                ),
                OrbitSpacing.vGapXxl,

                // ─── Today's Insight ───
                _buildInsightsSection(context, ref),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            OrbitSpacing.vGapMd,
            Text('Error loading dashboard: $e'),
            TextButton(
              onPressed: () => ref.invalidate(dashboardProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String greeting, String userName) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$greeting,',
              style: OrbitTypography.greeting.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            Text(
              userName,
              style: OrbitTypography.userName.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        CircleAvatar(
          radius: 22,
          backgroundColor: colorScheme.primaryContainer,
          child: Icon(
            Icons.person_rounded,
            size: 22,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid(
    BuildContext context,
    DashboardState state,
    bool isHealthAuthorized,
    int totalHabits,
    int completedHabits,
  ) {
    final totalTasks = state.tasksCompleted + state.tasksRemaining;
    final taskPct = totalTasks > 0
        ? (state.tasksCompleted / totalTasks * 100).roundToDouble()
        : 0.0;

    final focusPct = state.focusMinutesTarget > 0
        ? (state.focusMinutesCompleted / state.focusMinutesTarget * 100)
            .roundToDouble()
            .clamp(0.0, 100.0)
        : 0.0;

    final habitPct = totalHabits > 0
        ? (completedHabits / totalHabits * 100).roundToDouble().clamp(0.0, 100.0)
        : 0.0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OrbitMetricCard(
                title: 'Tasks',
                value: '${state.tasksCompleted} / $totalTasks',
                icon: Icons.check_circle_outline_rounded,
                percentage: taskPct,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OrbitMetricCard(
                title: 'Focus',
                value: '${state.focusMinutesCompleted} min',
                icon: Icons.timer_outlined,
                percentage: focusPct,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OrbitMetricCard(
                title: 'Habits',
                value: '$completedHabits / $totalHabits',
                icon: Icons.loop_rounded,
                percentage: habitPct,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OrbitMetricCard(
                title: 'Health',
                value: isHealthAuthorized
                    ? _formatNumber(state.healthSteps)
                    : 'Not Connected',
                icon: Icons.favorite_outline_rounded,
                percentage: isHealthAuthorized
                    ? (state.healthSteps / 10000 * 100).clamp(0.0, 100.0)
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInsightsSection(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(dailyInsightsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Insight",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        OrbitSpacing.vGapMd,
        insightsAsync.when(
          data: (insights) {
            if (insights.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(OrbitSpacing.lg),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Log your activities to unlock personalized insights.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                ),
              );
            }
            // Show the first (highest priority) insight
            return OrbitInsightCardV2(insight: insights.first);
          },
          loading: () => const SizedBox(
            height: 60,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
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
