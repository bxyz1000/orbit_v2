import 'package:orbit_v2/features/ai/domain/entities/orbit_ai_context.dart';

enum AICoachRequestType {
  dailyBriefing,
  scoreExplanation,
  nextAction,
  weeklyReview,
  askOrbit,
}

class AICoachRequest {
  final AICoachRequestType type;
  final String? userPrompt;
  final OrbitAIContext context;

  const AICoachRequest({
    required this.type,
    this.userPrompt,
    required this.context,
  });

  factory AICoachRequest.dailyBriefing(OrbitAIContext context) =>
      AICoachRequest(type: AICoachRequestType.dailyBriefing, context: context);

  factory AICoachRequest.scoreExplanation(OrbitAIContext context) =>
      AICoachRequest(type: AICoachRequestType.scoreExplanation, context: context);

  factory AICoachRequest.nextAction(OrbitAIContext context) =>
      AICoachRequest(type: AICoachRequestType.nextAction, context: context);

  factory AICoachRequest.weeklyReview(OrbitAIContext context) =>
      AICoachRequest(type: AICoachRequestType.weeklyReview, context: context);

  factory AICoachRequest.askOrbit(OrbitAIContext context, String prompt) =>
      AICoachRequest(type: AICoachRequestType.askOrbit, userPrompt: prompt, context: context);
}

class AICoachResponse {
  final String text;
  final AICoachRequestType type;
  final DateTime timestamp;

  const AICoachResponse({
    required this.text,
    required this.type,
    required this.timestamp,
  });
}

abstract class IAICoachService {
  Future<AICoachResponse> processRequest(AICoachRequest request);
}
