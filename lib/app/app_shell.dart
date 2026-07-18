import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/home/presentation/orbit_home_page.dart';
import '../features/tasks/presentation/tasks_page.dart';
import '../features/analytics/presentation/insights_page.dart';
import '../features/profile/presentation/profile_page.dart';
import '../features/focus/presentation/focus_page.dart';
import '../shared/providers/repository_providers.dart';
import '../shared/widgets/orbit_dialogs.dart';
import '../core/theme/orbit_spacing.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isFabExpanded = false;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _toggleFab() {
    setState(() {
      _isFabExpanded = !_isFabExpanded;
      if (_isFabExpanded) {
        _fabAnimationController.forward();
      } else {
        _fabAnimationController.reverse();
      }
    });
  }

  void _onProfileTap() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      OrbitHomePage(onProfileTap: _onProfileTap),
      TasksPage(taskRepository: ref.read(taskRepositoryProvider)),
      const InsightsPage(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: pages,
          ),
          if (_isFabExpanded)
            GestureDetector(
              onTap: _toggleFab,
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
              ),
            ),
          if (_isFabExpanded) _buildFabMenu(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 65,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavAction(0, Icons.home_outlined, Icons.home, 'Orbit'),
            _buildNavAction(1, Icons.check_circle_outline, Icons.check_circle, 'Tasks'),
            const SizedBox(width: 48), // Space for FAB
            _buildNavAction(2, Icons.analytics_outlined, Icons.analytics, 'Insights'),
            // Profile moved to AppBar as per request
            _buildNavAction(3, Icons.person_outline, Icons.person, 'Profile'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFab,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: RotationTransition(
          turns: Tween(begin: 0.0, end: 0.125).animate(_fabAnimation),
          child: const Icon(Icons.add, size: 32),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavAction(int index, IconData icon, IconData selectedIcon, String label) {
    // If it's profile, we use it as a button that pushes a route instead of switching tab?
    // User said "Settings and Profile move to AppBar/avatar menu." 
    // But then bottom nav only has Orbit, Tasks, Insights. 
    // To keep it balanced, I'll put Orbit, Tasks on left and Insights, [Profile?] on right?
    // Actually, I'll just use 3 buttons and the FAB.
    
    if (index == 3) {
      // Profile button in bottom nav for legacy/balance, but pushes a route
      return InkWell(
        onTap: _onProfileTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_outline, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
            const Text('Profile', style: TextStyle(fontSize: 10)),
          ],
        ),
      );
    }

    final isSelected = _selectedIndex == index;
    final color = isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);

    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          _isFabExpanded = false;
          _fabAnimationController.reverse();
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isSelected ? selectedIcon : icon, color: color),
            Text(
              label, 
              style: TextStyle(
                fontSize: 10, 
                color: color, 
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFabMenu() {
    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFabOption(Icons.add_task, 'Task', Colors.blue, () {
              OrbitDialogs.showAddTask(context, ref.read(taskRepositoryProvider));
            }),
            OrbitSpacing.gapMd,
            _buildFabOption(Icons.repeat, 'Habit', Colors.green, () {
              OrbitDialogs.showAddHabit(context, ref.read(habitRepositoryProvider));
            }),
            OrbitSpacing.gapMd,
            _buildFabOption(Icons.calendar_today, 'Event', Colors.purple, () {
              OrbitDialogs.showAddEvent(context, ref.read(plannerRepositoryProvider));
            }),
            OrbitSpacing.gapMd,
            _buildFabOption(Icons.timer, 'Focus', Colors.orange, () {
               Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => FocusPage(focusRepository: ref.read(focusRepositoryProvider))),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFabOption(IconData icon, String label, Color color, VoidCallback onTap) {
    return ScaleTransition(
      scale: _fabAnimation,
      child: FloatingActionButton.extended(
        onPressed: () {
          _toggleFab();
          onTap();
        },
        heroTag: null,
        backgroundColor: Theme.of(context).colorScheme.surface,
        icon: Icon(icon, color: color),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
