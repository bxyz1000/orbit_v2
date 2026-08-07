import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/analytics_period.dart';
import '../providers/analytics_providers.dart';
import '../../../../core/theme/orbit_spacing.dart';

class AnalyticsPeriodSelector extends ConsumerWidget {
  const AnalyticsPeriodSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = ref.watch(analyticsPeriodProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: AnalyticsPeriod.values.map((period) {
          final isSelected = selectedPeriod == period;
          return Padding(
            padding: const EdgeInsets.only(right: OrbitSpacing.sm),
            child: ChoiceChip(
              label: Text(_getPeriodLabel(period)),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  ref.read(analyticsPeriodProvider.notifier).setPeriod(period);
                }
              },
              showCheckmark: false,
              shape: StadiumBorder(
                side: BorderSide(
                  color: isSelected
                      ? Colors.transparent
                      : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getPeriodLabel(AnalyticsPeriod period) {
    switch (period) {
      case AnalyticsPeriod.today:
        return 'Today';
      case AnalyticsPeriod.last7Days:
        return '7 Days';
      case AnalyticsPeriod.last30Days:
        return '30 Days';
      case AnalyticsPeriod.last90Days:
        return '90 Days';
    }
  }
}
