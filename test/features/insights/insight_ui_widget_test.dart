import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbit_v2/features/insights/domain/entities/insight_priority.dart';
import 'package:orbit_v2/features/insights/domain/entities/insight_type.dart';
import 'package:orbit_v2/features/insights/domain/entities/orbit_insight.dart';
import 'package:orbit_v2/features/insights/presentation/providers/insight_providers.dart';
import 'package:orbit_v2/features/insights/presentation/widgets/insight_card.dart';
import 'package:orbit_v2/features/insights/presentation/widgets/todays_insights_section.dart';
import 'package:orbit_v2/features/insights/presentation/widgets/category_insights_section.dart';

void main() {
  final testDate = DateTime(2026, 8, 7);

  final testInsightImprovement = OrbitInsight(
    id: 'ins_1',
    type: InsightType.scoreImprovement,
    priority: InsightPriority.high,
    title: 'Score Improved Today',
    description: 'Your Orbit Score increased by 15 points compared to yesterday.',
    category: 'Tasks & Execution',
    currentValue: 75.0,
    previousValue: 60.0,
    change: 15.0,
    date: testDate,
  );

  final testInsightPR = OrbitInsight(
    id: 'ins_pr',
    type: InsightType.personalRecord,
    priority: InsightPriority.high,
    title: 'New Personal Best!',
    description: 'Congratulations! You set a new personal record in Daily Score: 95.',
    category: 'Milestone',
    currentValue: 95.0,
    date: testDate,
  );

  Widget createWidgetUnderTest(Widget child, {dynamic overrides}) {
    return ProviderScope(
      overrides: overrides != null ? (overrides as List).cast() : const [],
      child: MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: child,
          ),
        ),
      ),
    );
  }



  group('Insight UI Widget Tests', () {
    testWidgets('InsightCard renders title, description, priority badge, and supporting chip', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        InsightCard(insight: testInsightImprovement),
      ));

      expect(find.text('Score Improved Today'), findsOneWidget);
      expect(find.textContaining('increased by 15 points'), findsOneWidget);
      expect(find.text('HIGH PRIORITY'), findsOneWidget);
      expect(find.text('TASKS & EXECUTION'), findsOneWidget);
      expect(find.text('+15 pts'), findsOneWidget);
    });

    testWidgets('InsightCard renders Personal Best celebration style', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        InsightCard(insight: testInsightPR),
      ));

      expect(find.text('New Personal Best!'), findsOneWidget);
      expect(find.textContaining('Daily Score: 95'), findsOneWidget);
      expect(find.byIcon(Icons.military_tech), findsOneWidget);
    });

    testWidgets('TodaysInsightsSection renders empty state when provider has empty list', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        const TodaysInsightsSection(),
        overrides: [
          dailyInsightsProvider.overrideWith((ref) async => []),
        ],
      ));

      await tester.pumpAndSettle();

      expect(find.text("Today's Insights"), findsOneWidget);
      expect(find.text("You're all caught up!"), findsOneWidget);
    });

    testWidgets('TodaysInsightsSection renders list of insights when provider emits data', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        const TodaysInsightsSection(),
        overrides: [
          dailyInsightsProvider.overrideWith((ref) async => [testInsightImprovement, testInsightPR]),
        ],
      ));

      await tester.pumpAndSettle();

      expect(find.text("Today's Insights"), findsOneWidget);
      expect(find.text('Score Improved Today'), findsOneWidget);
      expect(find.text('New Personal Best!'), findsOneWidget);
    });

    testWidgets('CategoryInsightsSection renders category growth opportunities', (tester) async {
      final categoryInsight = OrbitInsight(
        id: 'cat_1',
        type: InsightType.biggestOpportunity,
        priority: InsightPriority.medium,
        title: 'Primary Opportunity: Focus Flow',
        description: 'Focusing on Focus Flow offers your highest potential score gain today.',
        category: 'Focus Flow',
        currentValue: 30.0,
        date: testDate,
      );

      await tester.pumpWidget(createWidgetUnderTest(
        const CategoryInsightsSection(),
        overrides: [
          categoryInsightsProvider.overrideWith((ref) async => [categoryInsight]),
        ],
      ));

      await tester.pumpAndSettle();

      expect(find.text('Category Insights'), findsOneWidget);
      expect(find.text('Primary Opportunity: Focus Flow'), findsOneWidget);
    });
  });
}
