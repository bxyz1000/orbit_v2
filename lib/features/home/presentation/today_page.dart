import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../core/theme/orbit_radius.dart';
import '../../../shared/widgets/orbit_section_header.dart';
import '../../../shared/widgets/orbit_stat_card.dart';
import '../../../shared/widgets/orbit_action_card.dart';
import '../../../shared/widgets/orbit_group_card.dart';
import '../../../shared/widgets/orbit_info_tile.dart';
import '../../../core/storage/storage_service.dart';
import '../../tasks/domain/task.dart';

class TodayPage extends StatefulWidget {
  final StorageService storageService;

  const TodayPage({
    super.key,
    required this.storageService,
  });

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  List<Task> _tasks = [];
  late final String _quote;
  bool _isLoading = true;

  final List<String> _quotes = const [
    "The secret of getting ahead is getting started.",
    "It always seems impossible until it's done.",
    "Don't watch the clock; do what it does. Keep going.",
    "Quality is not an act, it is a habit.",
    "The way to get started is to quit talking and begin doing.",
    "Your talent determines what you can do. Your motivation determines how much you are willing to do.",
    "Well begun is half done.",
    "Action is the foundational key to all success.",
    "Focus on being productive instead of busy.",
    "The best way to predict your future is to create it.",
  ];

  @override
  void initState() {
    super.initState();
    _quote = _quotes[Random().nextInt(_quotes.length)];
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await widget.storageService.loadTasks();
    if (mounted) {
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good Morning ☀️';
    if (hour >= 12 && hour < 17) return 'Good Afternoon 🌤️';
    if (hour >= 17 && hour < 22) return 'Good Evening 🌙';
    return 'Good Night 🌌';
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final completedCount = _tasks.where((t) => t.completed).length;
    final remainingCount = _tasks.length - completedCount;
    final completionPct = _tasks.isEmpty ? 0 : (completedCount * 100 ~/ _tasks.length);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(OrbitSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(textTheme, colorScheme),
              const SizedBox(height: OrbitSpacing.xxl),
              const OrbitSectionHeader(title: "Today's Focus"),
              const SizedBox(height: OrbitSpacing.lg),
              _buildFocusCard(textTheme, colorScheme, remainingCount),
              const SizedBox(height: OrbitSpacing.xxl),
              const OrbitSectionHeader(title: "Quick Actions"),
              const SizedBox(height: OrbitSpacing.lg),
              _buildQuickActionsGrid(),
              const SizedBox(height: OrbitSpacing.xxl),
              const OrbitSectionHeader(title: "Today's Progress"),
              const SizedBox(height: OrbitSpacing.lg),
              _buildProgressStats(theme, completedCount, remainingCount, completionPct),
              const SizedBox(height: OrbitSpacing.xxl),
              const OrbitSectionHeader(title: "Motivation"),
              const SizedBox(height: OrbitSpacing.lg),
              _buildMotivationCard(textTheme, colorScheme),
              const SizedBox(height: OrbitSpacing.xxl),
              const OrbitSectionHeader(title: "Recent Activity"),
              const SizedBox(height: OrbitSpacing.lg),
              _buildRecentActivity(colorScheme),
              const SizedBox(height: OrbitSpacing.huge),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(TextTheme textTheme, ColorScheme colorScheme) {
    final now = DateTime.now();
    final months = const [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final weekdays = const [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    final dateString = '${weekdays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getGreeting(),
          style: textTheme.headlineLarge,
        ),
        const SizedBox(height: OrbitSpacing.xs),
        Text(
          'Welcome back to Orbit',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: OrbitSpacing.md),
        Text(
          dateString,
          style: textTheme.titleSmall?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFocusCard(TextTheme textTheme, ColorScheme colorScheme, int remaining) {
    final isCaughtUp = remaining == 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(OrbitSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: OrbitRadius.brLg,
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  isCaughtUp ? "You're all caught up!" : "Complete $remaining remaining tasks",
                  style: textTheme.titleLarge,
                ),
              ),
              if (!isCaughtUp)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: OrbitSpacing.sm,
                    vertical: OrbitSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: OrbitRadius.brCircular,
                  ),
                  child: Text(
                    'In Progress',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: OrbitSpacing.sm),
          Text(
            isCaughtUp 
                ? 'Great job! Take some time to relax or plan your next move.'
                : 'Stay focused and keep moving toward your goals.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: OrbitSpacing.md,
          crossAxisSpacing: OrbitSpacing.md,
          childAspectRatio: 1.5,
          children: [
            OrbitActionCard(
              icon: Icons.add_task, 
              title: 'Add Task',
              onTap: () => _showFeedback('Tasks opened'),
            ),
            OrbitActionCard(
              icon: Icons.calendar_month, 
              title: 'Planner',
              onTap: () => _showFeedback('Planner coming soon'),
            ),
            OrbitActionCard(
              icon: Icons.note_alt, 
              title: 'Notes',
              onTap: () => _showFeedback('Notes opened'),
            ),
            OrbitActionCard(
              icon: Icons.person, 
              title: 'Profile',
              onTap: () => _showFeedback('Profile opened'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProgressStats(ThemeData theme, int completed, int remaining, int pct) {
    return Row(
      children: [
        Expanded(
          child: OrbitStatCard(
            title: 'Completed',
            value: '$completed',
          ),
        ),
        const SizedBox(width: OrbitSpacing.md),
        Expanded(
          child: OrbitStatCard(
            title: 'Remaining',
            value: '$remaining',
          ),
        ),
        const SizedBox(width: OrbitSpacing.md),
        Expanded(
          child: OrbitStatCard(
            title: 'Done',
            value: '$pct%',
          ),
        ),
      ],
    );
  }

  Widget _buildMotivationCard(TextTheme textTheme, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(OrbitSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withOpacity(0.05),
            colorScheme.primary.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: OrbitRadius.brMd,
        border: Border.all(color: colorScheme.primary.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(Icons.format_quote, color: colorScheme.primary.withOpacity(0.3), size: 32),
          const SizedBox(height: OrbitSpacing.sm),
          Text(
            _quote,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
              color: colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(ColorScheme colorScheme) {
    return OrbitGroupCard(
      children: [
        const OrbitInfoTile(
          icon: Icons.check_circle_outline,
          title: 'Task completed',
          subtitle: 'Workout',
        ),
        Divider(height: 1, color: colorScheme.outline.withOpacity(0.1)),
        const OrbitInfoTile(
          icon: Icons.note_add_outlined,
          title: 'Note added',
          subtitle: 'Project Ideas',
        ),
        Divider(height: 1, color: colorScheme.outline.withOpacity(0.1)),
        const OrbitInfoTile(
          icon: Icons.calendar_today_outlined,
          title: 'Planner updated',
          subtitle: 'Gym session scheduled',
        ),
      ],
    );
  }
}
