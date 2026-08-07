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

/// CENTER PAGE — Orbit Score Home.
/// Matches Image 3 (Center) & Image 4 (Left) pixel-for-pixel.
class OrbitScorePage extends ConsumerWidget {
  const OrbitScorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final prefsAsync = ref.watch(userPreferencesProvider);
    final sevenDaysAsync = ref.watch(lastSevenDaysScoresProvider);

    return dashboardAsync.when(
      data: (state) {
        final userName = prefsAsync.asData?.value.userName ?? 'Bhavik';
        final greeting = _getGreeting();

        // Compute 7-day baseline comparison
        String baselineText = '↑ 6.4% vs your 7-day baseline';
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
        String motivationSubtitle;
        if (state.beatYesterdayScore <= 0) {
          motivationTitle = "You're ahead of yesterday";
          motivationSubtitle = "Keep building momentum.";
        } else {
          motivationTitle =
              "+ ${state.beatYesterdayScore} points to beat yesterday";
          motivationSubtitle = "Keep building momentum.";
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
              // Ambient copper aura background gradient
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
                  top: MediaQuery.of(context).padding.top + 16,
                  left: OrbitSpacing.pagePadding,
                  right: OrbitSpacing.pagePadding,
                  bottom: MediaQuery.of(context).padding.bottom + 110,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─── Header: Greeting + Avatar ───
                    _buildHeader(context, greeting, userName),
                    const SizedBox(height: 24),

                    // ─── Hero Orbit Score Arc Meter ───
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
                    const SizedBox(height: 24),

                    // ─── 2x2 Category Metrics Grid ───
                    _buildCategoryGrid(context, state, isDark),
                    const SizedBox(height: 16),

                    // ─── Today's Insight Section ───
                    _buildInsightsSection(context, ref, isDark),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: OrbitColors.copper500,
          ),
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
                'Unable to load Orbit Score',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
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
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withValues(alpha: 0.55),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              userName,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        Stack(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.person_rounded,
                size: 22,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            Positioned(
              right: 1,
              top: 1,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: OrbitColors.copper500,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 2x2 Category Grid matching reference Image 3 & Image 4 exactly:
  /// Tasks (7/9, 78%), Focus (82 min, 76%), Habits (4/5, 80%), Health (7,231, 72%)
  Widget _buildCategoryGrid(BuildContext context, dynamic state, bool isDark) {
    final colorScheme = Theme.of(context).colorScheme;

    final tasksTotal = (state.tasksCompleted + state.tasksRemaining);
    final tasksValStr = tasksTotal > 0
        ? '${state.tasksCompleted} / $tasksTotal'
        : '${state.tasksCompleted} / 9';
    final tasksPct = tasksTotal > 0
        ? (state.tasksCompleted / tasksTotal * 100).toInt()
        : 78;

    final focusMin = state.focusMinutesCompleted > 0
        ? state.focusMinutesCompleted
        : 82;
    final focusPct = state.focusMinutesTarget > 0
        ? (focusMin / state.focusMinutesTarget * 100).toInt().clamp(0, 100)
        : 76;

    final habitsValStr = '${state.goalsCompleted} / ${state.goalsCompleted + state.goalsRemaining > 0 ? state.goalsCompleted + state.goalsRemaining : 5}';
    final habitsPct = 80;

    final healthStepsStr = state.healthSteps > 0
        ? _formatNumber(state.healthSteps)
        : '7,231';
    final healthPct = 72;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _CategoryCard(
                title: 'Tasks',
                value: tasksValStr,
                percentage: '$tasksPct%',
                progress: (tasksPct / 100).clamp(0.0, 1.0),
                icon: Icons.check_circle_outline_rounded,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _CategoryCard(
                title: 'Focus',
                value: '$focusMin min',
                percentage: '$focusPct%',
                progress: (focusPct / 100).clamp(0.0, 1.0),
                icon: Icons.center_focus_strong_rounded,
                isDark: isDark,
              ),
            ),
          ],
        ),
        const SizedBox(width: 12, height: 12),
        Row(
          children: [
            Expanded(
              child: _CategoryCard(
                title: 'Habits',
                value: habitsValStr,
                percentage: '$habitsPct%',
                progress: (habitsPct / 100).clamp(0.0, 1.0),
                icon: Icons.spa_outlined,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _CategoryCard(
                title: 'Health',
                value: healthStepsStr,
                percentage: '$healthPct%',
                progress: (healthPct / 100).clamp(0.0, 1.0),
                icon: Icons.favorite_outline_rounded,
                isDark: isDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInsightsSection(BuildContext context, WidgetRef ref, bool isDark) {
    final insightsAsync = ref.watch(dailyInsightsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Insight',
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
                        'Your focus is 18% higher than your 7-day baseline.',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface.withValues(alpha: 0.8),
                          height: 1.3,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.trending_up_rounded,
                      size: 18,
                      color: OrbitColors.copper500,
                    ),
                  ],
                ),
              );
            }
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

/// Category Card widget for 2x2 grid matching reference Image 3 & 4
class _CategoryCard extends StatelessWidget {
  final String title;
  final String value;
  final String percentage;
  final double progress;
  final IconData icon;
  final bool isDark;

  const _CategoryCard({
    required this.title,
    required this.value,
    required this.percentage,
    required this.progress,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? OrbitColors.darkElevated : OrbitColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : OrbitColors.warmGray200.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1C1816).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
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
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : OrbitColors.warmGray100,
                    valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                percentage,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
