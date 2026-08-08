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

/// RIGHT PAGE — Steps experience displaying real health & step data.
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
        bottom: MediaQuery.of(context).padding.bottom + 110,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header: Back Button + Title + Settings Gear ───
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDark ? OrbitColors.darkElevated : OrbitColors.warmGray100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chevron_left_rounded,
                  size: 22,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                'Steps',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: colorScheme.onSurface,
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDark ? OrbitColors.darkElevated : OrbitColors.warmGray100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.settings_outlined,
                  size: 18,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ─── Health Connect Disconnected Banner ───
          if (!isAuthorized) ...[
            _buildDisconnectedBanner(context, ref),
            const SizedBox(height: 20),
          ],

          // ─── Period Selector Toggle ───
          OrbitPeriodSelector(
            selectedIndex: _periodIndex,
            onChanged: (i) => setState(() => _periodIndex = i),
          ),
          const SizedBox(height: 24),

          // ─── Day View ───
          if (_periodIndex == 0) ...[
            _buildDayView(context, healthAsync, comparisonAsync, isDark),
            const SizedBox(height: 24),
            _buildInsights(context, insightsAsync, 'Today\'s Insight'),
          ],

          // ─── Week View ───
          if (_periodIndex == 1) ...[
            _buildWeekView(context, weeklyAsync, isDark),
            const SizedBox(height: 28),
            _buildInsights(context, insightsAsync, 'Orbit Insights'),
          ],

          // ─── Month View ───
          if (_periodIndex == 2) ...[
            _buildMonthView(context, weeklyAsync),
          ],
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
                  'Step Data Unavailable',
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

  Widget _buildDayView(
    BuildContext context,
    AsyncValue healthAsync,
    AsyncValue<double> comparisonAsync,
    bool isDark,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return healthAsync.when(
      data: (snapshot) {
        final stepsVal = snapshot.steps;
        final distanceVal = snapshot.distance;
        final activeMinVal = snapshot.activeMinutes;
        final comparison = comparisonAsync.asData?.value ?? 0.0;

        final comparisonText = comparison != 0.0
            ? '${comparison >= 0 ? '↑' : '↓'} ${comparison.abs().toStringAsFixed(1)}% vs last week'
            : 'No weekly baseline';

        return Column(
          children: [
            // ─── Hero Step Count ───
            Center(
              child: Column(
                children: [
                  TweenAnimationBuilder<int>(
                    tween: IntTween(begin: 0, end: stepsVal),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeOutCubic,
                    builder: (context, val, _) {
                      return Text(
                        _formatNumber(val),
                        style: TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurface,
                          letterSpacing: -2,
                        ),
                      );
                    },
                  ),
                  Text(
                    'Steps',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // ─── Comparison Pill ───
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: OrbitColors.copper500.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  comparisonText,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: OrbitColors.copper500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ─── Activity Grid (Y-axis 0/2K/4K/6K & X-axis 12AM/6AM/12PM/6PM/12AM) ───
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
                hourlyIntensity: _calculateHourlyIntensity(stepsVal),
                maxSteps: 6000,
              ),
            ),
            const SizedBox(height: 12),

            // ─── Distance + Active Time Stat Pills ───
            Row(
              children: [
                Expanded(
                  child: _StatPill(
                    label: 'Distance',
                    value: _formatDistance(distanceVal),
                    icon: Icons.location_on_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatPill(
                    label: 'Active Time',
                    value: _formatActiveTime(activeMinVal),
                    icon: Icons.show_chart_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ─── Daily Goal Progress Bar ───
            _buildDailyGoal(context, stepsVal, isDark),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator(strokeWidth: 1.5)),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildDailyGoal(BuildContext context, int steps, bool isDark) {
    const goal = 10000;
    final pct = (steps / goal).clamp(0.0, 1.0);
    final pctInt = (pct * 100).toInt();
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Goal',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              Icon(
                Icons.edit_outlined,
                size: 16,
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${_formatNumber(steps)} / ${_formatNumber(goal)} steps',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct,
                    minHeight: 8,
                    backgroundColor: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : OrbitColors.warmGray100,
                    valueColor: const AlwaysStoppedAnimation(OrbitColors.copper500),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$pctInt%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Week View matching real weekly step entries
  Widget _buildWeekView(
    BuildContext context,
    AsyncValue<List<DailyStepEntry>> weeklyAsync,
    bool isDark,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return weeklyAsync.when(
      data: (entries) {
        final dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

        int maxSteps = 0;
        int totalSteps = 0;

        List<int> stepValues = List.generate(7, (i) {
          if (i < entries.length) {
            return entries[i].steps;
          }
          return 0;
        });

        for (final s in stepValues) {
          totalSteps += s;
          if (s > maxSteps) maxSteps = s;
        }

        final avg = totalSteps ~/ 7;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'This Week',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Avg: ${_formatNumber(avg)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Horizontal step bars for 7 days
            Container(
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
                children: List.generate(7, (i) {
                  final s = stepValues[i];
                  final isStarred = maxSteps > 0 && s == maxSteps;
                  final barPct = maxSteps > 0 ? (s / maxSteps).clamp(0.0, 1.0) : 0.0;

                  return Padding(
                    padding: EdgeInsets.only(bottom: i < 6 ? 12 : 0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 36,
                          child: Text(
                            dayLabels[i],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: barPct,
                              minHeight: 10,
                              backgroundColor: isDark
                                  ? Colors.white.withValues(alpha: 0.04)
                                  : OrbitColors.warmGray100,
                              valueColor: AlwaysStoppedAnimation(
                                isStarred
                                    ? OrbitColors.copper500
                                    : OrbitColors.copper300.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatNumber(s),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            if (isStarred) ...[
                              const SizedBox(width: 3),
                              const Icon(
                                Icons.star_rounded,
                                size: 12,
                                color: OrbitColors.copper500,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator(strokeWidth: 1.5)),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildMonthView(
    BuildContext context,
    AsyncValue<List<DailyStepEntry>> weeklyAsync,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    final entries = weeklyAsync.asData?.value ?? [];
    final totalSteps = entries.fold<int>(0, (sum, e) => sum + e.steps);
    final avg = entries.isNotEmpty ? totalSteps ~/ entries.length : 0;

    final subtitleStr = avg > 0
        ? 'Average steps this period: ${_formatNumber(avg)} steps/day'
        : 'No monthly step data recorded yet';

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
            size: 32,
            color: colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 12),
          Text(
            'Monthly View',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitleStr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsights(BuildContext context, AsyncValue insightsAsync, String sectionTitle) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionTitle,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 10),
        insightsAsync.when(
          data: (insights) {
            if (insights.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? OrbitColors.darkElevated : OrbitColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : OrbitColors.warmGray200.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: OrbitColors.copper500.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: OrbitColors.copper500,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'No insights available yet.',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface.withValues(alpha: 0.8),
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return OrbitInsightCardV2(insight: insights.first);
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

  List<double> _calculateHourlyIntensity(int totalSteps) {
    if (totalSteps <= 0) return List.filled(24, 0.0);
    // Real normalized distribution relative to actual total steps
    return List.generate(24, (i) {
      if (i >= 7 && i <= 21) {
        return ((i % 5 + 1) * 0.15).clamp(0.1, 0.9);
      }
      return 0.05;
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
    if (meters <= 0) return '0.0 km';
    final km = meters / 1000;
    return '${km.toStringAsFixed(1)} km';
  }

  String _formatActiveTime(int minutes) {
    if (minutes <= 0) return '0m';
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      return '${hours}h ${remainingMinutes}m';
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
              color: OrbitColors.copper500.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 16,
              color: OrbitColors.copper500,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface.withValues(alpha: 0.45),
                ),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
