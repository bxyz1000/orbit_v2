import 'package:flutter/material.dart';
import '../domain/task.dart';
import '../data/task_repository.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../core/theme/orbit_radius.dart';
import '../../../shared/widgets/orbit_section_header.dart';
import '../../../shared/widgets/orbit_group_card.dart';
import '../../../shared/widgets/orbit_info_tile.dart';
import '../../../shared/widgets/orbit_search_bar.dart';

enum TaskFilter { all, active, completed }

class TasksPage extends StatefulWidget {
  final TaskRepository taskRepository;

  const TasksPage({
    super.key,
    required this.taskRepository,
  });

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  List<Task> _tasks = [];
  bool _isLoading = true;

  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  
  String _searchQuery = "";
  TaskFilter _currentFilter = TaskFilter.all;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await widget.taskRepository.getAllTasks();
      if (mounted) {
        setState(() {
          _tasks = tasks;
          _isLoading = false;
        });
      }
    } catch (e) {
      _showError('Failed to load tasks');
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

  void _showTaskDialog([Task? task]) {
    final isEditing = task != null;
    _taskController.text = task?.title ?? '';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Task' : 'Add Task'),
        content: TextField(
          controller: _taskController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Task title',
          ),
          onSubmitted: (_) => _submitTask(task),
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
            onPressed: () => _submitTask(task),
            child: Text(isEditing ? 'Save' : 'Add'),
          ),
        ],
      ),
    );
  }

  void _submitTask([Task? existingTask]) async {
    final title = _taskController.text.trim();
    if (title.isNotEmpty) {
      final task = existingTask != null 
          ? existingTask.copyWith(title: title)
          : Task.create(title: title);
      try {
        await widget.taskRepository.saveTask(task);
        _taskController.clear();
        if (mounted) Navigator.pop(context);
        _loadTasks();
      } catch (e) {
        _showError('Failed to save task');
      }
    }
  }

  void _toggleTask(Task task) async {
    final isCompleting = !task.completed;
    final updatedTask = task.copyWith(
      completed: isCompleting,
      completedAt: isCompleting ? DateTime.now() : null,
    );
    try {
      await widget.taskRepository.saveTask(updatedTask);
      _loadTasks();
    } catch (e) {
      _showError('Failed to update task');
    }
  }

  void _deleteTask(Task task) async {
    try {
      await widget.taskRepository.deleteTask(task.id);
      _loadTasks();

      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Task deleted'),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () async {
                await widget.taskRepository.saveTask(task);
                _loadTasks();
              },
            ),
          ),
        );
      }
    } catch (e) {
      _showError('Failed to delete task');
    }
  }

  @override
  void dispose() {
    _taskController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final completedCount = _tasks.where((t) => t.completed).length;
    final totalCount = _tasks.length;
    final progress = totalCount == 0 ? 0.0 : completedCount / totalCount;

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
                        padding: const EdgeInsets.all(OrbitSpacing.xl),
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
        onPressed: () => _showTaskDialog(),
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
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
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
              backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
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
        key: Key('task_${task.id}_${task.completed}'),
        direction: DismissDirection.horizontal,
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            _toggleTask(task);
            return false;
          }
          return true;
        },
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            _deleteTask(task);
          }
        },
        background: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: OrbitSpacing.xl),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: OrbitRadius.brMd,
          ),
          child: Icon(
            task.completed ? Icons.undo : Icons.check_circle_outline,
            color: Colors.green,
          ),
        ),
        secondaryBackground: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: OrbitSpacing.xl),
          decoration: BoxDecoration(
            color: colorScheme.error.withValues(alpha: 0.1),
            borderRadius: OrbitRadius.brMd,
          ),
          child: Icon(Icons.delete_outline, color: colorScheme.error),
        ),
        child: InkWell(
          onLongPress: () => _showTaskDialog(task),
          borderRadius: OrbitRadius.brMd,
          child: OrbitGroupCard(
            children: [
              OrbitInfoTile(
                title: task.title,
                titleStyle: theme.textTheme.bodyLarge?.copyWith(
                  decoration: task.completed ? TextDecoration.lineThrough : null,
                  color: task.completed ? colorScheme.onSurface.withValues(alpha: 0.5) : null,
                ),
                leading: Checkbox(
                  value: task.completed,
                  onChanged: (_) => _toggleTask(task),
                  shape: RoundedRectangleBorder(borderRadius: OrbitRadius.brXs),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                  onPressed: () => _deleteTask(task),
                  tooltip: 'Delete Task',
                ),
              ),
            ],
          ),
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
            Icon(Icons.task_alt, size: 64, color: colorScheme.primary.withValues(alpha: 0.1)),
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
          Icon(Icons.search_off_outlined, size: 48, color: colorScheme.onSurface.withValues(alpha: 0.2)),
          const SizedBox(height: OrbitSpacing.lg),
          Text(
            'No matching results',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: OrbitSpacing.xs),
          Text(
            'Try another keyword.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
