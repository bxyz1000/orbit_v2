import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/orbit_colors.dart';
import '../../../core/theme/orbit_motion.dart';
import '../../../shared/providers/repository_providers.dart';
import '../domain/goal.dart';

/// Pings whenever any goal changes in Isar, so the lists below re-run.
final goalsChangesProvider = StreamProvider<void>(
  (ref) => ref.watch(goalRepositoryProvider).watchGoals(),
);

final todayGoalsProvider = FutureProvider<List<Goal>>((ref) async {
  ref.watch(goalsChangesProvider);
  return ref.watch(goalRepositoryProvider).getGoalsForDate(DateTime.now());
});

final longTermGoalsProvider = FutureProvider<List<Goal>>((ref) async {
  ref.watch(goalsChangesProvider);
  return ref.watch(goalRepositoryProvider).getLongTermGoals();
});

/// GOALS — real CRUD over the existing GoalRepository (Isar).
/// Daily goals for today + long-term goals, hub-styled, theme-adaptive.
class GoalsPage extends ConsumerWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final todayAsync = ref.watch(todayGoalsProvider);
    final longTermAsync = ref.watch(longTermGoalsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Goals')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: OrbitColors.copper500,
        child: const Icon(Icons.add_rounded, color: Colors.white),
        onPressed: () => _showAddGoalSheet(context, ref, isDark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('Today', colorScheme),
            const SizedBox(height: 10),
            todayAsync.when(
              data: (goals) => goals.isEmpty
                  ? _emptyCard(
                      context,
                      isDark,
                      'No goals for today yet.',
                      'Tap + to set one and start winning.',
                    )
                  : Column(
                      children: goals
                          .map((g) => _goalTile(context, ref, g, isDark,
                              longTerm: false))
                          .toList(),
                    ),
              loading: () => _loadingCard(isDark),
              error: (e, _) => _errorCard(context, isDark, e),
            ),
            const SizedBox(height: 26),
            _sectionLabel('Long-term', colorScheme),
            const SizedBox(height: 10),
            longTermAsync.when(
              data: (goals) => goals.isEmpty
                  ? _emptyCard(
                      context,
                      isDark,
                      'No long-term goals yet.',
                      'Big wins start as a single line. Tap + and name yours.',
                    )
                  : Column(
                      children: goals
                          .map((g) => _goalTile(context, ref, g, isDark,
                              longTerm: true))
                          .toList(),
                    ),
              loading: () => _loadingCard(isDark),
              error: (e, _) => _errorCard(context, isDark, e),
            ),
          ],
        ),
      ),
    );
  }
  Widget _sectionLabel(String text, ColorScheme colorScheme) => Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
          color: colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      );

  Widget _goalTile(
    BuildContext context,
    WidgetRef ref,
    Goal goal,
    bool isDark, {
    required bool longTerm,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () async {
          OrbitMotion.light();
          await ref
              .read(goalRepositoryProvider)
              .saveGoal(goal..completed = !goal.completed);
        },
        onLongPress: () async {
          OrbitMotion.medium();
          await ref.read(goalRepositoryProvider).removeGoal(goal.id);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : const Color(0xFFEDE4DC),
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: const Color(0xFF322720).withValues(alpha: 0.06),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: OrbitMotion.base,
                curve: OrbitMotion.curve,
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: goal.completed ? OrbitColors.copper500 : Colors.transparent,
                  border: Border.all(
                    color: goal.completed
                        ? OrbitColors.copper500
                        : colorScheme.onSurface.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: goal.completed
                    ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  goal.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight:
                        goal.completed ? FontWeight.w500 : FontWeight.w600,
                    color: goal.completed
                        ? colorScheme.onSurface.withValues(alpha: 0.45)
                        : colorScheme.onSurface,
                    decoration: goal.completed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                longTerm ? Icons.emoji_events_rounded : Icons.today_rounded,
                size: 15,
                color: goal.completed
                    ? colorScheme.onSurface.withValues(alpha: 0.25)
                    : OrbitColors.copper500.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyCard(
      BuildContext context, bool isDark, String title, String sub) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: OrbitColors.copper500.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const Icon(Icons.flag_rounded, size: 26, color: OrbitColors.copper500),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            sub,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadingCard(bool isDark) => Container(
        width: double.infinity,
        height: 64,
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: OrbitColors.copper500,
            ),
          ),
        ),
      );

  Widget _errorCard(BuildContext context, bool isDark, Object e) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          'Could not load goals: $e',
          style: TextStyle(
            fontSize: 12,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      );

  Future<void> _showAddGoalSheet(
    BuildContext context,
    WidgetRef ref,
    bool isDark,
  ) async {
    final controller = TextEditingController();
    int segment = 0; // 0 = today, 1 = long-term

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
              ),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF201C19) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New goal',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: controller,
                      autofocus: true,
                      maxLines: 1,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'What do you want to achieve?',
                        filled: true,
                        fillColor: isDark
                            ? Colors.white.withValues(alpha: 0.06)
                            : const Color(0xFFF6F0EA),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _segmentButton(
                            context,
                            isDark,
                            'Today',
                            Icons.today_rounded,
                            segment == 0,
                            () => setSheetState(() => segment = 0),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _segmentButton(
                            context,
                            isDark,
                            'Long-term',
                            Icons.emoji_events_rounded,
                            segment == 1,
                            () => setSheetState(() => segment = 1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: OrbitColors.copper500,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () async {
                          final title = controller.text.trim();
                          if (title.isEmpty) return;
                          await ref.read(goalRepositoryProvider).saveGoal(
                                Goal.create(
                                  title: title,
                                  date: DateTime.now(),
                                  isLongTerm: segment == 1,
                                ),
                              );
                          OrbitMotion.medium();
                          if (sheetContext.mounted) Navigator.pop(sheetContext);
                        },
                        child: const Text(
                          'Add goal',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _segmentButton(
    BuildContext context,
    bool isDark,
    String label,
    IconData icon,
    bool active,
    VoidCallback onTap,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        OrbitMotion.selection();
        onTap();
      },
      child: AnimatedContainer(
        duration: OrbitMotion.base,
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: active
              ? OrbitColors.copper500.withValues(alpha: 0.14)
              : (isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : const Color(0xFFF6F0EA)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? OrbitColors.copper500 : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 15,
              color: active
                  ? OrbitColors.copper500
                  : colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                color: active
                    ? OrbitColors.copper500
                    : colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
