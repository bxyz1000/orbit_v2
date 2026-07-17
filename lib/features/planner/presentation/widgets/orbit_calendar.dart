import 'package:flutter/material.dart';
import '../../../../core/theme/orbit_spacing.dart';
import '../../../../core/theme/orbit_radius.dart';
import '../../domain/planner_event.dart';

class OrbitCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime focusedDate;
  final List<PlannerEvent> events;
  final Function(DateTime) onDateSelected;
  final Function(DateTime) onMonthChanged;

  const OrbitCalendar({
    super.key,
    required this.selectedDate,
    required this.focusedDate,
    required this.events,
    required this.onDateSelected,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final firstDayOfMonth = DateTime(focusedDate.year, focusedDate.month, 1);
    final lastDayOfMonth = DateTime(focusedDate.year, focusedDate.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday; // 1 = Monday, 7 = Sunday

    // Padding for the first week (assuming Monday start)
    final paddingDays = firstWeekday - 1;

    return Column(
      children: [
        _buildHeader(context),
        const SizedBox(height: OrbitSpacing.lg),
        _buildWeekDays(context),
        const SizedBox(height: OrbitSpacing.sm),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: OrbitSpacing.xs,
            crossAxisSpacing: OrbitSpacing.xs,
          ),
          itemCount: daysInMonth + paddingDays,
          itemBuilder: (context, index) {
            if (index < paddingDays) {
              return const SizedBox.shrink();
            }

            final day = index - paddingDays + 1;
            final date = DateTime(focusedDate.year, focusedDate.month, day);
            final isSelected = _isSameDay(date, selectedDate);
            final isToday = _isToday(date);
            final hasEvents = events.any((e) => _isSameDay(e.date, date));

            return InkWell(
              onTap: () => onDateSelected(date),
              borderRadius: OrbitRadius.brCircular,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? colorScheme.primary 
                          : (isToday ? colorScheme.primaryContainer : null),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      day.toString(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isSelected 
                            ? colorScheme.onPrimary 
                            : (isToday ? colorScheme.onPrimaryContainer : null),
                        fontWeight: isSelected || isToday ? FontWeight.bold : null,
                      ),
                    ),
                  ),
                  if (hasEvents && !isSelected)
                    Positioned(
                      bottom: 4,
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isToday ? colorScheme.primary : colorScheme.primary.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  bool _isToday(DateTime date) {
    return _isSameDay(date, DateTime.now());
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildHeader(BuildContext context) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final theme = Theme.of(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${months[focusedDate.month - 1]} ${focusedDate.year}',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, size: 20),
              onPressed: () => onMonthChanged(DateTime(focusedDate.year, focusedDate.month - 1)),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, size: 20),
              onPressed: () => onMonthChanged(DateTime(focusedDate.year, focusedDate.month + 1)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeekDays(BuildContext context) {
    final weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekDays.map((day) => Expanded(
        child: Center(
          child: Text(
            day,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      )).toList(),
    );
  }
}
