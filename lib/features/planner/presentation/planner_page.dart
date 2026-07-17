import 'package:flutter/material.dart';
import '../domain/planner_event.dart';
import '../data/planner_repository.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../core/theme/orbit_radius.dart';
import '../../../shared/widgets/orbit_section_header.dart';
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

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  Color _selectedColor = Colors.blue;

  final List<Color> _eventColors = [
    Colors.blue,
    Colors.purple,
    Colors.orange,
    Colors.green,
    Colors.red,
    Colors.pink,
    Colors.indigo,
    Colors.teal,
  ];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final events = await widget.plannerRepository.getAllEvents();
      if (mounted) {
        if (events.isEmpty) {
          final now = DateTime.now();
          final initialEvents = [
            PlannerEvent.create(
              date: now,
              startTime: '09:00 AM',
              endTime: '10:00 AM',
              title: 'Gym Session',
              description: 'Morning workout at the local gym.',
              color: Colors.blue,
            ),
            PlannerEvent.create(
              date: now,
              startTime: '11:00 AM',
              endTime: '01:00 PM',
              title: 'Flutter Development',
              description: 'Work on Orbit v2 features.',
              color: Colors.orange,
            ),
            PlannerEvent.create(
              date: now,
              startTime: '03:00 PM',
              endTime: '04:30 PM',
              title: 'Study Session',
              description: 'Review system design patterns.',
              color: Colors.purple,
            ),
          ];
          await widget.plannerRepository.saveEvents(initialEvents);
          final seededEvents = await widget.plannerRepository.getAllEvents();
          setState(() {
            _allEvents = seededEvents;
            _isLoading = false;
          });
        } else {
          setState(() {
            _allEvents = events;
            _isLoading = false;
          });
        }
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
    _titleController.clear();
    _descriptionController.clear();
    _startTimeController.text = '09:00 AM';
    _endTimeController.text = '10:00 AM';
    _selectedColor = _eventColors.first;
    
    _showEventDialog(title: 'New Event', onSave: _submitAddEvent);
  }

  void _editEvent(PlannerEvent event) {
    _titleController.text = event.title;
    _descriptionController.text = event.description ?? '';
    _startTimeController.text = event.startTime;
    _endTimeController.text = event.endTime;
    _selectedColor = event.color;

    _showEventDialog(
      title: 'Edit Event',
      onSave: () => _submitEditEvent(event),
      onDelete: () {
        Navigator.pop(context);
        _deleteEvent(event);
      },
    );
  }

  void _showEventDialog({
    required String title,
    required VoidCallback onSave,
    VoidCallback? onDelete,
  }) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 2,
                ),
                const SizedBox(height: OrbitSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _startTimeController,
                        decoration: const InputDecoration(labelText: 'Start Time'),
                        readOnly: true,
                        onTap: () => _selectTime(context, _startTimeController),
                      ),
                    ),
                    const SizedBox(width: OrbitSpacing.md),
                    Expanded(
                      child: TextField(
                        controller: _endTimeController,
                        decoration: const InputDecoration(labelText: 'End Time'),
                        readOnly: true,
                        onTap: () => _selectTime(context, _endTimeController),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: OrbitSpacing.lg),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Color', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: OrbitSpacing.sm),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _eventColors.length,
                    separatorBuilder: (_, __) => const SizedBox(width: OrbitSpacing.sm),
                    itemBuilder: (context, index) {
                      final color = _eventColors[index];
                      final isSelected = _selectedColor == color;
                      return GestureDetector(
                        onTap: () => setDialogState(() => _selectedColor = color),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                            boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 8)] : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            if (onDelete != null)
              TextButton(
                onPressed: onDelete,
                child: const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: onSave,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && mounted) {
      setState(() {
        controller.text = picked.format(context);
      });
    }
  }

  void _submitAddEvent() async {
    final title = _titleController.text.trim();
    if (title.isNotEmpty) {
      final newEvent = PlannerEvent.create(
        date: _selectedDate,
        startTime: _startTimeController.text,
        endTime: _endTimeController.text,
        title: title,
        description: _descriptionController.text.trim(),
        color: _selectedColor,
      );
      try {
        await widget.plannerRepository.saveEvent(newEvent);
        if (mounted) Navigator.pop(context);
        _loadEvents();
      } catch (e) {
        _showError('Failed to add event');
      }
    }
  }

  void _submitEditEvent(PlannerEvent event) async {
    final title = _titleController.text.trim();
    if (title.isNotEmpty) {
      final updatedEvent = event.copyWith(
        title: title,
        description: _descriptionController.text.trim(),
        startTime: _startTimeController.text,
        endTime: _endTimeController.text,
        color: _selectedColor,
      );
      try {
        await widget.plannerRepository.saveEvent(updatedEvent);
        if (mounted) Navigator.pop(context);
        _loadEvents();
      } catch (e) {
        _showError('Failed to update event');
      }
    }
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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
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
                    Icon(Icons.event_note, size: 64, color: colorScheme.onSurface.withOpacity(0.1)),
                    const SizedBox(height: OrbitSpacing.md),
                    Text(
                      'No events scheduled',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.4),
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

  void _toggleEventCompletion(PlannerEvent event) async {
    final updatedEvent = event.copyWith(isCompleted: !event.isCompleted);
    try {
      await widget.plannerRepository.saveEvent(updatedEvent);
      _loadEvents();
    } catch (e) {
      _showError('Failed to update event');
    }
  }

  Widget _buildEventCard(PlannerEvent event, TextTheme textTheme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: OrbitSpacing.md),
      child: InkWell(
        onTap: () => _editEvent(event),
        onLongPress: () => _editEvent(event),
        borderRadius: OrbitRadius.brMd,
        child: Container(
          padding: const EdgeInsets.all(OrbitSpacing.lg),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: OrbitRadius.brMd,
            border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
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
                        color: colorScheme.onSurface.withOpacity(0.6),
                        fontWeight: FontWeight.bold,
                        decoration: event.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      event.title,
                      style: textTheme.titleMedium?.copyWith(
                        decoration: event.isCompleted ? TextDecoration.lineThrough : null,
                        color: event.isCompleted ? colorScheme.onSurface.withOpacity(0.5) : null,
                      ),
                    ),
                    if (event.description != null && event.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        event.description!,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.5),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right, size: 20, color: colorScheme.onSurface.withOpacity(0.2)),
            ],
          ),
        ),
      ),
    );
  }
}
