import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orbit_v2/features/ai/domain/entities/orbit_ai_context.dart';
import 'package:orbit_v2/features/ai/domain/services/orbit_context_builder.dart';
import 'package:orbit_v2/features/ai/domain/services/i_ai_coach_service.dart';
import 'package:orbit_v2/features/ai/domain/services/orbit_system_prompt.dart';
import 'package:orbit_v2/features/ai/data/services/gemini_ai_coach_service.dart';
import 'package:orbit_v2/features/dashboard/domain/entities/dashboard_state.dart';
import 'package:orbit_v2/features/score/domain/entities/daily_score.dart';
import 'package:orbit_v2/features/settings/domain/user_preferences.dart';
import 'package:orbit_v2/features/tasks/domain/task.dart';
import 'package:orbit_v2/features/habits/domain/habit.dart';
import 'package:http/http.dart' as http;

void main() {
  group('OrbitAIContext & Metric Availability Tests', () {
    test('HealthMetricState handles connected and disconnected states honestly', () {
      final connected = HealthMetricState.available(8500, 'steps');
      expect(connected.isAvailable, isTrue);
      expect(connected.value, 8500);
      expect(connected.toString(), contains('8500 steps'));

      final disconnected = HealthMetricState.notConnected('steps');
      expect(disconnected.isAvailable, isFalse);
      expect(disconnected.value, isNull);
      expect(disconnected.toString(), contains('NOT CONNECTED'));
      expect(disconnected.toString(), isNot(contains('0 steps')));
    });

    test('OrbitContextBuilder preserves real state and disconnected integration flags', () {
      final now = DateTime.now();
      final dailyScore = DailyScore.create(
        date: now,
        totalScore: 76,
        taskScore: 20,
        focusScore: 18,
        goalScore: 20,
      );

      final dashboardState = DashboardState(
        orbitScore: dailyScore,
        taskSummary: const DashboardTaskSummary(completed: 4, remaining: 2),
        focusSummary: const DashboardFocusSummary(minutesCompleted: 45, minutesTarget: 60),
        healthSummary: const DashboardHealthSummary(steps: 0, calories: 0.0, workoutMinutes: 0, sleepMinutes: 0),
        todayEvents: const [],
        goalSummary: const DashboardGoalSummary(completed: 1, remaining: 1),
        currentStreak: 5,
        longestStreak: 10,
        todayTimeline: const [],
        beatYesterdayScore: 5,
        personalRecords: const [],
      );

      final prefs = UserPreferences.defaultValues()..userName = 'Alex';

      final context = OrbitContextBuilder.buildFromState(
        dashboardState: dashboardState,
        preferences: prefs,
        isHealthAuthorized: false,
        healthSnapshot: null,
        pendingTasks: [
          Task.create(title: 'Write AI Coach Unit Tests'),
        ],
        habits: [
          Habit.create(
            title: 'Meditation',
            icon: Icons.self_improvement,
            color: Colors.blue,
            currentStreak: 7,
          ),
        ],
      );

      expect(context.userName, 'Alex');
      expect(context.totalScore, 76);
      expect(context.isHealthConnected, isFalse);
      expect(context.stepsState.availability, MetricAvailability.notConnected);
      expect(context.stepsState.value, isNull);
      expect(context.pendingTaskTitles, contains('Write AI Coach Unit Tests'));
      expect(context.habitSummaries.first, contains('Meditation'));
    });
  });

  group('Orbit System Prompt Generation Tests', () {
    test('OrbitSystemPrompt builds evidence-backed instructions without hardcoded metrics', () {
      final context = OrbitAIContext(
        timestamp: DateTime.now(),
        userName: 'Alex',
        userTagline: 'Productivity Architect',
        totalScore: 82,
        taskScore: 22,
        focusScore: 20,
        healthScore: 20,
        goalScore: 20,
        score7DayEma: 78.5,
        pointsToBeatYesterday: 0,
        beatYesterdayAchieved: true,
        tasksCompletedToday: 5,
        tasksPendingToday: 1,
        overdueTaskCount: 0,
        pendingTaskTitles: ['Deploy Production App'],
        activeHabitsCount: 4,
        habitsCompletedToday: 4,
        focusMinutesToday: 75,
        focusTargetMinutes: 60,
        isHealthConnected: true,
        stepsState: HealthMetricState.available(9200, 'steps'),
        caloriesState: HealthMetricState.available(450, 'kcal'),
        totalCaloriesState: HealthMetricState.available(1850, 'kcal'),
        sleepState: HealthMetricState.available(480, 'minutes', '8h 0m'),
        heartRateState: HealthMetricState.available(65, 'BPM'),
        restingHeartRateState: HealthMetricState.available(60, 'BPM'),
        activeMinutesState: HealthMetricState.available(45, 'minutes'),
        isStravaConnected: false,
        stravaActivitiesCountToday: 0,
        activeGoalsCount: 2,
        goalsCompletedToday: 1,
      );

      final request = AICoachRequest.scoreExplanation(context);
      final prompt = OrbitSystemPrompt.buildPrompt(request);

      expect(prompt, contains('ORBIT COACH'));
      expect(prompt, contains('USER: Alex'));
      expect(prompt, contains('ORBIT SCORE: 82 / 100'));
      expect(prompt, contains('9200 steps'));
      expect(prompt, contains('INSTRUCTION: Explain the user\'s Orbit Score today.'));
    });
  });

  group('GeminiAICoachService Evidence-Based Fallback Tests', () {
    test('GeminiAICoachService answers scoreExplanation with real context evidence', () async {
      final context = OrbitAIContext(
        timestamp: DateTime.now(),
        userName: 'Alex',
        userTagline: 'Developer',
        totalScore: 68,
        taskScore: 15,
        focusScore: 15,
        healthScore: 18,
        goalScore: 20,
        score7DayEma: 75.0,
        pointsToBeatYesterday: 8,
        beatYesterdayAchieved: false,
        tasksCompletedToday: 2,
        tasksPendingToday: 3,
        overdueTaskCount: 1,
        pendingTaskTitles: ['Refactor Engine'],
        activeHabitsCount: 3,
        habitsCompletedToday: 1,
        focusMinutesToday: 30,
        focusTargetMinutes: 60,
        isHealthConnected: false,
        stepsState: HealthMetricState.notConnected('steps'),
        caloriesState: HealthMetricState.notConnected('kcal'),
        totalCaloriesState: HealthMetricState.notConnected('kcal'),
        sleepState: HealthMetricState.notConnected('minutes'),
        heartRateState: HealthMetricState.notConnected('BPM'),
        restingHeartRateState: HealthMetricState.notConnected('BPM'),
        activeMinutesState: HealthMetricState.notConnected('minutes'),
        isStravaConnected: false,
        stravaActivitiesCountToday: 0,
        activeGoalsCount: 2,
        goalsCompletedToday: 1,
      );

      final service = GeminiAICoachService(); // Unconfigured API key triggers local evidence engine
      final response = await service.processRequest(AICoachRequest.scoreExplanation(context));

      expect(response.text, contains('Orbit Score is currently 68 / 100'));
      expect(response.text, contains('below your 7-day EMA baseline (75.0)'));
      expect(response.text, contains('Tasks')); // Weakest category
      expect(response.text, contains('Refactor Engine'));
      expect(response.type, AICoachRequestType.scoreExplanation);
    });

    test('GeminiAICoachService answers nextAction prioritizing top pending task', () async {
      final context = OrbitAIContext(
        timestamp: DateTime.now(),
        userName: 'Alex',
        userTagline: 'Developer',
        totalScore: 70,
        taskScore: 15,
        focusScore: 20,
        healthScore: 15,
        goalScore: 20,
        pointsToBeatYesterday: 5,
        beatYesterdayAchieved: false,
        tasksCompletedToday: 3,
        tasksPendingToday: 2,
        overdueTaskCount: 0,
        pendingTaskTitles: ['Review PR #42'],
        activeHabitsCount: 2,
        habitsCompletedToday: 2,
        focusMinutesToday: 60,
        focusTargetMinutes: 60,
        isHealthConnected: true,
        stepsState: HealthMetricState.available(6000, 'steps'),
        caloriesState: HealthMetricState.available(300, 'kcal'),
        totalCaloriesState: HealthMetricState.available(1700, 'kcal'),
        sleepState: HealthMetricState.available(420, 'minutes'),
        heartRateState: HealthMetricState.available(72, 'BPM'),
        restingHeartRateState: HealthMetricState.available(64, 'BPM'),
        activeMinutesState: HealthMetricState.available(30, 'minutes'),
        isStravaConnected: false,
        stravaActivitiesCountToday: 0,
        activeGoalsCount: 1,
        goalsCompletedToday: 1,
      );

      final service = GeminiAICoachService();
      final response = await service.processRequest(AICoachRequest.nextAction(context));

      expect(response.text, contains('NEXT ACTION:'));
      expect(response.text, contains('Review PR #42'));
    });

    test('GeminiAICoachService sends request to Gemini API endpoint when API key is provided', () async {
      final context = OrbitAIContext(
        timestamp: DateTime.now(),
        userName: 'Alex',
        userTagline: 'Developer',
        totalScore: 85,
        taskScore: 22,
        focusScore: 22,
        healthScore: 20,
        goalScore: 21,
        pointsToBeatYesterday: 0,
        beatYesterdayAchieved: true,
        tasksCompletedToday: 5,
        tasksPendingToday: 0,
        overdueTaskCount: 0,
        activeHabitsCount: 3,
        habitsCompletedToday: 3,
        focusMinutesToday: 90,
        focusTargetMinutes: 60,
        isHealthConnected: true,
        stepsState: HealthMetricState.available(10000, 'steps'),
        caloriesState: HealthMetricState.available(500, 'kcal'),
        totalCaloriesState: HealthMetricState.available(2100, 'kcal'),
        sleepState: HealthMetricState.available(480, 'minutes'),
        heartRateState: HealthMetricState.available(62, 'BPM'),
        restingHeartRateState: HealthMetricState.available(58, 'BPM'),
        activeMinutesState: HealthMetricState.available(60, 'minutes'),
        isStravaConnected: false,
        stravaActivitiesCountToday: 0,
        activeGoalsCount: 2,
        goalsCompletedToday: 2,
      );

      Uri? requestedUri;
      String? requestBody;

      final mockClient = MockHttpClient((req) async {
        requestedUri = req.url;
        requestBody = req.body;
        return http.Response(
          '{"candidates": [{"content": {"parts": [{"text": "Gemini AI Coach: Excellent consistency today! You have hit all your focus and step targets."}]}}]}',
          200,
        );
      });

      final service = GeminiAICoachService(
        apiKey: 'TEST_GEMINI_KEY_123',
        client: mockClient,
      );

      final response = await service.processRequest(AICoachRequest.dailyBriefing(context));

      expect(requestedUri.toString(), contains('generativelanguage.googleapis.com'));
      expect(requestedUri.toString(), contains('key=TEST_GEMINI_KEY_123'));
      expect(requestBody, contains('USER: Alex'));
      expect(requestBody, contains('10000 steps'));
      expect(response.text, contains('Gemini AI Coach: Excellent consistency today!'));
    });

    test('GeminiAICoachService gracefully falls back when API returns HTTP 500', () async {
      final context = OrbitAIContext(
        timestamp: DateTime.now(),
        userName: 'Alex',
        userTagline: 'Developer',
        totalScore: 70,
        taskScore: 15,
        focusScore: 20,
        healthScore: 15,
        goalScore: 20,
        pointsToBeatYesterday: 5,
        beatYesterdayAchieved: false,
        tasksCompletedToday: 3,
        tasksPendingToday: 2,
        overdueTaskCount: 0,
        pendingTaskTitles: ['Fix Bug #101'],
        activeHabitsCount: 2,
        habitsCompletedToday: 2,
        focusMinutesToday: 60,
        focusTargetMinutes: 60,
        isHealthConnected: true,
        stepsState: HealthMetricState.available(6000, 'steps'),
        caloriesState: HealthMetricState.available(300, 'kcal'),
        totalCaloriesState: HealthMetricState.available(1800, 'kcal'),
        sleepState: HealthMetricState.available(420, 'minutes'),
        heartRateState: HealthMetricState.available(72, 'BPM'),
        restingHeartRateState: HealthMetricState.available(65, 'BPM'),
        activeMinutesState: HealthMetricState.available(30, 'minutes'),
        isStravaConnected: false,
        stravaActivitiesCountToday: 0,
        activeGoalsCount: 1,
        goalsCompletedToday: 1,
      );

      final mockClient = MockHttpClient((req) async {
        return http.Response('{"error": "Internal Error"}', 500);
      });

      final service = GeminiAICoachService(
        apiKey: 'TEST_KEY',
        client: mockClient,
      );

      final response = await service.processRequest(AICoachRequest.nextAction(context));

      // Should fall back to evidence-based local response without throwing
      expect(response.text, contains('NEXT ACTION:'));
      expect(response.text, contains('Fix Bug #101'));
    });
  });
}

class MockHttpClient extends http.BaseClient {
  final Future<http.Response> Function(http.Request request) handler;
  MockHttpClient(this.handler);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = await handler(request as http.Request);
    return http.StreamedResponse(
      Stream.value(response.bodyBytes),
      response.statusCode,
      headers: response.headers,
    );
  }
}
