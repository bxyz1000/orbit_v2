import 'package:flutter/material.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../core/theme/orbit_radius.dart';
import '../../../shared/widgets/orbit_section_header.dart';
import '../../../shared/widgets/orbit_info_tile.dart';

class PlannerPage extends StatelessWidget {
  const PlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planner'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(OrbitSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateHeader(textTheme, colorScheme),
            const SizedBox(height: OrbitSpacing.xxl),
            const OrbitSectionHeader(title: "Today's Schedule"),
            const SizedBox(height: OrbitSpacing.lg),
            _buildScheduleList(textTheme, colorScheme),
            const SizedBox(height: OrbitSpacing.xxl),
            const OrbitSectionHeader(title: "Upcoming"),
            const SizedBox(height: OrbitSpacing.lg),
            _buildUpcomingReminders(colorScheme),
            const SizedBox(height: OrbitSpacing.huge),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHeader(TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Wednesday',
          style: textTheme.headlineMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '16 July 2026',
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleList(TextTheme textTheme, ColorScheme colorScheme) {
    final events = [
      _EventData('09:00 AM', 'Gym', colorScheme.primary),
      _EventData('11:00 AM', 'Flutter Development', Colors.orange),
      _EventData('03:00 PM', 'Study', Colors.purple),
      _EventData('08:00 PM', 'Family Time', Colors.green),
    ];

    return Column(
      children: events.map((event) => _buildEventCard(event, textTheme, colorScheme)).toList(),
    );
  }

  Widget _buildEventCard(_EventData event, TextTheme textTheme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: OrbitSpacing.md),
      child: Container(
        padding: const EdgeInsets.all(OrbitSpacing.lg),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: OrbitRadius.brMd,
          border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: event.color,
                borderRadius: OrbitRadius.brCircular,
              ),
            ),
            const SizedBox(width: OrbitSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.time,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  Text(
                    event.title,
                    style: textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingReminders(ColorScheme colorScheme) {
    final reminders = ['Buy groceries', 'Complete Orbit', 'Call friend'];

    return Column(
      children: reminders
          .map((reminder) => Padding(
                padding: const EdgeInsets.only(bottom: OrbitSpacing.sm),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    borderRadius: OrbitRadius.brSm,
                  ),
                  child: OrbitInfoTile(
                    icon: Icons.circle_outlined,
                    title: reminder,
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class _EventData {
  final String time;
  final String title;
  final Color color;

  _EventData(this.time, this.title, this.color);
}
