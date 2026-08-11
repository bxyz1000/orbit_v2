import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbit_v2/features/ai/domain/entities/orbit_ai_context.dart';
import 'package:orbit_v2/features/ai/domain/services/i_ai_coach_service.dart';
import 'package:orbit_v2/features/ai/domain/services/orbit_context_builder.dart';
import 'package:orbit_v2/features/ai/data/services/gemini_ai_coach_service.dart';
import 'package:orbit_v2/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:orbit_v2/features/health/presentation/providers/health_providers.dart';
import 'package:orbit_v2/shared/providers/repository_providers.dart';
import 'package:orbit_v2/shared/providers/data_providers.dart';
import 'package:orbit_v2/features/integrations/strava/presentation/providers/strava_providers.dart';
import 'package:orbit_v2/features/integrations/strava/domain/entities/strava_auth_state.dart';
import 'package:orbit_v2/features/score/presentation/providers/score_providers.dart';

final geminiApiKeyProvider = Provider<String?>((ref) {
  const envKey = String.fromEnvironment('GEMINI_API_KEY');
  return envKey.isNotEmpty ? envKey : null;
});

final aiCoachServiceProvider = Provider<IAICoachService>((ref) {
  final apiKey = ref.watch(geminiApiKeyProvider);
  return GeminiAICoachService(apiKey: apiKey);
});

final orbitAIContextProvider = FutureProvider<OrbitAIContext>((ref) async {
  final dashboardState = await ref.watch(dashboardProvider.future);
  final prefs = ref.watch(userPreferencesProvider).asData?.value;
  final isHealthAuthorized = ref.watch(healthAuthorizationProvider).asData?.value ?? false;
  final healthSnapshot = ref.watch(todayHealthSnapshotProvider).asData?.value;

  final stravaState = ref.watch(stravaAuthStateStreamProvider).asData?.value;
  final isStravaConnected = stravaState?.status == StravaConnectionStatus.connected ||
      stravaState?.status == StravaConnectionStatus.syncing;

  final score7DayEma = ref.watch(rolling7DayAverageProvider).asData?.value;

  final pendingTasks = ref.watch(pendingTasksProvider).asData?.value ?? [];
  final habits = ref.watch(allHabitsProvider).asData?.value ?? [];
  final todayEvents = ref.watch(todayEventsProvider).asData?.value ?? [];

  return OrbitContextBuilder.buildFromState(
    dashboardState: dashboardState,
    preferences: prefs ?? ref.read(userPreferencesProvider).asData?.value ?? (throw Exception('Preferences missing')),
    isHealthAuthorized: isHealthAuthorized,
    isStravaConnected: isStravaConnected,
    score7DayEma: score7DayEma,
    healthSnapshot: healthSnapshot,
    pendingTasks: pendingTasks,
    habits: habits,
    todayEvents: todayEvents,
  );
});

class AIChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final AICoachRequestType? requestType;

  const AIChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.requestType,
  });
}

class AIChatState {
  final List<AIChatMessage> messages;
  final bool isLoading;
  final String? errorMessage;

  const AIChatState({
    this.messages = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  AIChatState copyWith({
    List<AIChatMessage>? messages,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AIChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class AIChatNotifier extends Notifier<AIChatState> {
  @override
  AIChatState build() {
    return const AIChatState();
  }

  Future<void> sendQuickAction(AICoachRequestType type) async {
    if (state.isLoading) return;

    final userText = _getQuickActionLabel(type);
    final userMsg = AIChatMessage(text: userText, isUser: true, timestamp: DateTime.now(), requestType: type);
    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isLoading: true,
      errorMessage: null,
    );

    try {
      final context = await ref.read(orbitAIContextProvider.future);
      final coachService = ref.read(aiCoachServiceProvider);

      final request = AICoachRequest(type: type, context: context);
      final response = await coachService.processRequest(request);

      final aiMsg = AIChatMessage(
        text: response.text,
        isUser: false,
        timestamp: response.timestamp,
        requestType: type,
      );

      state = state.copyWith(
        messages: [...state.messages, aiMsg],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error connecting to Orbit Coach: $e',
      );
    }
  }

  Future<void> sendUserPrompt(String promptText) async {
    if (promptText.trim().isEmpty || state.isLoading) return;

    final text = promptText.trim();
    final userMsg = AIChatMessage(text: text, isUser: true, timestamp: DateTime.now());
    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isLoading: true,
      errorMessage: null,
    );

    try {
      final context = await ref.read(orbitAIContextProvider.future);
      final coachService = ref.read(aiCoachServiceProvider);

      final request = AICoachRequest.askOrbit(context, text);
      final response = await coachService.processRequest(request);

      final aiMsg = AIChatMessage(
        text: response.text,
        isUser: false,
        timestamp: response.timestamp,
        requestType: AICoachRequestType.askOrbit,
      );

      state = state.copyWith(
        messages: [...state.messages, aiMsg],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error connecting to Orbit Coach: $e',
      );
    }
  }

  void clearChat() {
    state = const AIChatState();
  }

  String _getQuickActionLabel(AICoachRequestType type) {
    switch (type) {
      case AICoachRequestType.scoreExplanation:
        return 'Explain my score';
      case AICoachRequestType.nextAction:
        return 'What should I focus on?';
      case AICoachRequestType.dailyBriefing:
        return 'How did I do today?';
      case AICoachRequestType.weeklyReview:
        return 'Review my week';
      case AICoachRequestType.askOrbit:
        return 'Ask Orbit';
    }
  }
}

final aiChatNotifierProvider = NotifierProvider<AIChatNotifier, AIChatState>(() {
  return AIChatNotifier();
});
