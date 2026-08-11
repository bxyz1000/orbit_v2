import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/orbit_colors.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../core/theme/orbit_shadows.dart';
import '../../settings/presentation/providers/preferences_providers.dart';
import '../domain/services/i_ai_coach_service.dart';
import 'providers/ai_providers.dart';

/// Orbit AI Coach Page — Evidence-based personal performance coaching shell.
class OrbitAiPage extends ConsumerStatefulWidget {
  const OrbitAiPage({super.key});

  @override
  ConsumerState<OrbitAiPage> createState() => _OrbitAiPageState();
}

class _OrbitAiPageState extends ConsumerState<OrbitAiPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final prefsAsync = ref.watch(userPreferencesProvider);
    final isAiEnabled = prefsAsync.asData?.value.aiAssistantEnabled ?? true;
    final chatState = ref.watch(aiChatNotifierProvider);
    final contextAsync = ref.watch(orbitAIContextProvider);

    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? null : OrbitColors.warmWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: OrbitColors.copper500.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.auto_awesome_rounded, color: OrbitColors.copper500, size: 18),
            ),
            const SizedBox(width: 8),
            const Text(
              'Orbit Coach',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services_rounded, size: 18),
            tooltip: 'Clear Chat',
            onPressed: () => ref.read(aiChatNotifierProvider.notifier).clearChat(),
          ),
        ],
        centerTitle: true,
      ),
      body: !isAiEnabled
          ? _buildDisabledState(context)
          : Column(
              children: [
                // ─── Live Context Summary Chip ───
                _buildLiveContextBar(context, contextAsync, isDark),

                // ─── Chat Messages or Empty State ───
                Expanded(
                  child: chatState.messages.isEmpty
                      ? _buildEmptyState(context)
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(OrbitSpacing.pagePadding),
                          itemCount: chatState.messages.length + (chatState.isLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == chatState.messages.length && chatState.isLoading) {
                              return _buildLoadingBubble(context);
                            }
                            final msg = chatState.messages[index];
                            return _MessageBubble(message: msg);
                          },
                        ),
                ),

                // ─── Quick Actions Pill Carousel ───
                _buildQuickActionsRow(context, ref, chatState.isLoading),
                const SizedBox(height: 10),

                // ─── Input Bar ───
                _buildInputBar(context, ref, chatState.isLoading, isDark),
              ],
            ),
    );
  }

  Widget _buildLiveContextBar(
    BuildContext context,
    AsyncValue contextAsync,
    bool isDark,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return contextAsync.when(
      data: (orbitCtx) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: OrbitSpacing.pagePadding, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? OrbitColors.darkElevated : OrbitColors.warmGray100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : OrbitColors.warmGray200.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Orbit Context Active',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              Text(
                'Score: ${orbitCtx.totalScore} • Tasks: ${orbitCtx.tasksCompletedToday}/${orbitCtx.tasksCompletedToday + orbitCtx.tasksPendingToday} • Focus: ${orbitCtx.focusMinutesToday}m',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildQuickActionsRow(BuildContext context, WidgetRef ref, bool isLoading) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final actions = [
      {'label': 'Explain my score', 'type': AICoachRequestType.scoreExplanation, 'icon': Icons.insights_rounded},
      {'label': 'What should I focus on?', 'type': AICoachRequestType.nextAction, 'icon': Icons.center_focus_strong_rounded},
      {'label': 'How did I do today?', 'type': AICoachRequestType.dailyBriefing, 'icon': Icons.today_rounded},
      {'label': 'Review my week', 'type': AICoachRequestType.weeklyReview, 'icon': Icons.date_range_rounded},
    ];

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: OrbitSpacing.pagePadding),
        itemCount: actions.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = actions[index];
          final type = item['type'] as AICoachRequestType;
          final label = item['label'] as String;
          final icon = item['icon'] as IconData;

          return InkWell(
            onTap: isLoading
                ? null
                : () {
                    ref.read(aiChatNotifierProvider.notifier).sendQuickAction(type);
                    _scrollToBottom();
                  },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? OrbitColors.darkElevated : OrbitColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: OrbitColors.copper500.withValues(alpha: 0.3),
                ),
                boxShadow: OrbitShadows.card,
              ),
              child: Row(
                children: [
                  Icon(icon, size: 14, color: OrbitColors.copper500),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputBar(BuildContext context, WidgetRef ref, bool isLoading, bool isDark) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.only(
            left: OrbitSpacing.pagePadding,
            right: OrbitSpacing.pagePadding,
            top: 10,
            bottom: MediaQuery.of(context).padding.bottom + 12,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? OrbitColors.darkSurface.withValues(alpha: 0.9)
                : OrbitColors.white.withValues(alpha: 0.9),
            border: Border(
              top: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : OrbitColors.warmGray200.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  enabled: !isLoading,
                  onSubmitted: (val) {
                    if (val.trim().isNotEmpty) {
                      ref.read(aiChatNotifierProvider.notifier).sendUserPrompt(val);
                      _controller.clear();
                      _scrollToBottom();
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Ask Orbit Coach...',
                    hintStyle: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.35),
                      fontSize: 14,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: isDark ? OrbitColors.darkElevated : OrbitColors.warmGray50,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: IconButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          if (_controller.text.trim().isNotEmpty) {
                            ref.read(aiChatNotifierProvider.notifier).sendUserPrompt(_controller.text);
                            _controller.clear();
                            _scrollToBottom();
                          }
                        },
                  icon: const Icon(Icons.arrow_upward_rounded, size: 20),
                  color: Colors.white,
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDisabledState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.auto_awesome_outlined,
                size: 40,
                color: colorScheme.onSurface.withValues(alpha: 0.25),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'AI Assistant Disabled',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'You can enable the Orbit Coach in\nProfile & Settings preferences.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.45),
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                final prefs = ref.read(userPreferencesProvider).asData?.value;
                if (prefs != null) {
                  ref.read(preferencesNotifierProvider.notifier).updatePreferences(
                        prefs.copyWith(aiAssistantEnabled: true),
                      );
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Enable AI Coach', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: OrbitColors.copper500.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                size: 44,
                color: OrbitColors.copper500,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Orbit Coach',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Personalized, evidence-based coaching powered by your authentic Orbit execution state.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingBubble(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? OrbitColors.darkElevated : OrbitColors.warmGray100,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2, color: OrbitColors.copper500),
            ),
            const SizedBox(width: 10),
            Text(
              'Orbit Coach is analyzing context...',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final AIChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        decoration: BoxDecoration(
          color: message.isUser
              ? colorScheme.primary
              : (isDark ? OrbitColors.darkElevated : OrbitColors.white),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(message.isUser ? 20 : 4),
            bottomRight: Radius.circular(message.isUser ? 4 : 20),
          ),
          boxShadow: message.isUser ? null : OrbitShadows.card,
          border: message.isUser
              ? null
              : Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : OrbitColors.warmGray200.withValues(alpha: 0.3),
                ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isUser) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome_rounded, size: 14, color: OrbitColors.copper500),
                  const SizedBox(width: 6),
                  Text(
                    'ORBIT COACH',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                      color: OrbitColors.copper500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : colorScheme.onSurface,
                fontSize: 14,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
