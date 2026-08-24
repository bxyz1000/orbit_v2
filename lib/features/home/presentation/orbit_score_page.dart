import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/orbit_colors.dart';
import '../../../core/theme/orbit_motion.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../shared/providers/repository_providers.dart';
import '../../../shared/widgets/orbit_hero_score.dart';
import '../../../shared/widgets/orbit_glass_card.dart';
import '../../../shared/widgets/orbit_insight_card_v2.dart';
import '../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../dashboard/domain/entities/dashboard_state.dart';
import '../../insights/presentation/providers/insight_providers.dart';
import '../../insights/domain/entities/orbit_insight.dart';
import '../../settings/presentation/providers/preferences_providers.dart';
import '../../score/presentation/providers/score_providers.dart';
import '../../health/presentation/providers/health_providers.dart';
import '../../score/domain/entities/daily_score.dart';
import '../../tasks/presentation/tasks_page.dart';
import 'widgets/score_breakdown_bars.dart';

/// CENTER PAGE — Orbit Score Home.
/// The Orbit Score is the sole hero: tappable day-strip time travel,
/// tap-for-breakdown sheet, live insight carousel, streak ember,
/// beat-yesterday meter and breathing copper aura — all driven strictly
/// by real provider data.
class OrbitScorePage extends ConsumerStatefulWidget {
  const OrbitScorePage({super.key});

  @override
  ConsumerState<OrbitScorePage> createState() => _OrbitScorePageState();
}

class _OrbitScorePageState extends ConsumerState<OrbitScorePage> {
  final ScrollController _scrollController = ScrollController();
  final PageController _insightController =
      PageController(viewportFraction: 0.92);

  /// Selected day relative to today: 0 = today, -1 = yesterday, -2 = two
  /// days ago. Future days are shown but not selectable (no data yet).
  int _selectedOffset = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    _insightController.dispose();
    super.dispose();
  }

  /// sevenDays is ordered [6 days ago ... today], so index 6 == today.
  DailyScore? _scoreForOffset(List<DailyScore> sevenDays, int offset) {
    final index = 6 + offset;
    if (index < 0 || index >= sevenDays.length) return null;
    return sevenDays[index];
  }

  @override
  Widget build(BuildContext context) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final prefsAsync = ref.watch(userPreferencesProvider);
    final sevenDaysAsync = ref.watch(lastSevenDaysScoresProvider);
    final streakAsync = ref.watch(currentStreakProvider);

    return dashboardAsync.when(
      data: (state) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final userName = prefsAsync.asData?.value.userName ?? 'User';
        final greeting = _getGreeting();
        final sevenDays = sevenDaysAsync.asData?.value ?? const <DailyScore>[];
        final isToday = _selectedOffset == 0;
        final selectedScore =
            _scoreForOffset(sevenDays, _selectedOffset) ?? state.orbitScore;

        return RefreshIndicator(
          color: OrbitColors.copper500,
          onRefresh: () async {
            await ref.read(healthSyncNotifierProvider.notifier).sync();
            ref.invalidate(dailyInsightsProvider);
            ref.invalidate(dashboardProvider);
            ref.invalidate(lastSevenDaysScoresProvider);
            ref.invalidate(currentStreakProvider);
            await ref.read(dashboardProvider.future);
            if (mounted) OrbitMotion.medium();
          },
          child: Stack(
            children: [
              // Time-of-day warm gradient (cream in light, warm dark in dark)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: _backgroundColors(isDark),
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                controller: _scrollController,
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
                    // Header drifts slightly slower than the scroll (parallax)
                    AnimatedBuilder(
                      animation: _scrollController,
                      builder: (context, child) {
                        final offset = _scrollController.hasClients
                            ? _scrollController.offset
                            : 0.0;
                        return Transform.translate(
                          offset: Offset(0, (offset * 0.22).clamp(0.0, 42.0)),
                          child: child,
                        );
                      },
                      child: _buildHeader(
                        context,
                        greeting,
                        userName,
                        isDark,
                        streakAsync.asData?.value ?? 0,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildDaySelector(context, sevenDays),
                    const SizedBox(height: 16),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          OrbitMotion.light();
                          _openBreakdownSheet(context, selectedScore, isToday);
                        },
                        child: OrbitHeroScore(
                          score: selectedScore.totalScore,
                          progress:
                              (selectedScore.totalScore / 100).clamp(0.0, 1.0),
                          baselineText:
                              _baselineText(state.orbitScore.totalScore, sevenDays, isToday),
                          motivationTitle: _motivationTitle(state, isToday),
                          motivationSubtitle:
                              isToday ? 'Keep building momentum.' : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Center(
                      child: Text(
                        isToday
                            ? 'Tap the score for a full breakdown'
                            : _fullDateLabel(selectedScore.date),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.45),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (isToday && state.orbitScore.totalScore == 0)
                      _buildCoachingCard(context, isDark)
                    else if (isToday)
                      _buildBeatYesterdayMeter(context, state, sevenDays),
                    const SizedBox(height: 16),
                    _buildInsightsSection(context),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const _ScoreSkeleton(),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 40, color: Colors.red.withValues(alpha: 0.6)),
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

  /// 7-day baseline badge — real history when available, honest state when not.
  String _baselineText(int todayScore, List<DailyScore> sevenDays, bool isToday) {
    if (!isToday) return 'Past day';
    if (sevenDays.length >= 7) {
      final avg =
          sevenDays.take(6).fold<int>(0, (s, d) => s + d.totalScore) / 6;
      if (avg > 0) {
        final pct = (todayScore - avg) / avg * 100;
        final sign = pct >= 0 ? '↑' : '↓';
        return '$sign ${pct.abs().toStringAsFixed(1)}% vs your 7-day baseline';
      }
    }
    return 'Building your baseline — every day counts';
  }

  String? _motivationTitle(DashboardState state, bool isToday) {
    if (!isToday) return null;
    if (state.beatYesterdayScore <= 0) return "You're ahead of yesterday";
    return '+ ${state.beatYesterdayScore} points to beat yesterday';
  }

  /// Warm gradient shifts subtly with the time of day.
  List<Color> _backgroundColors(bool isDark) {
    if (isDark) return const [Color(0xFF141110), Color(0xFF1C1816)];
    final hour = DateTime.now().hour;
    if (hour < 12) return const [Color(0xFFFDF4EA), Color(0xFFFFEFE6)];
    if (hour < 17) return const [Color(0xFFF8F2ED), Color(0xFFFFEFE6)];
    return const [Color(0xFFF6ECE6), Color(0xFFFBE7DC)];
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _getDayAbbr(int weekday) {
    const abbrs = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return abbrs[(weekday - 1) % 7];
  }

  String _fullDateLabel(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${_getDayAbbr(date.weekday)}, ${months[date.month - 1]} ${date.day}';
  }

  Widget _buildHeader(
    BuildContext context,
    String greeting,
    String userName,
    bool isDark,
    int streak,
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
        Row(
          children: [
            // Streak ember — only visible when a real streak exists.
            AnimatedScale(
              scale: streak > 0 ? 1.0 : 0.0,
              duration: OrbitMotion.base,
              curve: OrbitMotion.curve,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: OrbitColors.copper500.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: OrbitColors.copper500.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      size: 14,
                      color: OrbitColors.copper500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$streak',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: OrbitColors.copper500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
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
                      color:
                          Colors.white.withValues(alpha: isDark ? 0.10 : 0.75),
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
                        color: isDark
                            ? OrbitColors.darkBackground
                            : OrbitColors.warmWhite,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDaySelector(BuildContext context, List<DailyScore> sevenDays) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final today = DateTime.now();

    // Five slots: [-2, -1, today, +1, +2]. Future days render dimmed and
    // are not tappable (no score exists for them yet).
    const yOffsets = [14.0, 4.0, 0.0, 4.0, 14.0];
    const opacities = [0.45, 0.75, 1.0, 0.75, 0.45];

    return SizedBox(
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(double.infinity, 64),
            painter: _CurvedDayArcPainter(isDark: isDark),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (i) {
              final offset = i - 2;
              final date =
                  DateTime(today.year, today.month, today.day)
                      .add(Duration(days: offset));
              final isFuture = offset > 0;
              final isSelected = offset == _selectedOffset;
              final hasScore = _scoreForOffset(sevenDays, offset) != null;

              final Color dotColor = isSelected
                  ? OrbitColors.copper500
                  : (isFuture
                      ? Colors.transparent
                      : hasScore
                          ? OrbitColors.copper500.withValues(alpha: 0.35)
                          : colorScheme.onSurface.withValues(alpha: 0.15));

              return Transform.translate(
                offset: Offset(0, yOffsets[i]),
                child: Opacity(
                  opacity: isFuture ? opacities[i] * 0.55 : opacities[i],
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: isFuture
                        ? null
                        : () {
                            if (_selectedOffset == offset) return;
                            OrbitMotion.selection();
                            setState(() => _selectedOffset = offset);
                          },
                    child: AnimatedContainer(
                      duration: OrbitMotion.base,
                      curve: OrbitMotion.curve,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark
                                ? Colors.white.withValues(alpha: 0.10)
                                : Colors.white)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: isSelected
                            ? [
                                const BoxShadow(
                                  color: Color(0x33E96832),
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _getDayAbbr(date.weekday),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSelected
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              color: isSelected
                                  ? OrbitColors.copper500
                                  : colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: 2),
                          AnimatedContainer(
                            duration: OrbitMotion.base,
                            curve: OrbitMotion.curve,
                            width: isSelected ? 30 : 26,
                            height: isSelected ? 30 : 26,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (isDark
                                      ? OrbitColors.copper500
                                      : Colors.white)
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${date.day}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: isSelected
                                    ? (isDark
                                        ? Colors.white
                                        : const Color(0xFF171514))
                                    : colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: dotColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _openBreakdownSheet(
    BuildContext context,
    DailyScore score,
    bool isToday,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF201C19) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 12,
            bottom: MediaQuery.of(sheetContext).padding.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Score breakdown',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF171514),
                    ),
                  ),
                  Text(
                    '${score.totalScore}/100',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: OrbitColors.copper500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _fullDateLabel(score.date),
                style: TextStyle(
                  fontSize: 12,
                  color: (isDark ? Colors.white : Colors.black)
                      .withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 16),
              ScoreBreakdownBars(score: score),
            ],
          ),
        );
      },
    );
  }

  /// Data-driven coaching for a brand-new day — disappears once real
  /// points land on the board.
  Widget _buildCoachingCard(BuildContext context, bool isDark) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        OrbitMotion.light();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TasksPage(
              taskRepository: ref.read(taskRepositoryProvider),
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: OrbitColors.copper500.withValues(alpha: 0.25),
          ),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: const Color(0xFF322720).withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: OrbitColors.copper500.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.flag_rounded,
                size: 18,
                color: OrbitColors.copper500,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Start your orbit',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Complete a task or a focus session to earn your first points.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.3,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: OrbitColors.copper500,
            ),
          ],
        ),
      ),
    );
  }

  /// Today vs yesterday — a tiny instrument, not a sentence.
  Widget _buildBeatYesterdayMeter(
    BuildContext context,
    DashboardState state,
    List<DailyScore> sevenDays,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final today = state.orbitScore.totalScore;
    final yesterday = sevenDays.length >= 6 ? sevenDays[5].totalScore : 0;
    final fill = yesterday > 0
        ? (today / yesterday).clamp(0.0, 1.0)
        : (today > 0 ? 1.0 : 0.0);

    Widget dot(Color color) => Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        );

    return Row(
      children: [
        Text(
          'Yesterday $yesterday',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withValues(alpha: 0.45),
          ),
        ),
        const SizedBox(width: 5),
        dot(colorScheme.onSurface.withValues(alpha: 0.3)),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: fill),
              duration: OrbitMotion.hero,
              curve: OrbitMotion.curve,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 5,
                backgroundColor: colorScheme.onSurface.withValues(alpha: 0.07),
                valueColor: const AlwaysStoppedAnimation(OrbitColors.copper500),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        dot(OrbitColors.copper500),
        const SizedBox(width: 5),
        Text(
          'Today $today',
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: OrbitColors.copper500,
          ),
        ),
      ],
    );
  }

  Widget _buildInsightsSection(BuildContext context) {
    final insightsAsync = ref.watch(dailyInsightsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Insight",
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
              return SizedBox(
                width: double.infinity,
                child: OrbitGlassCard(
                  radius: 20,
                  padding: const EdgeInsets.all(16),
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
                            color:
                                colorScheme.onSurface.withValues(alpha: 0.8),
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return _InsightCarousel(insights: insights, controller: _insightController);
          },
          loading: () => const SizedBox(
            height: 60,
            width: double.infinity,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: OrbitColors.copper500,
              ),
            ),
          ),
          error: (_, _) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

/// Swipeable insight carousel — manual only, springy page dots,
/// one-time copper glint on Personal Best moments.
class _InsightCarousel extends StatefulWidget {
  final List<OrbitInsight> insights;
  final PageController controller;

  const _InsightCarousel({required this.insights, required this.controller});

  @override
  State<_InsightCarousel> createState() => _InsightCarouselState();
}

class _InsightCarouselState extends State<_InsightCarousel> {
  @override
  Widget build(BuildContext context) {
    final insights = widget.insights;
    final colorScheme = Theme.of(context).colorScheme;
    final showDots = insights.length > 1;

    return Column(
      children: [
        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: widget.controller,
            itemCount: insights.length,
            itemBuilder: (context, i) {
              final insight = insights[i];
              final card = Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: OrbitInsightCardV2(insight: insight),
              );
              final isPersonalBest =
                  insight.title.toLowerCase().contains('personal best');
              return isPersonalBest ? _GlintSweep(child: card) : card;
            },
          ),
        ),
        if (showDots) ...[
          const SizedBox(height: 10),
          AnimatedBuilder(
            animation: widget.controller,
            builder: (context, _) {
              double page = 0;
              if (widget.controller.hasClients &&
                  widget.controller.position.haveDimensions) {
                page = widget.controller.page ?? 0;
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(insights.length, (i) {
                  final active = page.round() == i;
                  return AnimatedContainer(
                    duration: OrbitMotion.base,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 16 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: active
                          ? OrbitColors.copper500
                          : colorScheme.onSurface.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ],
    );
  }
}

/// One-time copper shine sweep for earned milestones (Personal Best).
class _GlintSweep extends StatefulWidget {
  final Widget child;

  const _GlintSweep({required this.child});

  @override
  State<_GlintSweep> createState() => _GlintSweepState();
}

class _GlintSweepState extends State<_GlintSweep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: OrbitMotion.glint,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return Stack(
          children: [
            child!,
            if (t > 0 && t < 1)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Align(
                    alignment: Alignment(-1.6 + 3.2 * t, 0),
                    child: Transform.rotate(
                      angle: 0.35,
                      child: Container(
                        width: 56,
                        height: 300,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0),
                              Colors.white.withValues(alpha: 0.35),
                              Colors.white.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Pulsing skeleton shown while the dashboard assembles — no spinners.
class _ScoreSkeleton extends StatefulWidget {
  const _ScoreSkeleton();

  @override
  State<_ScoreSkeleton> createState() => _ScoreSkeletonState();
}

class _ScoreSkeletonState extends State<_ScoreSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08);
    return Center(
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, child) {
          final opacity = 0.35 + 0.45 * _pulse.value;
          return Opacity(
            opacity: opacity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration:
                      BoxDecoration(color: base, shape: BoxShape.circle),
                ),
                const SizedBox(height: 18),
                Container(
                  width: 140,
                  height: 14,
                  decoration: BoxDecoration(
                    color: base,
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 220,
                  height: 10,
                  decoration: BoxDecoration(
                    color: base,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 180,
                  height: 10,
                  decoration: BoxDecoration(
                    color: base,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
          );
        },
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
      ..color = (isDark ? Colors.white : const Color(0xFF171514))
          .withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Draw thin dashed curve line
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final len = (distance + 4.0) > metric.length
            ? (metric.length - distance)
            : 4.0;
        final extractPath = metric.extractPath(distance, distance + len);
        canvas.drawPath(extractPath, paint);
        distance += len + 5.0;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CurvedDayArcPainter oldDelegate) => false;
}
