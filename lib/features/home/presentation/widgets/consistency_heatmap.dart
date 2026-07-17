import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../score/score.dart';
import '../../../../core/theme/orbit_radius.dart';

class ConsistencyHeatmap extends ConsumerWidget {
  const ConsistencyHeatmap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoresAsync = ref.watch(lastThirtyDaysScoresProvider);

    return scoresAsync.when(
      data: (scores) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemCount: scores.length,
          itemBuilder: (context, index) {
            final score = scores[index];
            final color = _getHeatmapColor(score.totalScore, Theme.of(context).colorScheme.primary);
            
            return Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: OrbitRadius.brXs,
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox(),
    );
  }

  Color _getHeatmapColor(int score, Color primary) {
    if (score == 0) return primary.withValues(alpha: 0.05);
    if (score < 30) return primary.withValues(alpha: 0.2);
    if (score < 60) return primary.withValues(alpha: 0.4);
    if (score < 90) return primary.withValues(alpha: 0.7);
    return primary;
  }
}
