import 'package:flutter/material.dart';
import '../domain/planner_event.dart';
import '../data/planner_repository.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../core/theme/orbit_radius.dart';
import '../../../shared/widgets/orbit_section_header.dart';
import '../../../shared/widgets/orbit_info_tile.dart';
import '../../../shared/widgets/orbit_dialogs.dart';
import 'widgets/orbit_calendar.dart';

class PlannerPage extends StatefulWidget {
  final PlannerRepository plannerRepository;

  const PlannerPage({
    super.key,
    required this.plannerRepository,
  });

  @override
  State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  List<PlannerEvent> _allEvents = [];
  bool _isLoading = true;

  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final events = await widget.plannerRepository.getAllEvents();
      if (mounted) {
        setState(() {
          _allEvents = events;
          _isLoading = false;
        });
      }
    } catch (e) {
      _showError('Failed to load planner');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<PlannerEvent> get _filteredEvents {
    return _allEvents.where((e) => _isSameDay(e.date, _selectedDate)).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  void _addEvent() {
    OrbitDialogs.showAddEvent(context, widget.plannerRepository, onDone: _loadEvents);
  }

  void _deleteEvent(PlannerEvent event) async {
    try {
      await widget.plannerRepository.deleteEvent(event.id);
      _loadEvents();
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Event deleted'),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () async {
                await widget.plannerRepository.saveEvent(event);
                _loadEvents();
              },
            ),
          ),
        );
      }
    } catch (e) {
      _showError('Failed to delete event');
    }
  }

  void _toggleEventCompletion(PlannerEvent event) async {
    final updatedEvent = event.copyWith(isCompleted: !event.isCompleted);
    try {
      await widget.plannerRepository.saveEvent(updatedEvent);
      _loadEvents();
    } catch (e) {
      _showError('Failed to update event');
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
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(OrbitSpacing.xl),
            sliver: SliverToBoxAdapter(
              child: OrbitCalendar(
                selectedDate: _selectedDate,
                focusedDate: _focusedDate,
                events: _allEvents,
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
                onMonthChanged: (date) {
                  setState(() {
                    _focusedDate = date;
                  });
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: OrbitSpacing.xl),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: OrbitSpacing.lg),
                  OrbitSectionHeader(
                    title: _isToday(_selectedDate) ? "Today's Schedule" : _formatSelectedDate(_selectedDate),
                  ),
                  const SizedBox(height: OrbitSpacing.md),
                ],
              ),
            ),
          ),
          if (_filteredEvents.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_note, size: 64, color: colorScheme.onSurface.withValues(alpha: 0.1)),
                    const SizedBox(height: OrbitSpacing.md),
                    Text(
                      'No planner events today.',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: OrbitSpacing.xl),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildEventCard(_filteredEvents[index], textTheme, colorScheme),
                  childCount: _filteredEvents.length,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: OrbitSpacing.huge)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        tooltip: 'Add Event',
        child: const Icon(Icons.add),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  String _formatSelectedDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Widget _buildEventCard(PlannerEvent event, TextTheme textTheme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: OrbitSpacing.md),
      child: InkWell(
        onTap: () {
          // Edit logic removed from here as per "do not redesign" but improved UX
          _toggleEventCompletion(event);
        },
        onLongPress: () {
          _deleteEvent(event);
        },
        borderRadius: OrbitRadius.brMd,
        child: Container(
          padding: const EdgeInsets.all(OrbitSpacing.lg),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: OrbitRadius.brMd,
            border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Checkbox(
                value: event.isCompleted,
                onChanged: (_) => _toggleEventCompletion(event),
              ),
              Container(
                width: 4,
                height: 50,
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
                      '${event.startTime} - ${event.endTime}',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: FontWeight.bold,
                        decoration: event.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      event.title,
                      style: textTheme.titleMedium?.copyWith(
                        decoration: event.isCompleted ? TextDecoration.lineThrough : null,
                        color: event.isCompleted ? colorScheme.onSurface.withValues(alpha: 0.5) : null,
                      ),
                    ),
                    if (event.description != null && event.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        event.description!,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
