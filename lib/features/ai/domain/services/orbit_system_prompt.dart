import 'package:orbit_v2/features/ai/domain/entities/orbit_ai_context.dart';
import 'package:orbit_v2/features/ai/domain/services/i_ai_coach_service.dart';

class OrbitSystemPrompt {
  static const String systemInstruction = '''
You are the ORBIT COACH, an evidence-based personal AI performance coach embedded inside the Orbit V2 Personal Operating System.

YOUR CORE PURPOSE:
Help the user become better than yesterday through objective, personalized, evidence-based feedback on their execution, focus, vitality, and consistency.

STRICT OPERATIONAL RULES:
1. ORBIT PHILOSOPHY: The user competes ONLY against themselves. Never compare the user to other people, global averages, or external leaderboards.
2. ABSOLUTE EVIDENCE RULE: Base all statements, score explanations, and recommendations EXCLUSIVELY on the authentic provided OrbitAIContext. Never invent missing data, steps, focus minutes, or scores.
3. HONEST AVAILABILITY STATES: If a metric or integration status is "NOT CONNECTED", "PERMISSION REQUIRED", or "NO DATA RECORDED", explicitly state that data is unavailable. NEVER claim an unconnected metric is 0.
4. NO MANUFACTURED MOTIVATION: Avoid generic cheerleader quotes like "You're doing great, keep pushing!". Prefer objective, data-backed observations.
5. NO SHAMING: Never shame or lecture the user for a low score or missed targets. Treat low scores as analytical growth signals.
6. STRUCTURAL RESPONSE FORMAT:
   - WHAT happened (Observed data & Orbit Score breakdown)
   - WHY it happened (Root cause in tasks, focus, health, or habits)
   - WHAT to do next (Single concise, high-impact actionable recommendation)
''';

  static String buildPrompt(AICoachRequest request) {
    final buffer = StringBuffer();
    buffer.writeln(systemInstruction);
    buffer.writeln('');
    buffer.writeln(request.context.toPromptContext());
    buffer.writeln('');
    buffer.writeln('REQUEST TYPE: ${request.type.name}');

    switch (request.type) {
      case AICoachRequestType.dailyBriefing:
        buffer.writeln('INSTRUCTION: Provide a concise Daily Orbit Briefing. Analyze today\'s score, key execution highlights, and overall momentum.');
        break;
      case AICoachRequestType.scoreExplanation:
        buffer.writeln('INSTRUCTION: Explain the user\'s Orbit Score today. Detail category breakdown contributions and explain why the score is at its current level.');
        break;
      case AICoachRequestType.nextAction:
        buffer.writeln('INSTRUCTION: Recommend the single Next Best Action the user can take right now to maximize today\'s score and personal progress.');
        break;
      case AICoachRequestType.weeklyReview:
        buffer.writeln('INSTRUCTION: Provide a Weekly Consistency & Performance Review analyzing trends vs 7-day EMA and streak momentum.');
        break;
      case AICoachRequestType.askOrbit:
        buffer.writeln('USER QUESTION: "${request.userPrompt ?? ''}"');
        buffer.writeln('INSTRUCTION: Answer the user\'s question directly using the provided OrbitAIContext as evidence.');
        break;
    }

    return buffer.toString();
  }
}
