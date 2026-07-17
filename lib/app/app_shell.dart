import 'package:flutter/material.dart';
import '../features/home/presentation/today_page.dart';
import '../features/tasks/presentation/tasks_page.dart';
import '../features/planner/presentation/planner_page.dart';
import '../features/habits/presentation/habits_page.dart';
import '../features/focus/presentation/focus_page.dart';
import '../features/analytics/presentation/analytics_page.dart';
import '../features/profile/presentation/profile_page.dart';
import '../features/tasks/data/task_repository.dart';
import '../features/notes/data/note_repository.dart';
import '../features/planner/data/planner_repository.dart';
import '../features/habits/data/habit_repository.dart';
import '../features/focus/data/focus_repository.dart';
import '../features/score/score.dart';

class AppShell extends StatefulWidget {
  final TaskRepository taskRepository;
  final NoteRepository noteRepository;
  final PlannerRepository plannerRepository;
  final HabitRepository habitRepository;
  final FocusRepository focusRepository;
  final ScoreService scoreService;

  const AppShell({
    super.key,
    required this.taskRepository,
    required this.noteRepository,
    required this.plannerRepository,
    required this.habitRepository,
    required this.focusRepository,
    required this.scoreService,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const TodayPage(),
      TasksPage(taskRepository: widget.taskRepository),
      HabitsPage(habitRepository: widget.habitRepository),
      FocusPage(focusRepository: widget.focusRepository),
      AnalyticsPage(
        taskRepository: widget.taskRepository,
        habitRepository: widget.habitRepository,
        focusRepository: widget.focusRepository,
      ),
      PlannerPage(plannerRepository: widget.plannerRepository),
      const ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Today',
            tooltip: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline),
            selectedIcon: Icon(Icons.check_circle),
            label: 'Tasks',
            tooltip: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.repeat_outlined),
            selectedIcon: Icon(Icons.repeat),
            label: 'Habits',
            tooltip: 'Habits',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: 'Focus',
            tooltip: 'Focus',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Analytics',
            tooltip: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Planner',
            tooltip: 'Planner',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
            tooltip: 'Profile',
          ),
        ],
      ),
    );
  }
}
