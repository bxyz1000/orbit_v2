import 'dart:async';
import 'package:flutter/material.dart';
import '../domain/focus_session.dart';
import '../data/focus_repository.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../core/theme/orbit_radius.dart';
import '../../../shared/widgets/orbit_section_header.dart';
import '../../../shared/widgets/orbit_group_card.dart';
import '../../../shared/widgets/orbit_stat_card.dart';
import '../../../shared/widgets/orbit_info_tile.dart';

class FocusPage extends StatefulWidget {
  final FocusRepository focusRepository;

  const FocusPage({
    super.key,
    required this.focusRepository,
  });

  @override
  State<FocusPage> createState() => _FocusPageState();
}

class _FocusPageState extends State<FocusPage> {
  Timer? _timer;
  int _secondsRemaining = 25 * 60;
  int _selectedPresetMinutes = 25;
  bool _isActive = false;
  bool _isPaused = false;

  List<FocusSession> _allSessions = [];
  List<FocusSession> _todaySessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final all = await widget.focusRepository.getAllSessions();
    final today = await widget.focusRepository.getTodaySessions();
    if (mounted) {
      setState(() {
        _allSessions = all;
        _todaySessions = today;
        _isLoading = false;
      });
    }
  }

  void _startTimer() {
    setState(() {
      _isActive = true;
      _isPaused = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _onTimerComplete();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isPaused = true;
    });
  }

  void _resumeTimer() {
    _startTimer();
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isActive = false;
      _isPaused = false;
      _secondsRemaining = _selectedPresetMinutes * 60;
    });
  }

  void _onTimerComplete() async {
    _timer?.cancel();
    setState(() {
      _isActive = false;
      _isPaused = false;
      _secondsRemaining = _selectedPresetMinutes * 60;
    });

    final session = FocusSession.create(
      duration: _selectedPresetMinutes,
      completed: true,
      endedAt: DateTime.now(),
    );

    await widget.focusRepository.saveSession(session);
    _loadSessions();

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Session Complete 🎉'),
          content: Text('Great job! You focused for $_selectedPresetMinutes minutes.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Dismiss'),
            ),
          ],
        ),
      );
    }
  }

  void _setPreset(int minutes) {
    if (_isActive) return;
    setState(() {
      _selectedPresetMinutes = minutes;
      _secondsRemaining = minutes * 60;
    });
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String _formatDuration(int totalMinutes) {
    if (totalMinutes < 60) return '${totalMinutes}m';
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    return '${h}h ${m}m';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final todayMinutes = _todaySessions.fold<int>(0, (sum, s) => sum + s.duration);

    return Scaffold(
      appBar: AppBar(title: const Text('Focus')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(OrbitSpacing.xl),
        child: Column(
          children: [
            _buildTimerDisplay(colorScheme, theme),
            const SizedBox(height: OrbitSpacing.xxl),
            _buildControls(colorScheme),
            const SizedBox(height: OrbitSpacing.xxl),
            const OrbitSectionHeader(title: 'Presets'),
            const SizedBox(height: OrbitSpacing.md),
            _buildPresets(),
            const SizedBox(height: OrbitSpacing.xxl),
            const OrbitSectionHeader(title: 'Today'),
            const SizedBox(height: OrbitSpacing.md),
            _buildTodayStats(todayMinutes),
            const SizedBox(height: OrbitSpacing.xxl),
            const OrbitSectionHeader(title: 'History'),
            const SizedBox(height: OrbitSpacing.md),
            _buildHistory(colorScheme, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerDisplay(ColorScheme colorScheme, ThemeData theme) {
    final progress = 1 - (_secondsRemaining / (_selectedPresetMinutes * 60));

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 240,
          height: 240,
          child: CircularProgressIndicator(
            value: _isActive ? progress : 0,
            strokeWidth: 12,
            backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
            strokeCap: StrokeCap.round,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatTime(_secondsRemaining),
              style: theme.textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              _isActive ? (_isPaused ? 'Paused' : 'Focusing') : 'Ready',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControls(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!_isActive)
          ElevatedButton.icon(
            onPressed: _startTimer,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          )
        else ...[
          if (!_isPaused)
            OutlinedButton.icon(
              onPressed: _pauseTimer,
              icon: const Icon(Icons.pause),
              label: const Text('Pause'),
            )
          else
            ElevatedButton.icon(
              onPressed: _resumeTimer,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Resume'),
            ),
          const SizedBox(width: OrbitSpacing.md),
          TextButton.icon(
            onPressed: _resetTimer,
            icon: const Icon(Icons.refresh),
            label: const Text('Reset'),
          ),
        ],
      ],
    );
  }

  Widget _buildPresets() {
    final presets = [15, 25, 45, 60];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: presets.map((m) {
        final isSelected = _selectedPresetMinutes == m;
        return FilterChip(
          label: Text('${m}m'),
          selected: isSelected,
          onSelected: _isActive ? null : (_) => _setPreset(m),
        );
      }).toList(),
    );
  }

  Widget _buildTodayStats(int totalMinutes) {
    return Row(
      children: [
        Expanded(
          child: OrbitStatCard(
            title: 'Sessions',
            value: '${_todaySessions.length}',
          ),
        ),
        const SizedBox(width: OrbitSpacing.md),
        Expanded(
          child: OrbitStatCard(
            title: 'Time',
            value: _formatDuration(totalMinutes),
          ),
        ),
      ],
    );
  }

  Widget _buildHistory(ColorScheme colorScheme, ThemeData theme) {
    if (_allSessions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(OrbitSpacing.xl),
          child: Column(
            children: [
              Icon(Icons.history, size: 48, color: colorScheme.onSurface.withValues(alpha: 0.1)),
              const SizedBox(height: OrbitSpacing.md),
              const Text('No focus sessions yet.'),
              const Text('Start your first session.'),
            ],
          ),
        ),
      );
    }

    return OrbitGroupCard(
      children: _allSessions.take(5).map((session) {
        return OrbitInfoTile(
          title: '${session.duration} Minute Focus',
          subtitle: _formatDate(session.startedAt),
          icon: Icons.check_circle,
          trailing: session.completed 
            ? const Icon(Icons.check, color: Colors.green, size: 16)
            : null,
        );
      }).toList(),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    }
    return '${date.day}/${date.month} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
