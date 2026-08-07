import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/orbit_spacing.dart';
import '../../../../shared/widgets/orbit_group_card.dart';
import '../../../../shared/widgets/orbit_info_tile.dart';
import '../../../../shared/widgets/orbit_section_header.dart';
import '../providers/insight_providers.dart';
import 'insight_card.dart';

/// Renders "Today's Insights" on the Dashboard consuming [dailyInsightsProvider].
class TodaysInsightsSection extends ConsumerWidget {
  const TodaysInsightsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(dailyInsightsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrbitSectionHeader(
          title: "Today's Insights",
          subtitle: "Personal progress analysis derived from your real data",
        ),
        OrbitSpacing.gapLg,
        insightsAsync.when(
          data: (insights) {
            if (insights.isEmpty) {
              return const OrbitGroupCard(
                children: [
                  OrbitInfoTile(
                    icon: Icons.check_circle_outline,
                    title: "You're all caught up!",
                    subtitle: "Log your tasks, habits, and focus sessions to unlock personalized insights.",
                  ),
                ],
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: insights.length,
              separatorBuilder: (context, index) => OrbitSpacing.gapMd,
              itemBuilder: (context, index) {
                final insight = insights[index];
                return InsightCard(
                  key: ValueKey(insight.id),
                  insight: insight,
                );
              },
            );
          },
          loading: () => const OrbitGroupCard(
            padding: EdgeInsets.all(OrbitSpacing.xl),
            children: [
              Center(child: CircularProgressIndicator()),
            ],
          ),
          error: (error, stackTrace) => OrbitGroupCard(
            padding: const EdgeInsets.all(OrbitSpacing.lg),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 36, color: Colors.red),
                  OrbitSpacing.gapSm,
                  Text(
                    'Unable to load insights',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  OrbitSpacing.gapXs,
                  Text(
                    error.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                    textAlign: TextAlign.center,
                  ),
                  OrbitSpacing.gapMd,
                  TextButton.icon(
                    onPressed: () => ref.invalidate(dailyInsightsProvider),
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
