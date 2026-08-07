import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/orbit_spacing.dart';
import '../../../../shared/widgets/orbit_group_card.dart';
import '../../../../shared/widgets/orbit_info_tile.dart';
import '../../../../shared/widgets/orbit_section_header.dart';
import '../providers/insight_providers.dart';
import 'insight_card.dart';

/// Renders category growth insights consuming [categoryInsightsProvider].
class CategoryInsightsSection extends ConsumerWidget {
  const CategoryInsightsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catInsightsAsync = ref.watch(categoryInsightsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrbitSectionHeader(
          title: "Category Insights",
          subtitle: "Performance distribution and top growth opportunities",
        ),
        OrbitSpacing.gapLg,
        catInsightsAsync.when(
          data: (insights) {
            if (insights.isEmpty) {
              return const OrbitGroupCard(
                children: [
                  OrbitInfoTile(
                    icon: Icons.category_outlined,
                    title: "No category data available yet",
                    subtitle: "Log activity in Tasks, Focus, or Habits to see category performance.",
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
                    'Unable to load category insights',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  OrbitSpacing.gapMd,
                  TextButton.icon(
                    onPressed: () => ref.invalidate(categoryInsightsProvider),
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
