import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/orbit_colors.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../core/theme/orbit_shadows.dart';
import '../../../core/theme/orbit_theme.dart';
import '../../../shared/widgets/orbit_glass_card.dart';
import '../../../shared/widgets/orbit_period_selector.dart';
import '../../../shared/widgets/orbit_activity_grid.dart';
import '../../../shared/widgets/orbit_insight_card_v2.dart';
import '../../health/presentation/providers/health_providers.dart';
import '../../health/presentation/providers/steps_page_providers.dart';
import '../../insights/presentation/providers/insight_providers.dart';
import '../../settings/domain/user_preferences.dart';
import '../../settings/presentation/providers/preferences_providers.dart';
import 'widgets/orbit_heart_rate_card.dart';
import 'widgets/orbit_sleep_card.dart';
import 'widgets/orbit_calories_card.dart';
import 'widgets/orbit_activity_card.dart';

/// RIGHT PAGE — Steps analytics experience displaying real personal performance metrics.
class OrbitStepsPage extends ConsumerStatefulWidget {
  final VoidCallback? onNavigateBack;

  const OrbitStepsPage({super.key, this.onNavigateBack});

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
    final monthlyAsync = ref.watch(monthlyStepsProvider);
    final todayHourlyAsync = ref.watch(todayHourlyStepsProvider);
    final insightsAsync = ref.watch(dailyInsightsProvider);
    final prefsAsync = ref.watch(userPreferencesStreamProvider);
    final stepGoal = prefsAsync.asData?.value.stepGoal ?? 10000;

    final isAuthorized = healthAuthAsync.asData?.value ?? false;
    final hourlyIntensity = todayHourlyAsync.asData?.value ?? List.filled(24, 0.0);

    return Theme(
      data: OrbitTheme.light,
      child: Builder(
        builder: (lightContext) {
          return Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFFFBF8),
                        Color(0xFFFFF1E8),
                      ],
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  top: MediaQuery.of(lightContext).padding.top + 16,
                  left: OrbitSpacing.pagePadding,
                  right: OrbitSpacing.pagePadding,
                  bottom: MediaQuery.of(lightContext).padding.bottom + 110,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(lightContext, false),
                    const SizedBox(height: 22),
                    if (!isAuthorized) ...[
                      _buildDisconnectedBanner(lightContext, ref),
                      const SizedBox(height: 18),
                    ],
                    OrbitPeriodSelector(
                      selectedIndex: _periodIndex,
                      onChanged: (i) => setState(() => _periodIndex = i),
                    ),
                    const SizedBox(height: 26),
                    if (_periodIndex == 0) ...[
                      _buildDayView(
                        lightContext,
                        healthAsync,
                        comparisonAsync,
                        hourlyIntensity,
                        false,
                        stepGoal: stepGoal,
                      ),
                    ] else if (_periodIndex == 1) ...[
                      _buildWeekView(lightContext, weeklyAsync, false),
                    ] else ...[
                      _buildMonthView(lightContext, monthlyAsync, false),
                    ],
                    const SizedBox(height: 24),
                    _buildInsights(lightContext, insightsAsync, 'Orbit Insights'),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _HeaderIcon(
          icon: Icons.chevron_left_rounded,
          isDark: isDark,
          onTap: widget.onNavigateBack ?? () {},
        ),
        Text(
          'Steps',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: colorScheme.onSurface,
            letterSpacing: -0.3,
          ),
        ),
        _HeaderIcon(
          icon: Icons.settings_rounded,
          isDark: isDark,
          onTap: () async {
            await ref.read(healthSyncNotifierProvider.notifier).sync();
            ref.invalidate(todayHealthSnapshotProvider);
            ref.invalidate(todayHeartRateSamplesProvider);
            ref.invalidate(todayHourlyStepsProvider);
            ref.invalidate(sleepHistoryProvider(7));
            ref.invalidate(stepHistoryProvider(7));
            ref.invalidate(workoutHistoryProvider(7));
            ref.invalidate(weeklyStepsProvider);
            ref.invalidate(monthlyStepsProvider);
            ref.invalidate(stepsComparisonProvider);
          },
        ),
      ],
    );
  }

  Widget _buildHealthSignalsHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      'More Health Signals',
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface.withValues(alpha: 0.82),
      ),
    );
  }

  Future<void> _requestHealthAuth(WidgetRef ref) async {
    final success = await ref.read(healthServiceProvider).requestAuthorization();
    ref.invalidate(healthAuthorizationProvider);
    ref.invalidate(todayHealthSnapshotProvider);
    ref.invalidate(todayHeartRateSamplesProvider);
    ref.invalidate(todayHourlyStepsProvider);

    if (success) {
      await ref.read(healthSyncNotifierProvider.notifier).sync();
      ref.invalidate(todayHealthSnapshotProvider);
    }
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
            onPressed: () => _requestHealthAuth(ref),
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
    AsyncValue<double?> comparisonAsync,
    List<double> hourlyIntensity,
    bool isDark, {
    required int stepGoal,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return healthAsync.when(
      data: (snapshot) {
        final stepsVal = snapshot.steps;
        final distanceVal = snapshot.distance;
        final activeMinVal = snapshot.activeMinutes;
        final comparison = comparisonAsync.asData?.value;

        final comparisonText = comparison != null
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
                    'Steps Today',
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

            // ─── Activity Grid (Real Hourly Intensity Pipeline) ───
            OrbitGlassCard(
              radius: 22,
              dark: isDark,
              padding: const EdgeInsets.all(16),
              child: OrbitActivityGrid(
                hourlyIntensity: hourlyIntensity,
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
            _buildDailyGoal(context, stepsVal, isDark, stepGoal),
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

  /// Opens an editor sheet allowing the user to change their daily step goal.
  Future<void> _editStepGoal(
    BuildContext context,
    WidgetRef ref,
    int currentGoal,
  ) async {
    final controller = TextEditingController(text: currentGoal.toString());
    final colorScheme = Theme.of(context).colorScheme;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(sheetContext).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Step Goal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  style: TextStyle(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    labelText: 'Steps',
                    suffixText: 'steps',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [6000, 8000, 10000, 12000]
                      .map(
                        (preset) => ActionChip(
                          label: Text(_formatNumber(preset)),
                          onPressed: () =>
                              controller.text = preset.toString(),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: OrbitColors.copper500,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      final parsed = int.tryParse(controller.text);
                      if (parsed == null || parsed < 1000) return;

                      final currentPrefs = ref
                              .read(preferencesNotifierProvider).value ??
                          UserPreferences.defaultValues();
                      ref
                          .read(preferencesNotifierProvider.notifier)
                          .updatePreferences(
                            currentPrefs.copyWith(stepGoal: parsed),
                          );
                      Navigator.of(sheetContext).pop();
                    },
                    child: const Text(
                      'Save Goal',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDailyGoal(
    BuildContext context,
    int steps,
    bool isDark,
    int stepGoal,
  ) {
    final goal = stepGoal > 0 ? stepGoal : 10000;
    final pct = (steps / goal).clamp(0.0, 1.0);
    final pctInt = (pct * 100).toInt();
    final colorScheme = Theme.of(context).colorScheme;

    return OrbitGlassCard(
      radius: 22,
      dark: isDark,
      padding: const EdgeInsets.all(16),
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
              GestureDetector(
                onTap: () => _editStepGoal(context, ref, goal),
                child: Icon(
                  Icons.edit_outlined,
                  size: 16,
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                ),
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
                  avg > 0 ? 'Avg: ${_formatNumber(avg)}' : 'No data recorded',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

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
    AsyncValue<List<DailyStepEntry>> monthlyAsync,
    bool isDark,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return monthlyAsync.when(
      data: (entries) {
        final totalSteps = entries.fold<int>(0, (sum, e) => sum + e.steps);
        final activeDays = entries.where((e) => e.steps > 0).length;
        final avg = activeDays > 0 ? totalSteps ~/ entries.length : 0;
        int maxSteps = 0;
        for (var e in entries) {
          if (e.steps > maxSteps) maxSteps = e.steps;
        }

        final subtitleStr = totalSteps > 0
            ? '30-Day Total: ${_formatNumber(totalSteps)} • Avg ${_formatNumber(avg)} steps/day'
            : 'No monthly step data recorded yet';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '30-Day Monthly View',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  '$activeDays / 30 active days',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subtitleStr,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (totalSteps > 0)
                    SizedBox(
                      height: 100,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: entries.map((e) {
                          final pct = maxSteps > 0 ? (e.steps / maxSteps).clamp(0.0, 1.0) : 0.0;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 1.0),
                              child: Tooltip(
                                message: '${e.date.day}/${e.date.month}: ${_formatNumber(e.steps)} steps',
                                child: Container(
                                  height: (100 * pct).clamp(4.0, 100.0),
                                  decoration: BoxDecoration(
                                    color: e.steps > 0
                                        ? OrbitColors.copper500.withValues(alpha: (0.4 + pct * 0.6))
                                        : (isDark
                                            ? Colors.white.withValues(alpha: 0.05)
                                            : OrbitColors.warmGray200),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Center(
                        child: Text(
                          'No step data recorded for this month',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 140,
        child: Center(child: CircularProgressIndicator(strokeWidth: 1.5)),
      ),
      error: (_, __) => const SizedBox.shrink(),
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

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;

  const _HeaderIcon({
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.white.withValues(alpha: 0.62),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.05),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 21,
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
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

    return OrbitGlassCard(
      radius: 18,
      blur: 14,
      dark: isDark,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
