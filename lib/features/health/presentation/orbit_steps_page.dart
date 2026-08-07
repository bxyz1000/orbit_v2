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

/// RIGHT PAGE — Premium Steps experience. Closest visual match to wearable reference.
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
        bottom: MediaQuery.of(context).padding.bottom + 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header ───
          Center(
            child: Text(
              'Steps',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: 0.3,
                  ),
            ),
          ),
          const SizedBox(height: 20),

          // ─── Health Connect Disconnected State ───
          if (!isAuthorized) ...[
            _buildDisconnectedBanner(context, ref),
            const SizedBox(height: 24),
          ],

          // ─── Period Selector ───
          OrbitPeriodSelector(
            selectedIndex: _periodIndex,
            onChanged: (i) => setState(() => _periodIndex = i),
          ),
          const SizedBox(height: 28),

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

          const SizedBox(height: 32),

          // ─── Step History heading ───
          if (isAuthorized && _periodIndex == 0) ...[
            _buildStepHistory(context, weeklyAsync),
            const SizedBox(height: 32),
          ],

          // ─── Orbit Insights ───
          _buildInsights(context, insightsAsync),
        ],
      ),
    );
  }

  Widget _buildDisconnectedBanner(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? OrbitColors.copper900.withValues(alpha: 0.3)
            : OrbitColors.copper50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? OrbitColors.copper700.withValues(alpha: 0.3)
              : OrbitColors.copper200.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.health_and_safety_outlined,
                color: colorScheme.primary, size: 22),
          ),
          OrbitSpacing.hGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Health Connect Not Connected',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Connect to track steps & activity.',
                  style: TextStyle(
                    fontSize: 11,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              final success =
                  await ref.read(healthServiceProvider).requestAuthorization();
              if (success) {
                ref.invalidate(healthAuthorizationProvider);
                ref.invalidate(todayHealthSnapshotProvider);
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('Connect', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildUnavailableDayState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            Icons.directions_walk_rounded,
            size: 36,
            color: colorScheme.onSurface.withValues(alpha: 0.15),
          ),
          const SizedBox(height: 12),
          Text(
            'Step Data Unavailable',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Connect Health Connect above to sync your daily steps.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
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
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            Icons.bar_chart_rounded,
            size: 36,
            color: colorScheme.onSurface.withValues(alpha: 0.15),
          ),
          const SizedBox(height: 12),
          Text(
            'Step History Unavailable',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Connect Health Connect to view your weekly step history.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
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
            // ─── Large Hero Step Count ───
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
                          fontSize: 56,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -2,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Steps',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface.withValues(alpha: 0.4),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            // ─── Comparison Badge ───
            if (comparison != 0.0) ...[
              const SizedBox(height: 12),
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: (comparison >= 0
                            ? OrbitColors.success
                            : OrbitColors.error)
                        .withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    '${comparison >= 0 ? '↑' : '↓'} ${comparison.abs().toStringAsFixed(1)}% vs last week',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: comparison >= 0
                          ? OrbitColors.success
                          : OrbitColors.error,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 28),

            // ─── Activity Grid ───
            Container(
              padding: const EdgeInsets.all(16),
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
              child: OrbitActivityGrid(
                hourlyIntensity: _calculateHourlyIntensity(
                    snapshot.steps, snapshot.activeMinutes),
                maxSteps: snapshot.steps > 0
                    ? (snapshot.steps * 1.2).toInt()
                    : 6000,
              ),
            ),
            const SizedBox(height: 12),

            // ─── Distance + Active Time Stat Pills ───
            Row(
              children: [
                Expanded(
                  child: _StatPill(
                    label: 'Distance',
                    value: _formatDistance(snapshot.distance),
                    icon: Icons.place_outlined,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatPill(
                    label: 'Active Time',
                    value: _formatActiveTime(snapshot.activeMinutes),
                    icon: Icons.directions_run_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ─── Daily Goal ───
            _buildDailyGoal(context, snapshot.steps, isDark),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 200,
        child: Center(
            child: CircularProgressIndicator(strokeWidth: 1.5)),
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
      padding: const EdgeInsets.all(16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Goal',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                '${(pct * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${_formatNumber(steps)} / ${_formatNumber(goal)} steps',
            style: TextStyle(
              fontSize: 11,
              color: colorScheme.onSurface.withValues(alpha: 0.45),
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: pct),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutCubic,
              builder: (context, val, _) {
                return LinearProgressIndicator(
                  value: val,
                  minHeight: 6,
                  backgroundColor: isDark
                      ? Colors.white.withValues(alpha: 0.06)
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

  /// Step history section showing last 7 days as compact list
  Widget _buildStepHistory(
      BuildContext context, AsyncValue<List<DailyStepEntry>> weeklyAsync) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'STEP HISTORY',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: colorScheme.onSurface.withValues(alpha: 0.35),
          ),
        ),
        const SizedBox(height: 12),
        weeklyAsync.when(
          data: (entries) {
            if (entries.isEmpty) {
              return Text(
                'History will appear as data is collected.',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurface.withValues(alpha: 0.35),
                ),
              );
            }

            final dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
            final now = DateTime.now();
            int maxSteps = 0;
            for (final e in entries) {
              if (e.steps > maxSteps) maxSteps = e.steps;
            }

            return Container(
              padding: const EdgeInsets.all(16),
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
                children: List.generate(entries.length, (i) {
                  final entry = entries[i];
                  final isToday = (i + 1) == now.weekday;
                  final barPct =
                      maxSteps > 0 ? (entry.steps / maxSteps).clamp(0.0, 1.0) : 0.0;

                  return Padding(
                    padding: EdgeInsets.only(bottom: i < entries.length - 1 ? 8 : 0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 32,
                          child: Text(
                            i < dayLabels.length ? dayLabels[i] : '',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                              color: isToday
                                  ? colorScheme.primary
                                  : colorScheme.onSurface.withValues(alpha: 0.45),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: barPct,
                              minHeight: 8,
                              backgroundColor: isDark
                                  ? Colors.white.withValues(alpha: 0.04)
                                  : OrbitColors.warmGray100.withValues(alpha: 0.5),
                              valueColor: AlwaysStoppedAnimation(
                                isToday
                                    ? colorScheme.primary
                                    : colorScheme.primary.withValues(alpha: 0.35),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 50,
                          child: Text(
                            _formatNumber(entry.steps),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface.withValues(
                                  alpha: isToday ? 0.9 : 0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            );
          },
          loading: () => const SizedBox(
            height: 60,
            child: Center(child: CircularProgressIndicator(strokeWidth: 1.5)),
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
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
        child: Center(child: CircularProgressIndicator(strokeWidth: 1.5)),
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
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            Icons.calendar_month_rounded,
            size: 28,
            color: colorScheme.onSurface.withValues(alpha: 0.15),
          ),
          const SizedBox(height: 12),
          Text(
            'Monthly view will appear here\nas Orbit collects more data.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.35),
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsights(BuildContext context, AsyncValue insightsAsync) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ORBIT INSIGHTS',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: colorScheme.onSurface.withValues(alpha: 0.35),
          ),
        ),
        const SizedBox(height: 10),
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
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurface.withValues(alpha: 0.35),
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
            height: 50,
            child: Center(child: CircularProgressIndicator(strokeWidth: 1.5)),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? OrbitColors.darkElevated : OrbitColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: OrbitShadows.card,
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : OrbitColors.warmGray200.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 16,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
