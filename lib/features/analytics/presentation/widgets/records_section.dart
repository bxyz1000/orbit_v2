import 'package:flutter/material.dart';
import '../../../../core/theme/orbit_spacing.dart';
import '../../../../shared/widgets/orbit_group_card.dart';
import '../../../../shared/widgets/orbit_section_header.dart';
import '../../../../shared/widgets/orbit_info_tile.dart';

class RecordsSection extends StatelessWidget {
  final Map<String, num> records;

  const RecordsSection({
    super.key,
    required this.records,
  });

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OrbitSectionHeader(title: "Personal Records"),
        OrbitSpacing.gapLg,
        OrbitGroupCard(
          children: records.entries.map((entry) {
            final isLast = entry.key == records.keys.last;
            return Column(
              children: [
                OrbitInfoTile(
                  icon: Icons.emoji_events_outlined,
                  title: _formatRecordType(entry.key),
                  trailing: Text(
                    _formatValue(entry.value),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                if (!isLast) const Divider(height: 1, indent: 56),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  String _formatRecordType(String type) {
    return type.replaceAll('_', ' ').toUpperCase();
  }

  String _formatValue(num value) {
    if (value is double) return value.toStringAsFixed(1);
    return value.toString();
  }
}
