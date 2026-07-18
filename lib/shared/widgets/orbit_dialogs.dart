import 'package:flutter/material.dart';
import '../../features/tasks/domain/task.dart';
import '../../features/tasks/data/task_repository.dart';
import '../../features/habits/domain/habit.dart';
import '../../features/habits/data/habit_repository.dart';
import '../../features/planner/domain/planner_event.dart';
import '../../features/planner/data/planner_repository.dart';
import '../core/theme/orbit_spacing.dart';

class OrbitDialogs {
  static void showAddTask(BuildContext context, TaskRepository repo, {VoidCallback? onDone}) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Task title'),
          onSubmitted: (_) => _submitTask(context, repo, controller, onDone),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => _submitTask(context, repo, controller, onDone),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  static void _submitTask(BuildContext context, TaskRepository repo, TextEditingController controller, VoidCallback? onDone) async {
    final title = controller.text.trim();
    if (title.isNotEmpty) {
      await repo.saveTask(Task.create(title: title));
      if (context.mounted) Navigator.pop(context);
      onDone?.call();
    }
  }

  static void showAddHabit(BuildContext context, HabitRepository repo, {VoidCallback? onDone}) {
    final titleController = TextEditingController();
    IconData selectedIcon = Icons.star;
    Color selectedColor = Colors.blue;

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
        builder: (context, setState) => AlertDialog(
          title: const Text('New Habit'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  autofocus: true,
                  decoration: const InputDecoration(hintText: 'Habit Title'),
                ),
                const SizedBox(height: OrbitSpacing.lg),
                const Align(alignment: Alignment.centerLeft, child: Text('Choose icon')),
                const SizedBox(height: OrbitSpacing.sm),
                Wrap(
                  spacing: OrbitSpacing.xs,
                  children: icons.map((icon) => IconButton(
                    icon: Icon(icon, color: selectedIcon == icon ? selectedColor : null),
                    onPressed: () => setState(() => selectedIcon = icon),
                  )).toList(),
                ),
                const SizedBox(height: OrbitSpacing.md),
                const Align(alignment: Alignment.centerLeft, child: Text('Choose color')),
                const SizedBox(height: OrbitSpacing.sm),
                Wrap(
                  spacing: OrbitSpacing.sm,
                  runSpacing: OrbitSpacing.sm,
                  children: colors.map((color) => InkWell(
                    onTap: () => setState(() => selectedColor = color),
                    child: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: selectedColor == color ? Border.all(color: Colors.white, width: 2) : null,
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
                  await repo.saveHabit(Habit.create(
                    title: titleController.text, 
                    icon: selectedIcon, 
                    color: selectedColor
                  ));
                  if (context.mounted) Navigator.pop(context);
                  onDone?.call();
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  static void showAddEvent(BuildContext context, PlannerRepository repo, {VoidCallback? onDone}) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    String startTime = "09:00 AM";
    String endTime = "10:00 AM";
    Color selectedColor = Colors.blue;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('New Event'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: OrbitSpacing.md),
                ListTile(
                  title: const Text('Time'),
                  subtitle: Text('$startTime - $endTime'),
                  leading: const Icon(Icons.access_time),
                  onTap: () async {
                    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                    if (picked != null) {
                      setState(() => startTime = picked.format(context));
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  await repo.saveEvent(PlannerEvent.create(
                    date: selectedDate,
                    startTime: startTime,
                    endTime: endTime,
                    title: titleController.text,
                    description: descController.text,
                    color: selectedColor,
                  ));
                  if (context.mounted) Navigator.pop(context);
                  onDone?.call();
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
