import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/orbit_colors.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../core/theme/orbit_shadows.dart';
import '../../settings/presentation/providers/preferences_providers.dart';

/// Orbit AI Assistant UI Shell — premium copper-tinted chat interface.
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
      backgroundColor: isDark ? null : OrbitColors.warmWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: OrbitColors.copper500.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_awesome_rounded, color: OrbitColors.copper500, size: 16),
            ),
            const SizedBox(width: 8),
            const Text(
              'Orbit AI',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
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
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: OrbitSpacing.pagePadding),
                      itemCount: _suggestions.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _sendMessage(_suggestions[index]),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isDark ? OrbitColors.darkElevated : OrbitColors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.06)
                                    : OrbitColors.warmGray200.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              _suggestions[index],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 12),

                // ─── Input Bar ───
                ClipRRect(
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
                              onSubmitted: _sendMessage,
                              decoration: InputDecoration(
                                hintText: 'Ask Orbit AI...',
                                hintStyle: TextStyle(
                                  color: colorScheme.onSurface.withValues(alpha: 0.3),
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
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: IconButton(
                              onPressed: () => _sendMessage(_controller.text),
                              icon: const Icon(Icons.arrow_upward_rounded, size: 18),
                              color: Colors.white,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                    ),
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
              'You can enable the AI Assistant in\nProfile & Settings preferences.',
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
              child: const Text('Enable AI Assistant', style: TextStyle(fontWeight: FontWeight.w600)),
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
        padding: const EdgeInsets.all(40),
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
              'How can I help you today?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ask me about your score, activity patterns,\nor for guidance on your day.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.45),
                    height: 1.5,
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
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(message.isUser ? 18 : 4),
            bottomRight: Radius.circular(message.isUser ? 4 : 18),
          ),
          border: message.isUser
              ? null
              : Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : OrbitColors.warmGray200.withValues(alpha: 0.3),
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
