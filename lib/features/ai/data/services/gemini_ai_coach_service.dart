import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:orbit_v2/features/ai/domain/entities/orbit_ai_context.dart';
import 'package:orbit_v2/features/ai/domain/services/i_ai_coach_service.dart';
import 'package:orbit_v2/features/ai/domain/services/orbit_system_prompt.dart';

class GeminiAICoachService implements IAICoachService {
  final String? apiKey;
  final http.Client _client;

  GeminiAICoachService({
    this.apiKey,
    http.Client? client,
  }) : _client = client ?? http.Client();

  @override
  Future<AICoachResponse> processRequest(AICoachRequest request) async {
    final prompt = OrbitSystemPrompt.buildPrompt(request);

    // If API key is available, execute HTTP request to Gemini API
    if (apiKey != null && apiKey!.trim().isNotEmpty) {
      try {
        final uri = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey',
        );

        final response = await _client.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'contents': [
              {
                'parts': [
                  {'text': prompt}
                ]
              }
            ]
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'] as String?;
          if (text != null && text.trim().isNotEmpty) {
            return AICoachResponse(
              text: text.trim(),
              type: request.type,
              timestamp: DateTime.now(),
            );
          }
        } else {
          debugPrint('[AI_COACH] Gemini API returned status ${response.statusCode}: ${response.body}');
        }
      } catch (e) {
        debugPrint('[AI_COACH] Exception contacting Gemini API: $e');
      }
    }

    // Evidence-based local Orbit AI Coach generator when API key is unconfigured or offline
    final fallbackText = _generateEvidenceBasedResponse(request);
    return AICoachResponse(
      text: fallbackText,
      type: request.type,
      timestamp: DateTime.now(),
    );
  }

  String _generateEvidenceBasedResponse(AICoachRequest request) {
    final ctx = request.context;

    switch (request.type) {
      case AICoachRequestType.scoreExplanation:
        return _explainScore(ctx);
      case AICoachRequestType.nextAction:
        return _recommendNextAction(ctx);
      case AICoachRequestType.dailyBriefing:
        return _generateDailyBriefing(ctx);
      case AICoachRequestType.weeklyReview:
        return _generateWeeklyReview(ctx);
      case AICoachRequestType.askOrbit:
        return _answerAskOrbit(ctx, request.userPrompt ?? '');
    }
  }

  String _explainScore(OrbitAIContext ctx) {
    final buffer = StringBuffer();
    buffer.writeln('WHAT HAPPENED:');
    buffer.writeln('Your Orbit Score is currently ${ctx.totalScore} / 100.');
    buffer.writeln('Breakdown: Task (${ctx.taskScore}/25), Focus (${ctx.focusScore}/25), Health (${ctx.healthScore}/25), Goals (${ctx.goalScore}/25).');
    
    if (ctx.score7DayEma != null) {
      final diff = ctx.totalScore - ctx.score7DayEma!;
      if (diff >= 0) {
        buffer.writeln('You are running ${diff.toStringAsFixed(1)} points ahead of your 7-day EMA baseline (${ctx.score7DayEma!.toStringAsFixed(1)}).');
      } else {
        buffer.writeln('You are ${diff.abs().toStringAsFixed(1)} points below your 7-day EMA baseline (${ctx.score7DayEma!.toStringAsFixed(1)}).');
      }
    }

    buffer.writeln('');
    buffer.writeln('WHY IT HAPPENED:');
    final weakestCategory = _findWeakestCategory(ctx);
    buffer.writeln('Your biggest growth opportunity right now is $weakestCategory.');
    if (ctx.focusMinutesToday < ctx.focusTargetMinutes) {
      buffer.writeln('Focus session time is at ${ctx.focusMinutesToday}m against your target of ${ctx.focusTargetMinutes}m.');
    }
    if (ctx.tasksPendingToday > 0) {
      buffer.writeln('You have ${ctx.tasksPendingToday} pending tasks remaining today.');
    }
    if (!ctx.isHealthConnected) {
      buffer.writeln('Health Connect is not connected, so vitality contributions use adaptive weighting.');
    }

    buffer.writeln('');
    buffer.writeln('WHAT TO DO NEXT:');
    if (ctx.tasksPendingToday > 0) {
      buffer.writeln('Complete your highest priority task "${ctx.pendingTaskTitles.firstOrNull ?? "pending task"}" to boost your execution score.');
    } else if (ctx.focusMinutesToday < ctx.focusTargetMinutes) {
      buffer.writeln('Start a 25-minute focus session to build focus momentum.');
    } else {
      buffer.writeln('Review your upcoming goals or log an activity to lock in today\'s gains.');
    }

    return buffer.toString();
  }

  String _recommendNextAction(OrbitAIContext ctx) {
    if (ctx.tasksPendingToday > 0) {
      final topTask = ctx.pendingTaskTitles.firstOrNull ?? 'your next pending task';
      return 'NEXT ACTION:\nComplete "$topTask". Completing your pending tasks will directly increase your Task Score (${ctx.taskScore}/25) and bring you closer to beating yesterday.';
    } else if (ctx.focusMinutesToday < ctx.focusTargetMinutes) {
      final needed = ctx.focusTargetMinutes - ctx.focusMinutesToday;
      return 'NEXT ACTION:\nStart a ${needed > 25 ? 25 : needed}-minute focus session. You have logged ${ctx.focusMinutesToday}m of your ${ctx.focusTargetMinutes}m target today.';
    } else if (!ctx.beatYesterdayAchieved) {
      return 'NEXT ACTION:\nYou are only ${ctx.pointsToBeatYesterday} points away from beating yesterday\'s score. Check off another habit or record a goal milestone to cross the finish line.';
    } else {
      return 'NEXT ACTION:\nYou have beat yesterday and hit your core execution targets! Use the remaining time to plan tomorrow or rest for recovery.';
    }
  }

  String _generateDailyBriefing(OrbitAIContext ctx) {
    final buffer = StringBuffer();
    buffer.writeln('DAILY BRIEFING FOR ${ctx.userName.toUpperCase()}');
    buffer.writeln('Orbit Score: ${ctx.totalScore} / 100');
    if (ctx.beatYesterdayAchieved) {
      buffer.writeln('Status: Yesterday beaten! 🎉');
    } else {
      buffer.writeln('Status: ${ctx.pointsToBeatYesterday} points to beat yesterday.');
    }
    buffer.writeln('');
    buffer.writeln('Execution: ${ctx.tasksCompletedToday} tasks completed, ${ctx.tasksPendingToday} pending (${ctx.overdueTaskCount} overdue).');
    buffer.writeln('Focus: ${ctx.focusMinutesToday}m logged / ${ctx.focusTargetMinutes}m target.');
    buffer.writeln('Habits: ${ctx.habitsCompletedToday} / ${ctx.activeHabitsCount} active habits completed today.');
    
    if (ctx.isHealthConnected) {
      buffer.writeln('Health: ${ctx.stepsState}');
    } else {
      buffer.writeln('Health: Connect Health Connect to sync steps & vitality.');
    }

    return buffer.toString();
  }

  String _generateWeeklyReview(OrbitAIContext ctx) {
    final buffer = StringBuffer();
    buffer.writeln('WEEKLY PERFORMANCE REVIEW');
    buffer.writeln('7-Day Score Baseline: ${ctx.score7DayEma != null ? ctx.score7DayEma!.toStringAsFixed(1) : "Insufficient historical days"}');
    buffer.writeln('Active Habits: ${ctx.activeHabitsCount} (${ctx.habitsCompletedToday} completed today)');
    buffer.writeln('Focus Minutes Logged Today: ${ctx.focusMinutesToday}m');
    if (ctx.personalRecords.isNotEmpty) {
      buffer.writeln('Milestones Reached: ${ctx.personalRecords.join(", ")}');
    }
    buffer.writeln('\nRecommendation: Maintain your focus and habit consistency to keep elevating your 7-day EMA score.');
    return buffer.toString();
  }

  String _answerAskOrbit(OrbitAIContext ctx, String query) {
    final q = query.toLowerCase();
    if (q.contains('why') && (q.contains('score') || q.contains('low'))) {
      return _explainScore(ctx);
    } else if (q.contains('what') && (q.contains('do') || q.contains('focus') || q.contains('next'))) {
      return _recommendNextAction(ctx);
    } else if (q.contains('health') || q.contains('step') || q.contains('sleep')) {
      if (!ctx.isHealthConnected) {
        return 'Health Connect is currently NOT CONNECTED. Connect Health Connect in settings to track steps, sleep, active energy, and heart rate metrics.';
      }
      return 'HEALTH SUMMARY:\n- Steps: ${ctx.stepsState}\n- Calories: ${ctx.caloriesState}\n- Sleep: ${ctx.sleepState}\n- Active Minutes: ${ctx.activeMinutesState}';
    } else if (q.contains('how') && q.contains('today')) {
      return _generateDailyBriefing(ctx);
    } else {
      return 'Based on your current Orbit state (Score: ${ctx.totalScore}/100, ${ctx.tasksCompletedToday} tasks completed, ${ctx.focusMinutesToday}m focus):\n\nTo improve your score, focus on completing your ${ctx.tasksPendingToday} pending tasks and logging focus sessions towards your ${ctx.focusTargetMinutes}m target.';
    }
  }

  String _findWeakestCategory(OrbitAIContext ctx) {
    int minScore = ctx.taskScore;
    String name = 'Tasks';
    if (ctx.focusScore < minScore) {
      minScore = ctx.focusScore;
      name = 'Focus';
    }
    if (ctx.healthScore < minScore) {
      minScore = ctx.healthScore;
      name = 'Health';
    }
    if (ctx.goalScore < minScore) {
      minScore = ctx.goalScore;
      name = 'Goals';
    }
    return name;
  }
}
