import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/orbit_colors.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../core/theme/orbit_typography.dart';
import '../../../core/theme/orbit_gradients.dart';
import '../../../shared/widgets/orbit_hero_score.dart';
import '../../../shared/widgets/orbit_insight_card_v2.dart';
import '../../../shared/providers/data_providers.dart';
import '../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../insights/presentation/providers/insight_providers.dart';
import '../../settings/presentation/providers/preferences_providers.dart';
import '../../score/presentation/providers/score_providers.dart';
import '../../health/presentation/providers/health_providers.dart';

/// CENTER PAGE — Orbit Score. Premium personal instrument.
/// The score visually dominates the entire page.
class OrbitScorePage extends ConsumerWidget {
  const OrbitScorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final prefsAsync = ref.watch(userPreferencesProvider);
    final sevenDaysAsync = ref.watch(lastSevenDaysScoresProvider);

    return dashboardAsync.when(
      data: (state) {
        final userName = prefsAsync.asData?.value.userName ?? 'there';
        final greeting = _getGreeting();

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

        final isDark = Theme.of(context).brightness == Brightness.dark;
        final colorScheme = Theme.of(context).colorScheme;

        return RefreshIndicator(
          onRefresh: () async {
            await ref.read(healthSyncNotifierProvider.notifier).sync();
            ref.invalidate(dailyInsightsProvider);
            ref.invalidate(dashboardProvider);
            await ref.read(dashboardProvider.future);
          },
          child: Stack(
            children: [
              // Ambient copper aura background
              if (!isDark)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: OrbitGradients.copperAura,
                    ),
                  ),
                ),

              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 20,
                  left: OrbitSpacing.pagePadding,
                  right: OrbitSpacing.pagePadding,
                  bottom: MediaQuery.of(context).padding.bottom + 100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─── Greeting + Avatar ───
                    _buildHeader(context, greeting, userName),
                    const SizedBox(height: 40),

                    // ─── Hero Score (sole visual hero) ───
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
                    const SizedBox(height: 40),

                    // ─── Today's Insight (single elegant element) ───
                    _buildInsightsSection(context, ref),

                    const SizedBox(height: 24),

                    // ─── Subtle supporting info: category summary ───
                    _buildCategorySummary(context, state),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: OrbitColors.copper500,
              ),
            ),
          ],
        ),
      ),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, size: 40,
                  color: Colors.red.withValues(alpha: 0.6)),
              OrbitSpacing.vGapMd,
              Text(
                'Unable to load your Orbit Score',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              OrbitSpacing.vGapSm,
              Text(
                '$e',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.4),
                    ),
              ),
              OrbitSpacing.vGapLg,
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
                color: colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              userName,
              style: OrbitTypography.userName.copyWith(
                color: colorScheme.onSurface,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            Icons.person_rounded,
            size: 20,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }

  /// Subtle supporting info — compact text-only category summary.
  /// Replaces the removed 2x2 metric grid with minimal text.
  Widget _buildCategorySummary(BuildContext context, dynamic state) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final totalTasks = state.tasksCompleted + state.tasksRemaining;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : OrbitColors.warmGray50.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.04)
              : OrbitColors.warmGray200.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TODAY\'S BREAKDOWN',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: colorScheme.onSurface.withValues(alpha: 0.35),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _SummaryItem(
                label: 'Tasks',
                value: '${state.tasksCompleted}/$totalTasks',
                color: colorScheme.primary,
              ),
              _SummaryItem(
                label: 'Focus',
                value: '${state.focusMinutesCompleted}m',
                color: OrbitColors.copper400,
              ),
              _SummaryItem(
                label: 'Health',
                value: _formatNumber(state.healthSteps),
                color: OrbitColors.copper600,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsSection(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(dailyInsightsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'INSIGHT',
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
            if (insights.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Log your activities to unlock personalized insights.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                        height: 1.4,
                      ),
                ),
              );
            }
            // Show the first (highest priority) insight
            return OrbitInsightCardV2(insight: insights.first);
          },
          loading: () => const SizedBox(
            height: 50,
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 1.5),
            ),
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

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}
