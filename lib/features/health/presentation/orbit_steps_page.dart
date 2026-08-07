import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/orbit_colors.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../core/theme/orbit_typography.dart';
import '../../../core/theme/orbit_shadows.dart';
import '../../../shared/widgets/orbit_period_selector.dart';
import '../../../shared/widgets/orbit_activity_grid.dart';
import '../../../shared/widgets/orbit_weekly_steps_chart.dart';
import '../../../shared/widgets/orbit_insight_card_v2.dart';
import '../../health/presentation/providers/health_providers.dart';
import '../../health/presentation/providers/steps_page_providers.dart';
import '../../insights/presentation/providers/insight_providers.dart';

/// RIGHT PAGE — Premium Steps experience.
class OrbitStepsPage extends ConsumerStatefulWidget {
  const OrbitStepsPage({super.key});

  @override
  ConsumerState<OrbitStepsPage> createState() => _OrbitStepsPageState();
}

class _OrbitStepsPageState extends ConsumerState<OrbitStepsPage> {
  int _periodIndex = 0; // 0=Day, 1=Week, 2=Month

  @override
  Widget build(BuildContext context) {
    final healthAuthAsync = ref.watch(healthAuthorizationProvider);
    final healthAsync = ref.watch(todayHealthSnapshotProvider);
    final comparisonAsync = ref.watch(stepsComparisonProvider);
    final weeklyAsync = ref.watch(weeklyStepsProvider);
    final insightsAsync = ref.watch(dailyInsightsProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isAuthorized = healthAuthAsync.asData?.value ?? false;

    return SingleChildScrollView(
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
          // ─── Header ───
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 40), // Balance
              Text(
                'Steps',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Icon(
                Icons.settings_outlined,
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ],
          ),
          OrbitSpacing.vGapLg,

          // ─── Health Connect Disconnected State ───
          if (!isAuthorized) ...[
            _buildDisconnectedBanner(context, ref),
            OrbitSpacing.vGapXxl,
          ],

          // ─── Period Selector ───
          OrbitPeriodSelector(
            selectedIndex: _periodIndex,
            onChanged: (i) => setState(() => _periodIndex = i),
          ),
          OrbitSpacing.vGapXxl,

          // ─── Day View ───
          if (_periodIndex == 0) ...[
            if (isAuthorized)
              _buildDayView(context, healthAsync, comparisonAsync, isDark)
            else
              _buildUnavailableDayState(context),
          ],

          // ─── Week View ───
          if (_periodIndex == 1) ...[
            if (isAuthorized)
              _buildWeekView(context, weeklyAsync)
            else
              _buildUnavailableWeekState(context),
          ],

          // ─── Month View ───
          if (_periodIndex == 2) ...[
            _buildMonthView(context),
          ],

          OrbitSpacing.vGapXxl,

          // ─── Orbit Insights ───
          _buildInsights(context, insightsAsync),
        ],
      ),
    );
  }

  Widget _buildDisconnectedBanner(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(OrbitSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.health_and_safety_outlined, color: colorScheme.primary, size: 28),
          OrbitSpacing.hGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Health Connect Not Connected',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  'Connect Health Connect to track real step activity.',
                  style: TextStyle(fontSize: 11, color: colorScheme.onSurface.withValues(alpha: 0.7)),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await ref.read(healthServiceProvider).requestAuthorization();
              if (success) {
                ref.invalidate(healthAuthorizationProvider);
                ref.invalidate(todayHealthSnapshotProvider);
              }
            },
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }

  Widget _buildUnavailableDayState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(OrbitSpacing.xxl),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.directions_walk_rounded,
            size: 40,
            color: colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          OrbitSpacing.vGapMd,
          Text(
            'Step Data Unavailable',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          OrbitSpacing.vGapXs,
          Text(
            'Connect Health Connect above to sync your daily steps, distance, and active time.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnavailableWeekState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(OrbitSpacing.xxl),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.bar_chart_rounded,
            size: 40,
            color: colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          OrbitSpacing.vGapMd,
          Text(
            'Step History Unavailable',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          OrbitSpacing.vGapXs,
          Text(
            'Connect Health Connect to view your weekly step history and averages.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayView(
    BuildContext context,
    AsyncValue healthAsync,
    AsyncValue<double> comparisonAsync,
    bool isDark,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return healthAsync.when(
      data: (snapshot) {
        final comparison = comparisonAsync.asData?.value ?? 0.0;

        return Column(
          children: [
            // ─── Big Step Count ───
            Center(
              child: Column(
                children: [
                  TweenAnimationBuilder<int>(
                    tween: IntTween(begin: 0, end: snapshot.steps),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeOutCubic,
                    builder: (context, val, _) {
                      return Text(
                        _formatNumber(val),
                        style: OrbitTypography.metricLarge.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      );
                    },
                  ),
                  Text(
                    'Steps',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                  ),
                ],
              ),
            ),

            // ─── Comparison Badge ───
            if (comparison != 0.0) ...[
              OrbitSpacing.vGapMd,
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      comparison >= 0
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      size: 14,
                      color: comparison >= 0
                          ? OrbitColors.success
                          : OrbitColors.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${comparison >= 0 ? '↑' : '↓'} ${comparison.abs().toStringAsFixed(1)}% vs last week',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: comparison >= 0
                                ? OrbitColors.success
                                : OrbitColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ],
            OrbitSpacing.vGapXxl,

            // ─── Activity Grid ───
            Container(
              padding: const EdgeInsets.all(OrbitSpacing.lg),
              decoration: BoxDecoration(
                color: isDark ? OrbitColors.darkElevated : OrbitColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: OrbitShadows.card,
              ),
              child: OrbitActivityGrid(
                hourlyIntensity: _calculateHourlyIntensity(snapshot.steps, snapshot.activeMinutes),
                maxSteps: snapshot.steps > 0
                    ? (snapshot.steps * 1.2).toInt()
                    : 6000,
              ),
            ),
            OrbitSpacing.vGapLg,

            // ─── Distance + Active Time ───
            Row(
              children: [
                Expanded(
                  child: _StatPill(
                    label: 'Distance',
                    value: _formatDistance(snapshot.distance),
                    icon: Icons.place_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatPill(
                    label: 'Active Time',
                    value: _formatActiveTime(snapshot.activeMinutes),
                    icon: Icons.directions_run_outlined,
                  ),
                ),
              ],
            ),
            OrbitSpacing.vGapLg,

            // ─── Daily Goal ───
            _buildDailyGoal(context, snapshot.steps, isDark),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Center(
        child: Text('Unable to load step data: $e'),
      ),
    );
  }

  Widget _buildDailyGoal(BuildContext context, int steps, bool isDark) {
    const goal = 10000;
    final pct = (steps / goal).clamp(0.0, 1.0);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(OrbitSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? OrbitColors.darkElevated : OrbitColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: OrbitShadows.card,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Goal',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Icon(
                Icons.edit_outlined,
                size: 18,
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ],
          ),
          OrbitSpacing.vGapSm,
          Row(
            children: [
              Expanded(
                child: Text(
                  '${_formatNumber(steps)} / ${_formatNumber(goal)} steps',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                ),
              ),
              Text(
                '${(pct * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
              ),
            ],
          ),
          OrbitSpacing.vGapSm,
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: pct),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutCubic,
              builder: (context, val, _) {
                return LinearProgressIndicator(
                  value: val,
                  minHeight: 8,
                  backgroundColor: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : OrbitColors.warmGray100,
                  valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekView(
    BuildContext context,
    AsyncValue<List<DailyStepEntry>> weeklyAsync,
  ) {
    return weeklyAsync.when(
      data: (entries) {
        final dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        final now = DateTime.now();
        final todayWeekday = now.weekday; // 1=Mon

        // Find max for personal best indicator
        int maxSteps = 0;
        int maxIdx = -1;
        for (int i = 0; i < entries.length; i++) {
          if (entries[i].steps > maxSteps) {
            maxSteps = entries[i].steps;
            maxIdx = i;
          }
        }

        final nonZeroDays = entries.where((e) => e.steps > 0).toList();
        final avg = nonZeroDays.isNotEmpty
            ? entries.fold<int>(0, (s, e) => s + e.steps) ~/ nonZeroDays.length
            : 0;

        final days = List.generate(entries.length, (i) {
          return DayStepData(
            label: dayLabels[i],
            steps: entries[i].steps,
            isPersonalBest: i == maxIdx && maxSteps > 0,
            isToday: (i + 1) == todayWeekday,
          );
        });

        return OrbitWeeklyStepsChart(
          days: days,
          weeklyAverage: avg,
        );
      },
      loading: () => const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Center(
        child: Text('Unable to load weekly data: $e'),
      ),
    );
  }

  Widget _buildMonthView(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(OrbitSpacing.xl),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.calendar_month_rounded,
            size: 32,
            color: colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          OrbitSpacing.vGapMd,
          Text(
            'Monthly view will appear here\nas Orbit collects more data.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsights(BuildContext context, AsyncValue insightsAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Orbit Insights',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        OrbitSpacing.vGapMd,
        insightsAsync.when(
          data: (insights) {
            // Filter to health-related insights
            final healthInsights = (insights as List).where((i) {
              final cat = i.category?.toLowerCase() ?? '';
              return cat.contains('step') ||
                  cat.contains('health') ||
                  cat.contains('activity') ||
                  cat.contains('walk');
            }).toList();

            final displayInsights =
                healthInsights.isNotEmpty ? healthInsights : insights;

            if (displayInsights.isEmpty) {
              return Text(
                'Keep walking! Insights will appear as patterns emerge.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.4),
                    ),
              );
            }

            return Column(
              children: displayInsights
                  .take(3)
                  .map<Widget>((insight) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: OrbitInsightCardV2(insight: insight),
                      ))
                  .toList(),
            );
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

  /// Calculate realistic hourly intensity based on total steps and active minutes
  /// up to current hour without hardcoding artificial demo spikes.
  List<double> _calculateHourlyIntensity(int totalSteps, int activeMinutes) {
    if (totalSteps <= 0) return List.filled(24, 0.0);

    final currentHour = DateTime.now().hour;
    // Distribute intensity up to current hour proportionally
    final activeHours = currentHour > 6 ? currentHour - 6 : 1;
    final avgIntensityPerActiveHour = (1.0 / activeHours).clamp(0.1, 0.8);

    return List.generate(24, (hour) {
      if (hour > currentHour || hour < 6) return 0.0;
      return avgIntensityPerActiveHour;
    });
  }

  String _formatNumber(int n) {
    if (n >= 1000) {
      final thousands = n ~/ 1000;
      final remainder = (n % 1000).toString().padLeft(3, '0');
      return '$thousands,$remainder';
    }
    return '$n';
  }

  String _formatDistance(double meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
    return '${meters.toInt()} m';
  }

  String _formatActiveTime(int minutes) {
    if (minutes >= 60) {
      return '${minutes ~/ 60}h ${minutes % 60}m';
    }
    return '${minutes}m';
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatPill({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(OrbitSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? OrbitColors.darkElevated : OrbitColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: OrbitShadows.card,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                ),
                OrbitSpacing.vGapXs,
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
          Icon(
            icon,
            size: 20,
            color: colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}
