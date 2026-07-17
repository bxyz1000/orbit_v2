import 'package:flutter/material.dart';
import '../domain/habit.dart';
import '../data/habit_repository.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../core/theme/orbit_radius.dart';
import '../../../shared/widgets/orbit_section_header.dart';
import '../../../shared/widgets/orbit_group_card.dart';
import '../../../shared/widgets/orbit_info_tile.dart';

import '../domain/habit_completion.dart';

class HabitsPage extends StatefulWidget {
  final HabitRepository habitRepository;

  const HabitsPage({
    super.key,
    required this.habitRepository,
  });

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  List<Habit> _habits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    try {
      final habits = await widget.habitRepository.getAllHabits();
      if (mounted) {
        setState(() {
          _habits = habits;
          _isLoading = false;
        });
      }
    } catch (e) {
      _showError('Failed to load habits');
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

  void _toggleHabit(Habit habit) async {
    final completed = !habit.completedToday;
    int currentStreak = habit.currentStreak;
    int bestStreak = habit.bestStreak;

    if (completed) {
      currentStreak++;
      if (currentStreak > bestStreak) bestStreak = currentStreak;
      // Record completion for the engine
      await widget.habitRepository.saveCompletion(
        HabitCompletion.create(habitId: habit.id, date: DateTime.now()),
      );
    } else {
      currentStreak = (currentStreak > 0) ? currentStreak - 1 : 0;
      // Note: In a full implementation, we would delete the completion record here
    }

    final updatedHabit = habit.copyWith(
      completedToday: completed,
      currentStreak: currentStreak,
      bestStreak: bestStreak,
    );

    try {
      await widget.habitRepository.saveHabit(updatedHabit);
      _loadHabits();
    } catch (e) {
      _showError('Failed to update habit');
    }
  }

  void _deleteHabit(Habit habit) async {
    try {
      await widget.habitRepository.deleteHabit(habit.id);
      _loadHabits();

      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Habit deleted'),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () async {
                await widget.habitRepository.saveHabit(habit);
                _loadHabits();
              },
            ),
          ),
        );
      }
    } catch (e) {
      _showError('Failed to delete habit');
    }
  }

  void _showHabitDialog([Habit? habit]) {
    final isEditing = habit != null;
    final titleController = TextEditingController(text: habit?.title);
    IconData selectedIcon = habit?.icon ?? Icons.star;
    Color selectedColor = habit?.color ?? Colors.blue;

    final icons = [
      Icons.star, Icons.favorite, Icons.fitness_center, Icons.book, 
      Icons.water_drop, Icons.wb_sunny, Icons.nightlight, Icons.self_improvement,
      Icons.brush, Icons.code, Icons.music_note, Icons.restaurant
    ];
    final colors = [
      Colors.blue, Colors.red, Colors.green, Colors.orange, 
      Colors.purple, Colors.teal, Colors.pink, Colors.amber
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Edit Habit' : 'New Habit'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  autofocus: !isEditing,
                  decoration: const InputDecoration(hintText: 'Habit Title'),
                ),
                const SizedBox(height: OrbitSpacing.lg),
                const Align(alignment: Alignment.centerLeft, child: Text('Choose icon')),
                const SizedBox(height: OrbitSpacing.sm),
                Wrap(
                  spacing: OrbitSpacing.xs,
                  children: icons.map((icon) => IconButton(
                    icon: Icon(icon, color: selectedIcon == icon ? selectedColor : null),
                    onPressed: () => setDialogState(() => selectedIcon = icon),
                  )).toList(),
                ),
                const SizedBox(height: OrbitSpacing.md),
                const Align(alignment: Alignment.centerLeft, child: Text('Choose color')),
                const SizedBox(height: OrbitSpacing.sm),
                Wrap(
                  spacing: OrbitSpacing.sm,
                  runSpacing: OrbitSpacing.sm,
                  children: colors.map((color) => InkWell(
                    onTap: () => setDialogState(() => selectedColor = color),
                    child: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: selectedColor == color ? Border.all(color: Colors.white, width: 2) : null,
                        boxShadow: selectedColor == color ? [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 4)] : null,
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  final newHabit = isEditing
                    ? habit.copyWith(title: titleController.text, icon: selectedIcon, color: selectedColor)
                    : Habit.create(title: titleController.text, icon: selectedIcon, color: selectedColor);
                  await widget.habitRepository.saveHabit(newHabit);
                  if (!mounted) return;
                  Navigator.pop(context);
                  _loadHabits();
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Habits')),
      body: _habits.isEmpty
          ? _buildEmptyState(colorScheme, theme)
          : ListView.builder(
              padding: const EdgeInsets.all(OrbitSpacing.xl),
              itemCount: _habits.length,
              itemBuilder: (context, index) {
                final habit = _habits[index];
                return _buildHabitItem(habit, colorScheme, theme);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showHabitDialog(),
        tooltip: 'Create new habit',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHabitItem(Habit habit, ColorScheme colorScheme, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: OrbitSpacing.md),
      child: Dismissible(
        key: Key('habit_${habit.id}'),
        onDismissed: (_) => _deleteHabit(habit),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: OrbitSpacing.xl),
          decoration: BoxDecoration(
            color: colorScheme.error.withValues(alpha: 0.1),
            borderRadius: OrbitRadius.brMd,
          ),
          child: Icon(Icons.delete_outline, color: colorScheme.error),
        ),
        child: InkWell(
          onTap: () => _toggleHabit(habit),
          onLongPress: () => _showHabitDialog(habit),
          borderRadius: OrbitRadius.brMd,
          child: OrbitGroupCard(
            children: [
              OrbitInfoTile(
                title: habit.title,
                leading: Container(
                  padding: const EdgeInsets.all(OrbitSpacing.sm),
                  decoration: BoxDecoration(
                    color: habit.color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(habit.icon, color: habit.color, size: 20),
                ),
                subtitleWidget: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    children: [
                      _buildStreakInfo(Icons.local_fire_department, '${habit.currentStreak} day streak', Colors.orange),
                      const SizedBox(width: OrbitSpacing.md),
                      _buildStreakInfo(Icons.emoji_events_outlined, 'Best: ${habit.bestStreak}', Colors.amber),
                    ],
                  ),
                ),
                trailing: Icon(
                  habit.completedToday ? Icons.check_circle : Icons.circle_outlined,
                  color: habit.completedToday ? Colors.green : colorScheme.onSurface.withValues(alpha: 0.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStreakInfo(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(OrbitSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.repeat, size: 64, color: colorScheme.primary.withValues(alpha: 0.1)),
            const SizedBox(height: OrbitSpacing.lg),
            Text(
              "No habits yet",
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: OrbitSpacing.xs),
            Text(
              "Create your first habit to build consistency.",
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
