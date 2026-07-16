import 'package:flutter/material.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../core/theme/orbit_radius.dart';
import '../../../shared/widgets/orbit_section_header.dart';
import '../../../shared/widgets/orbit_info_tile.dart';
import '../../../core/storage/storage_service.dart';
import '../domain/planner_event.dart';

class PlannerPage extends StatefulWidget {
  final StorageService storageService;

  const PlannerPage({
    super.key,
    required this.storageService,
  });

  @override
  State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  List<PlannerEvent> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final events = await widget.storageService.loadPlanner();
      if (events.isEmpty) {
        // Seed initial data if empty for MVP feel
        final initialEvents = [
          PlannerEvent.create(time: '09:00 AM', title: 'Gym', color: Colors.blue),
          PlannerEvent.create(time: '11:00 AM', title: 'Flutter Development', color: Colors.orange),
          PlannerEvent.create(time: '03:00 PM', title: 'Study', color: Colors.purple),
          PlannerEvent.create(time: '08:00 PM', title: 'Family Time', color: Colors.green),
        ];
        await widget.storageService.savePlanner(initialEvents);
        _events = await widget.storageService.loadPlanner();
      } else {
        _events = events;
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load planner')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
    // Standard static date for MVP
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
    return Column(
      children: _events.map((event) => _buildEventCard(event, textTheme, colorScheme)).toList(),
    );
  }

  Widget _buildEventCard(PlannerEvent event, TextTheme textTheme, ColorScheme colorScheme) {
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
