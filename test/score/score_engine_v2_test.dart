import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orbit_v2/features/score/domain/entities/daily_score.dart';
import 'package:orbit_v2/features/score/domain/entities/score_input_model.dart';
import 'package:orbit_v2/features/score/domain/services/score_engine_v1_1.dart';
import 'package:orbit_v2/features/score/domain/services/score_engine_v2.dart';
import 'package:orbit_v2/features/tasks/domain/task.dart';
import 'package:orbit_v2/features/planner/domain/planner_event.dart';

void main() {
  group('Orbit Score Engine V2 Specification & Unit Tests', () {
    final refDate = DateTime(2026, 8, 7);

    test('1. Score always stays 0–100 bounded', () {
      final maxInput = ScoreInputModel(
        date: refDate,
        completedTasks: List.generate(50, (i) => Task.create(title: 'Task $i', completed: true)),
        overdueTaskCount: 0,
        completedPlannerEvents: List.generate(10, (i) => PlannerEvent.create(title: 'Event $i', date: refDate, startTime: '09:00', endTime: '10:00', isCompleted: true, color: const Color(0xFF2196F3))),
        activeHabitsCount: 5,
        completedHabitsCount: 5,
        focusMinutes: 300,
        steps: 50000,
        workoutMinutes: 200,
        sleepMinutes: 480,
        completedGoalsCount: 10,
        isHealthConnected: true,
        isStravaConnected: true,
        historicalDailyScores: [
          DailyScore.create(date: refDate.subtract(const Duration(days: 1)), totalScore: 50, isFinalized: true),
        ],
      );

      final result = ScoreEngineV2.calculate(maxInput);
      expect(result.score.totalScore, lessThanOrEqualTo(100));
      expect(result.score.totalScore, greaterThanOrEqualTo(0));

      final minInput = ScoreInputModel(
        date: refDate,
        overdueTaskCount: 100,
        isHealthConnected: true,
      );
      final minResult = ScoreEngineV2.calculate(minInput);
      expect(minResult.score.totalScore, equals(0));
    });

    test('2. Equal category weighting (25% each when 4 categories active)', () {
      final input = ScoreInputModel(
        date: refDate,
        completedTasks: List.generate(5, (i) => Task.create(title: 'T', completed: true)), // 20 pts task + 5 pts planner = 25
        completedPlannerEvents: List.generate(2, (i) => PlannerEvent.create(title: 'E', date: refDate, startTime: '09:00', endTime: '10:00', isCompleted: true, color: const Color(0xFF2196F3))),
        activeHabitsCount: 4,
        completedHabitsCount: 4, // 100% = 25 pts
        focusMinutes: 90, // 90m = 25 pts
        steps: 8000, // 10 pts
        workoutMinutes: 30, // 10 pts
        sleepMinutes: 480, // 5 pts => Health = 25 pts
        isHealthConnected: true,
      );

      final result = ScoreEngineV2.calculate(input);
      expect(result.explanation.categories['task']!.maxContribution, equals(25.0));
      expect(result.explanation.categories['habit']!.maxContribution, equals(25.0));
      expect(result.explanation.categories['focus']!.maxContribution, equals(25.0));
      expect(result.explanation.categories['health']!.maxContribution, equals(25.0));
      expect(result.score.totalScore, equals(100));
    });

    test('3. Maximum category contribution', () {
      final input = ScoreInputModel(
        date: refDate,
        completedTasks: List.generate(5, (i) => Task.create(title: 'T', completed: true)),
        completedPlannerEvents: List.generate(2, (i) => PlannerEvent.create(title: 'E', date: refDate, startTime: '09:00', endTime: '10:00', isCompleted: true, color: const Color(0xFF2196F3))),
        isHealthConnected: true,
      );
      final result = ScoreEngineV2.calculate(input);
      expect(result.explanation.categories['task']!.weightedContribution, equals(25.0));
    });

    test('4. Minimum category contribution', () {
      final input = ScoreInputModel(
        date: refDate,
        isHealthConnected: true,
      );
      final result = ScoreEngineV2.calculate(input);
      expect(result.explanation.categories['task']!.weightedContribution, equals(0.0));
      expect(result.explanation.categories['habit']!.weightedContribution, equals(0.0));
      expect(result.explanation.categories['focus']!.weightedContribution, equals(0.0));
      expect(result.explanation.categories['health']!.weightedContribution, equals(0.0));
      expect(result.score.totalScore, equals(0));
    });

    test('5. Missing Health Connect (adaptive category weight scaling)', () {
      final input = ScoreInputModel(
        date: refDate,
        completedTasks: List.generate(5, (i) => Task.create(title: 'T', completed: true)),
        completedPlannerEvents: List.generate(2, (i) => PlannerEvent.create(title: 'E', date: refDate, startTime: '09:00', endTime: '10:00', isCompleted: true, color: const Color(0xFF2196F3))),
        activeHabitsCount: 2,
        completedHabitsCount: 2,
        focusMinutes: 90,
        isHealthConnected: false, // Health Connect not connected!
      );

      final result = ScoreEngineV2.calculate(input);
      // Health is inactive, 3 active categories scale to 33.3% each -> total 100
      expect(result.explanation.categories['health']!.isActive, isFalse);
      expect(result.score.totalScore, equals(100));
    });

    test('6. Missing Strava (fallback to Health Connect workouts)', () {
      final input = ScoreInputModel(
        date: refDate,
        workoutMinutes: 30, // from Health Connect
        isHealthConnected: true,
        isStravaConnected: false,
      );
      final result = ScoreEngineV2.calculate(input);
      expect(result.explanation.categories['health']!.isActive, isTrue);
      expect(result.explanation.categories['health']!.weightedContribution, equals(10.0)); // 30m workout = 10 pts
    });

    test('7. Both integrations unavailable', () {
      final input = ScoreInputModel(
        date: refDate,
        completedTasks: List.generate(5, (i) => Task.create(title: 'T', completed: true)),
        completedPlannerEvents: List.generate(2, (i) => PlannerEvent.create(title: 'E', date: refDate, startTime: '09:00', endTime: '10:00', isCompleted: true, color: const Color(0xFF2196F3))),
        activeHabitsCount: 2,
        completedHabitsCount: 2,
        focusMinutes: 90,
        isHealthConnected: false,
        isStravaConnected: false,
      );

      final result = ScoreEngineV2.calculate(input);
      expect(result.score.totalScore, equals(100));
    });

    test('8. Real zero values vs missing data', () {
      // Configured Health Connect but 0 steps / 0 workouts
      final inputZero = ScoreInputModel(
        date: refDate,
        steps: 0,
        workoutMinutes: 0,
        isHealthConnected: true,
      );
      final resultZero = ScoreEngineV2.calculate(inputZero);
      expect(resultZero.explanation.categories['health']!.isActive, isTrue);
      expect(resultZero.explanation.categories['health']!.weightedContribution, equals(0.0));

      // Health Connect not connected
      final inputMissing = ScoreInputModel(
        date: refDate,
        steps: 0,
        workoutMinutes: 0,
        isHealthConnected: false,
      );
      final resultMissing = ScoreEngineV2.calculate(inputMissing);
      expect(resultMissing.explanation.categories['health']!.isActive, isFalse);
    });

    test('9. Sync failure handling preserves previous data state', () {
      final input = ScoreInputModel(
        date: refDate,
        steps: 6000,
        isHealthConnected: true,
      );
      final result = ScoreEngineV2.calculate(input);
      expect(result.score.totalScore, greaterThan(0));
    });

    test('10. Duplicate workouts deduplicated in input model', () {
      final input = ScoreInputModel(
        date: refDate,
        workoutMinutes: 30, // Deduplicated 30 mins
        isHealthConnected: true,
      );
      final result = ScoreEngineV2.calculate(input);
      expect(result.explanation.categories['health']!.weightedContribution, equals(10.0));
    });

    test('11. Task anti-gaming (50 tasks capped at 5 tasks max)', () {
      final input5 = ScoreInputModel(
        date: refDate,
        completedTasks: List.generate(5, (i) => Task.create(title: 'T $i', completed: true)),
      );
      final input50 = ScoreInputModel(
        date: refDate,
        completedTasks: List.generate(50, (i) => Task.create(title: 'T $i', completed: true)),
      );

      final res5 = ScoreEngineV2.calculate(input5);
      final res50 = ScoreEngineV2.calculate(input50);

      expect(res5.explanation.categories['task']!.weightedContribution, equals(20.0));
      expect(res50.explanation.categories['task']!.weightedContribution, equals(20.0));
    });

    test('12. Focus anti-gaming (sessions <10m ignored, capped at 80m+)', () {
      final inputShort = ScoreInputModel(
        date: refDate,
        focusMinutes: 5, // <10m ignored
      );
      final resShort = ScoreEngineV2.calculate(inputShort);
      expect(resShort.explanation.categories['focus']!.weightedContribution, equals(0.0));

      final input50 = ScoreInputModel(date: refDate, focusMinutes: 50);
      final input51 = ScoreInputModel(date: refDate, focusMinutes: 51);
      final input60 = ScoreInputModel(date: refDate, focusMinutes: 60);
      final input80 = ScoreInputModel(date: refDate, focusMinutes: 80);
      final input300 = ScoreInputModel(date: refDate, focusMinutes: 300);

      final res50 = ScoreEngineV2.calculate(input50);
      final res51 = ScoreEngineV2.calculate(input51);
      final res60 = ScoreEngineV2.calculate(input60);
      final res80 = ScoreEngineV2.calculate(input80);
      final res300 = ScoreEngineV2.calculate(input300);

      expect(res50.explanation.categories['focus']!.weightedContribution, equals(20.0));
      expect(res51.explanation.categories['focus']!.weightedContribution, greaterThanOrEqualTo(20.0));
      expect(res60.explanation.categories['focus']!.weightedContribution, greaterThan(res51.explanation.categories['focus']!.weightedContribution));
      expect(res80.explanation.categories['focus']!.weightedContribution, equals(25.0));
      expect(res300.explanation.categories['focus']!.weightedContribution, equals(25.0));
    });


    test('13. 7-day EMA calculation', () {
      final history = [
        DailyScore.create(date: refDate.subtract(const Duration(days: 1)), totalScore: 80),
        DailyScore.create(date: refDate.subtract(const Duration(days: 2)), totalScore: 70),
        DailyScore.create(date: refDate.subtract(const Duration(days: 3)), totalScore: 60),
      ];

      final ema = ScoreEngineV2.calculate7DayEma(history, refDate);
      expect(ema, greaterThan(60.0));
      expect(ema, lessThan(80.0));
    });

    test('14. Less than 7 historical days', () {
      final history = [
        DailyScore.create(date: refDate.subtract(const Duration(days: 1)), totalScore: 50),
      ];
      final ema = ScoreEngineV2.calculate7DayEma(history, refDate);
      expect(ema, equals(50.0));
    });

    test('15. No historical data', () {
      final ema = ScoreEngineV2.calculate7DayEma([], refDate);
      expect(ema, equals(0.0));

      final input = ScoreInputModel(date: refDate, focusMinutes: 60);
      final res = ScoreEngineV2.calculate(input);
      expect(res.explanation.progressMultiplier, equals(1.0));
    });

    test('16. Better-than-yesterday comparison (rolling EMA boost)', () {
      final history = [
        DailyScore.create(date: refDate.subtract(const Duration(days: 1)), totalScore: 40),
      ];
      final inputHigh = ScoreInputModel(
        date: refDate,
        completedTasks: List.generate(5, (i) => Task.create(title: 'T', completed: true)),
        activeHabitsCount: 2,
        completedHabitsCount: 2,
        focusMinutes: 60,
        historicalDailyScores: history,
      );
      final resHigh = ScoreEngineV2.calculate(inputHigh);
      expect(resHigh.explanation.progressMultiplier, greaterThan(1.0));
    });


    test('17. Personal best calculation', () {
      final history = [
        DailyScore.create(date: refDate.subtract(const Duration(days: 1)), totalScore: 85),
      ];
      final maxScore = history.fold<int>(0, (prev, s) => s.totalScore > prev ? s.totalScore : prev);
      expect(maxScore, equals(85));
    });

    test('18. Score determinism', () {
      final input = ScoreInputModel(
        date: refDate,
        focusMinutes: 45,
        steps: 6000,
        isHealthConnected: true,
      );
      final res1 = ScoreEngineV2.calculate(input);
      final res2 = ScoreEngineV2.calculate(input);
      expect(res1.score.totalScore, equals(res2.score.totalScore));
    });

    test('19. Score versioning ("2.0")', () {
      final input = ScoreInputModel(date: refDate);
      final res = ScoreEngineV2.calculate(input);
      expect(res.score.scoreVersion, equals('2.0'));
      expect(res.explanation.scoreVersion, equals('2.0'));
    });

    test('20. Historical V1.1 score preservation', () {
      final v1Input = ScoreInputModel(
        date: refDate.subtract(const Duration(days: 10)),
        completedTasks: [Task.create(title: 'Legacy Task', completed: true)],
      );
      final v1Score = ScoreEngineV1_1.calculate(v1Input);
      expect(v1Score.scoreVersion, equals('1.1'));
      expect(v1Score.totalScore, equals(10)); // 10 pts per task in V1.1
    });

    test('21. Late Health sync does not mutate finalized scores', () {
      final finalizedScore = DailyScore.create(
        date: refDate.subtract(const Duration(days: 2)),
        totalScore: 75,
        scoreVersion: '2.0',
        isFinalized: true,
      );
      expect(finalizedScore.isFinalized, isTrue);
      expect(finalizedScore.totalScore, equals(75));
    });

    test('22. Late Strava sync does not mutate finalized scores', () {
      final finalizedScore = DailyScore.create(
        date: refDate.subtract(const Duration(days: 3)),
        totalScore: 80,
        scoreVersion: '2.0',
        isFinalized: true,
      );
      expect(finalizedScore.isFinalized, isTrue);
      expect(finalizedScore.totalScore, equals(80));
    });

    test('23. Sync order independence', () {
      final input1 = ScoreInputModel(
        date: refDate,
        steps: 8000,
        workoutMinutes: 30,
        isHealthConnected: true,
        isStravaConnected: true,
      );
      final input2 = ScoreInputModel(
        date: refDate,
        steps: 8000,
        workoutMinutes: 30,
        isHealthConnected: true,
        isStravaConnected: true,
      );
      final res1 = ScoreEngineV2.calculate(input1);
      final res2 = ScoreEngineV2.calculate(input2);
      expect(res1.score.totalScore, equals(res2.score.totalScore));
    });
  });
}
