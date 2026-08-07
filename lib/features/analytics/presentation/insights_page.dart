import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/orbit_spacing.dart';
import 'providers/analytics_providers.dart';
import 'widgets/analytics_period_selector.dart';
import 'widgets/score_overview_card.dart';
import 'widgets/score_trend_chart.dart';
import 'widgets/task_analytics_section.dart';
import 'widgets/focus_analytics_section.dart';
import 'widgets/health_analytics_section.dart';
import 'widgets/habit_analytics_section.dart';
import 'widgets/goal_analytics_section.dart';
import 'widgets/comparison_section.dart';
import 'widgets/records_section.dart';

import '../../insights/presentation/widgets/category_insights_section.dart';
import '../../insights/presentation/providers/insight_providers.dart';

class InsightsPage extends ConsumerWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(selectedOrbitAnalyticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ANALYTICS',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: OrbitSpacing.xl, vertical: OrbitSpacing.md),
            child: AnalyticsPeriodSelector(),
          ),
          Expanded(
            child: analyticsAsync.when(
              data: (analytics) => RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(categoryInsightsProvider);
                  ref.invalidate(dailyInsightsProvider);
                  return ref.refresh(selectedOrbitAnalyticsProvider.future);
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(OrbitSpacing.xl),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScoreOverviewCard(scoreAnalytics: analytics.score),
                      OrbitSpacing.gapXxl,
                      ScoreTrendChart(points: analytics.score.dailyScores),
                      OrbitSpacing.gapXxl,
                      const CategoryInsightsSection(),
                      OrbitSpacing.gapXxl,
                      ComparisonSection(analytics: analytics),
                      OrbitSpacing.gapXxl,

                      TaskAnalyticsSection(taskAnalytics: analytics.tasks),
                      OrbitSpacing.gapXxl,
                      FocusAnalyticsSection(focusAnalytics: analytics.focus),
                      OrbitSpacing.gapXxl,
                      HealthAnalyticsSection(healthAnalytics: analytics.health),
                      OrbitSpacing.gapXxl,
                      HabitAnalyticsSection(habitAnalytics: analytics.habits),
                      OrbitSpacing.gapXxl,
                      GoalAnalyticsSection(goalAnalytics: analytics.goals),
                      OrbitSpacing.gapXxl,
                      RecordsSection(records: analytics.personalRecords),
                      const SizedBox(height: OrbitSpacing.huge),
                    ],
                  ),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(OrbitSpacing.xxl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      OrbitSpacing.gapLg,
                      Text(
                        'Failed to load analytics',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      OrbitSpacing.gapSm,
                      Text(
                        e.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                      ),
                      OrbitSpacing.gapLg,
                      ElevatedButton(
                        onPressed: () => ref.invalidate(analyticsPeriodProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
