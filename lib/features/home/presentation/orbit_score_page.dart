import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/orbit_colors.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../core/theme/orbit_gradients.dart';
import '../../../core/theme/orbit_theme.dart';
import '../../../shared/widgets/orbit_hero_score.dart';
import '../../../shared/widgets/orbit_insight_card_v2.dart';
import '../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../insights/presentation/providers/insight_providers.dart';
import '../../settings/presentation/providers/preferences_providers.dart';
import '../../score/presentation/providers/score_providers.dart';
import '../../health/presentation/providers/health_providers.dart';

/// CENTER PAGE — Orbit Score Home.
/// Displays real score, baseline comparison, category metrics, and daily insights.
class OrbitScorePage extends ConsumerWidget {
  const OrbitScorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final prefsAsync = ref.watch(userPreferencesProvider);
    final sevenDaysAsync = ref.watch(lastSevenDaysScoresProvider);

    return dashboardAsync.when(
      data: (state) {
        return Theme(
          data: OrbitTheme.light,
          child: Builder(
            builder: (lightContext) {
              final userName = prefsAsync.asData?.value.userName ?? 'User';
              final greeting = _getGreeting();

              // Compute 7-day baseline comparison strictly from real historical scores
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

              // Motivation text based strictly on state
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

              return RefreshIndicator(
                onRefresh: () async {
                  await ref.read(healthSyncNotifierProvider.notifier).sync();
                  ref.invalidate(dailyInsightsProvider);
                  ref.invalidate(dashboardProvider);
                  await ref.read(dashboardProvider.future);
                },
                child: Stack(
                  children: [
                    // Warm cream background gradient matching the reference
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFF8F2ED),
                              Color(0xFFFFEFE6),
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
                          _buildHeader(lightContext, greeting, userName, false),
                          const SizedBox(height: 14),
                          _buildCurvedDaySelector(lightContext, false),
                          const SizedBox(height: 16),
                          Center(
                            child: OrbitHeroScore(
                              score: state.orbitScore.totalScore,
                              progress: (state.orbitScore.totalScore / 100)
                                  .clamp(0.0, 1.0),
                              baselineText: baselineText,
                              motivationTitle: motivationTitle,
                              motivationSubtitle: motivationSubtitle,
                            ),
                          ),
                          const SizedBox(height: 22),
                          _buildCategoryGrid(lightContext, state, false),
                          const SizedBox(height: 18),
                          _buildInsightsSection(lightContext, ref, false),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
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

  Widget _buildHeader(
    BuildContext context,
    String greeting,
    String userName,
    bool isDark,
  ) {
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
                color: colorScheme.onSurface.withValues(alpha: 0.72),
                height: 1.1,
              ),
            ),
            Text(
              userName,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
                letterSpacing: -0.7,
                height: 1.02,
              ),
            ),
          ],
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? const [Color(0xFF4B403A), Color(0xFF1C1816)]
                      : const [Color(0xFFE8DED5), Color(0xFFD7C8BC)],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: isDark ? 0.10 : 0.75),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: OrbitColors.copper500.withValues(alpha: 0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.person_rounded,
                size: 24,
                color: isDark ? Colors.white : OrbitColors.warmGray800,
              ),
            ),
            Positioned(
              top: 2,
              right: -1,
              child: Container(
                width: 11,
                height: 11,
                decoration: BoxDecoration(
                  color: OrbitColors.copper500,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? OrbitColors.darkBackground : OrbitColors.warmWhite,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCurvedDaySelector(BuildContext context, bool isDark) {
    final now = DateTime.now();
    // Days of the week around today
    final days = List.generate(5, (index) {
      final d = now.add(Duration(days: index - 2));
      final dayName = _getDayAbbr(d.weekday);
      return (dayName: dayName, dayNum: d.day, isToday: index == 2);
    });

    // Y offsets for downward orbital arc curve: [14, 4, 0, 4, 14]
    const yOffsets = [14.0, 4.0, 0.0, 4.0, 14.0];
    const opacities = [0.45, 0.75, 1.0, 0.75, 0.45];

    return SizedBox(
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Gentle dashed orbital trajectory curve line
          CustomPaint(
            size: const Size(double.infinity, 60),
            painter: _CurvedDayArcPainter(isDark: isDark),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (i) {
              final item = days[i];
              final offsetY = yOffsets[i];
              final opacity = opacities[i];

              if (item.isToday) {
                return Transform.translate(
                  offset: Offset(0, offsetY),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.dayName,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: OrbitColors.copper500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x33E96832),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${item.dayNum}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF171514),
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: OrbitColors.copper500,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Transform.translate(
                offset: Offset(0, offsetY),
                child: Opacity(
                  opacity: opacity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.dayName,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : const Color(0xFF78716C),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${item.dayNum}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF171514),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  String _getDayAbbr(int weekday) {
    const abbrs = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return abbrs[(weekday - 1) % 7];
  }

  /// 2x2 Category Grid driven strictly by real provider state.
  Widget _buildCategoryGrid(BuildContext context, dynamic state, bool isDark) {
    final tasksTotal = (state.tasksCompleted + state.tasksRemaining);
    final tasksValStr = '${state.tasksCompleted} / $tasksTotal';
    final tasksPct = tasksTotal > 0
        ? (state.tasksCompleted / tasksTotal * 100).toInt()
        : 0;

    final focusMin = state.focusMinutesCompleted;
    final focusPct = state.focusMinutesTarget > 0
        ? (focusMin / state.focusMinutesTarget * 100).toInt().clamp(0, 100)
        : 0;

    final goalsTotal = state.goalsCompleted + state.goalsRemaining;
    final habitsValStr = '${state.goalsCompleted} / $goalsTotal';
    final habitsPct = goalsTotal > 0
        ? (state.goalsCompleted / goalsTotal * 100).toInt()
        : 0;

    final healthStepsStr = _formatNumber(state.healthSteps);
    const dailyStepGoal = 10000;
    final healthPct = (state.healthSteps / dailyStepGoal * 100).toInt().clamp(0, 100);

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
                        'No insights available yet for today.',
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

/// Category Card widget for 2x2 grid
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
        color: isDark ? OrbitColors.darkElevated : const Color(0xFFFAF6F2),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.04),
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
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: isDark ? Colors.white60 : const Color(0xFF78716C),
                ),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: OrbitColors.copper500.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 13,
                  color: OrbitColors.copper500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF171514),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : const Color(0xFFEFE8E2),
              valueColor: const AlwaysStoppedAnimation(OrbitColors.copper500),
            ),
          ),
        ],
      ),
    );
  }
}

/// Painter for the dashed orbital trajectory line under day selector
class _CurvedDayArcPainter extends CustomPainter {
  final bool isDark;

  _CurvedDayArcPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final start = Offset(16, size.height * 0.45);
    final control = Offset(size.width / 2, size.height * 0.95);
    final end = Offset(size.width - 16, size.height * 0.45);

    path.moveTo(start.dx, start.dy);
    path.quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);

    final paint = Paint()
      ..color = (isDark ? Colors.white : const Color(0xFF171514)).withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Draw thin dashed curve line
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final len = (distance + 4.0) > metric.length ? (metric.length - distance) : 4.0;
        final extractPath = metric.extractPath(distance, distance + len);
        canvas.drawPath(extractPath, paint);
        distance += len + 5.0;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CurvedDayArcPainter oldDelegate) => false;
}
