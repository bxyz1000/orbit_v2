import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/orbit_colors.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../core/theme/orbit_shadows.dart';
import '../../settings/presentation/providers/preferences_providers.dart';

/// Orbit AI Assistant UI Shell.
class OrbitAiPage extends ConsumerStatefulWidget {
  const OrbitAiPage({super.key});

  @override
  ConsumerState<OrbitAiPage> createState() => _OrbitAiPageState();
}

class _OrbitAiPageState extends ConsumerState<OrbitAiPage> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  final List<String> _suggestions = [
    "What's my score today?",
    "How did I do today?",
    "Give me motivation",
    "What is my strongest category?",
    "How can I improve tomorrow?",
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text.trim(),
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _controller.clear();
    });

    // Handle initial preview state
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(
          text: "Orbit AI is ready to connect with your preferred AI provider in the upcoming phase.",
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final prefsAsync = ref.watch(userPreferencesProvider);
    final isAiEnabled = prefsAsync.asData?.value.aiAssistantEnabled ?? true;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome_rounded, color: OrbitColors.copper500, size: 20),
            OrbitSpacing.hGapSm,
            const Text('Orbit AI'),
          ],
        ),
        centerTitle: true,
      ),
      body: !isAiEnabled
          ? _buildDisabledState(context)
          : Column(
              children: [
                // ─── Messages or Empty State ───
                Expanded(
                  child: _messages.isEmpty
                      ? _buildEmptyState(context)
                      : ListView.builder(
                          padding: const EdgeInsets.all(OrbitSpacing.pagePadding),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final msg = _messages[index];
                            return _MessageBubble(message: msg);
                          },
                        ),
                ),

                // ─── Suggestions ───
                if (_messages.isEmpty)
                  SizedBox(
                    height: 44,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: OrbitSpacing.pagePadding),
                      itemCount: _suggestions.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        return ActionChip(
                          label: Text(_suggestions[index]),
                          onPressed: () => _sendMessage(_suggestions[index]),
                          backgroundColor: isDark ? OrbitColors.darkElevated : OrbitColors.warmGray50,
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        );
                      },
                    ),
                  ),
                OrbitSpacing.vGapMd,

                // ─── Input Bar ───
                Container(
                  padding: EdgeInsets.only(
                    left: OrbitSpacing.pagePadding,
                    right: OrbitSpacing.pagePadding,
                    top: 8,
                    bottom: MediaQuery.of(context).padding.bottom + 80,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? OrbitColors.darkSurface : OrbitColors.white,
                    boxShadow: OrbitShadows.navBar,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onSubmitted: _sendMessage,
                          decoration: InputDecoration(
                            hintText: 'Ask Orbit AI...',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: isDark ? OrbitColors.darkElevated : OrbitColors.warmGray50,
                          ),
                        ),
                      ),
                      OrbitSpacing.hGapSm,
                      IconButton.filled(
                        onPressed: () => _sendMessage(_controller.text),
                        icon: const Icon(Icons.arrow_upward_rounded),
                        style: IconButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildDisabledState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(OrbitSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome_outlined,
              size: 48,
              color: colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            OrbitSpacing.vGapLg,
            Text(
              'AI Assistant Disabled',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            OrbitSpacing.vGapSm,
            Text(
              'You can enable the AI Assistant in Profile & Settings preferences.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    height: 1.4,
                  ),
            ),
            OrbitSpacing.vGapLg,
            ElevatedButton(
              onPressed: () {
                final prefs = ref.read(userPreferencesProvider).asData?.value;
                if (prefs != null) {
                  ref.read(preferencesNotifierProvider.notifier).updatePreferences(
                        prefs.copyWith(aiAssistantEnabled: true),
                      );
                }
              },
              child: const Text('Enable AI Assistant'),
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
        padding: const EdgeInsets.all(OrbitSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: OrbitColors.copper500.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                size: 48,
                color: OrbitColors.copper500,
              ),
            ),
            OrbitSpacing.vGapLg,
            Text(
              'How can I help you today?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            OrbitSpacing.vGapSm,
            Text(
              'Ask me about your score, activity patterns,\nor for guidance on your day.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    height: 1.4,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isUser
              ? colorScheme.primary
              : (isDark ? OrbitColors.darkElevated : OrbitColors.warmGray100),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isUser ? 16 : 4),
            bottomRight: Radius.circular(message.isUser ? 4 : 16),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser
                ? Colors.white
                : colorScheme.onSurface,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
