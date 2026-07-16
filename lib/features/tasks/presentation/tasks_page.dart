import 'package:flutter/material.dart';
import '../domain/task.dart';
import '../domain/task_service.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../core/theme/orbit_radius.dart';
import '../../../shared/widgets/orbit_section_header.dart';
import '../../../shared/widgets/orbit_group_card.dart';
import '../../../shared/widgets/orbit_info_tile.dart';
import '../../../shared/widgets/orbit_search_bar.dart';

enum TaskFilter { all, active, completed }

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final List<Task> _tasks = TaskService().tasks;
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  
  String _searchQuery = "";
  TaskFilter _currentFilter = TaskFilter.all;

  void _addTask() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task'),
        content: TextField(
          controller: _taskController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Task title',
          ),
          onSubmitted: (_) => _submitTask(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _taskController.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _submitTask,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _submitTask() {
    final title = _taskController.text.trim();
    if (title.isNotEmpty) {
      setState(() {
        _tasks.add(
          Task(
            id: DateTime.now().toString(),
            title: title,
          ),
        );
      });
      _taskController.clear();
      Navigator.pop(context);
    }
  }

  void _toggleTask(Task task) {
    setState(() {
      final index = _tasks.indexOf(task);
      if (index != -1) {
        _tasks[index] = task.copyWith(completed: !task.completed);
      }
    });
  }

  void _deleteTask(Task task) {
    setState(() {
      _tasks.remove(task);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task deleted'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _tasks.add(task);
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final completedCount = TaskService().completedCount;
    final totalCount = _tasks.length;
    final progress = TaskService().completionPercentage;

    List<Task> filteredTasks = _tasks.where((task) {
      final matchesSearch = task.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _currentFilter == TaskFilter.all ||
          (_currentFilter == TaskFilter.active && !task.completed) ||
          (_currentFilter == TaskFilter.completed && task.completed);
      return matchesSearch && matchesFilter;
    }).toList();

    filteredTasks.sort((a, b) {
      if (a.completed == b.completed) return 0;
      return a.completed ? 1 : -1;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: Column(
        children: [
          _buildProgressHeader(colorScheme, theme, completedCount, totalCount, progress),
          _buildSearchAndFilter(colorScheme),
          Expanded(
            child: _tasks.isEmpty
                ? _buildEmptyState(colorScheme, theme)
                : filteredTasks.isEmpty
                    ? _buildNoResults(theme, colorScheme)
                    : ListView.builder(
                        padding: const EdgeInsets.all(OrbitSpacing.lg),
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];
                          return _buildTaskItem(task, colorScheme, theme);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProgressHeader(ColorScheme colorScheme, ThemeData theme, int completed, int total, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: OrbitSpacing.xl, vertical: OrbitSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$total Tasks',
                style: theme.textTheme.titleMedium,
              ),
              Text(
                '$completed Completed',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: OrbitSpacing.sm),
          ClipRRect(
            borderRadius: OrbitRadius.brCircular,
            child: LinearProgressIndicator(
              value: progress.isNaN ? 0 : progress,
              minHeight: 8,
              backgroundColor: colorScheme.primary.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: OrbitSpacing.xl),
      child: Column(
        children: [
          OrbitSearchBar(
            controller: _searchController,
            hintText: 'Search tasks...',
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
          const SizedBox(height: OrbitSpacing.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: TaskFilter.values.map((filter) {
                final isSelected = _currentFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: OrbitSpacing.sm),
                  child: ChoiceChip(
                    label: Text(filter.name[0].toUpperCase() + filter.name.substring(1)),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _currentFilter = filter);
                    },
                    showCheckmark: false,
                    shape: const StadiumBorder(),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(Task task, ColorScheme colorScheme, ThemeData theme) {
    return Padding(
      key: ValueKey(task.id),
      padding: const EdgeInsets.only(bottom: OrbitSpacing.md),
      child: Dismissible(
        key: Key(task.id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => _deleteTask(task),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: OrbitSpacing.xl),
          decoration: BoxDecoration(
            color: colorScheme.error.withOpacity(0.1),
            borderRadius: OrbitRadius.brMd,
          ),
          child: Icon(Icons.delete_outline, color: colorScheme.error),
        ),
        child: OrbitGroupCard(
          children: [
            OrbitInfoTile(
              title: task.title,
              titleStyle: theme.textTheme.bodyLarge?.copyWith(
                decoration: task.completed ? TextDecoration.lineThrough : null,
                color: task.completed ? colorScheme.onSurface.withOpacity(0.5) : null,
              ),
              leading: Checkbox(
                value: task.completed,
                onChanged: (_) => _toggleTask(task),
                shape: RoundedRectangleBorder(borderRadius: OrbitRadius.brXs),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                color: colorScheme.onSurface.withOpacity(0.3),
                onPressed: () => _deleteTask(task),
                tooltip: 'Delete Task',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme, ThemeData theme) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_alt, size: 64, color: colorScheme.primary.withOpacity(0.1)),
            const SizedBox(height: OrbitSpacing.lg),
            const OrbitSectionHeader(
              title: "No tasks yet",
              subtitle: "Tap + to create your first task.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_outlined, size: 48, color: colorScheme.onSurface.withOpacity(0.2)),
          const SizedBox(height: OrbitSpacing.lg),
          Text(
            'No matching results',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: OrbitSpacing.xs),
          Text(
            'Try another keyword.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
