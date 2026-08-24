import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbit_v2/shared/widgets/orbit_hero_score.dart';
import 'package:orbit_v2/shared/widgets/orbit_metric_card.dart';
import 'package:orbit_v2/shared/widgets/orbit_feature_card.dart';
import 'package:orbit_v2/shared/widgets/orbit_bottom_nav.dart';
import 'package:orbit_v2/shared/widgets/orbit_period_selector.dart';
import 'package:orbit_v2/shared/widgets/orbit_activity_grid.dart';
import 'package:orbit_v2/features/health/presentation/orbit_steps_page.dart';
import 'package:orbit_v2/features/health/presentation/providers/health_providers.dart';
import 'package:orbit_v2/features/health/presentation/providers/steps_page_providers.dart';
import 'package:orbit_v2/features/health/domain/entities/health_snapshot.dart';
import 'package:orbit_v2/features/home/presentation/orbit_feature_hub_page.dart';
import 'package:orbit_v2/features/integrations/strava/presentation/providers/strava_providers.dart';
import 'package:orbit_v2/features/integrations/strava/domain/entities/strava_auth_state.dart';
import 'package:orbit_v2/shared/providers/data_providers.dart';
import 'package:orbit_v2/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:orbit_v2/features/dashboard/domain/entities/dashboard_state.dart';

void main() {
  group('Orbit Premium UI Widgets & Integration Tests', () {
    testWidgets('OrbitHeroScore renders score and motivation text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OrbitHeroScore(
              score: 78,
              progress: 0.78,
              baselineText: '↑ 6.4% vs 7-day baseline',
              motivationTitle: "You're ahead of yesterday",
              motivationSubtitle: "Keep building momentum.",
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('ORBIT SCORE'), findsOneWidget);
      expect(find.text('78'), findsOneWidget);
      expect(find.text('↑ 6.4% vs 7-day baseline'), findsOneWidget);
      expect(find.text("You're ahead of yesterday"), findsOneWidget);
    });

    testWidgets('OrbitMetricCard renders title, value and percentage', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OrbitMetricCard(
              title: 'Tasks',
              value: '7 / 9',
              icon: Icons.check_circle_outline_rounded,
              percentage: 78.0,
            ),
          ),
        ),
      );

      expect(find.text('Tasks'), findsOneWidget);
      expect(find.text('7 / 9'), findsOneWidget);
      expect(find.text('78%'), findsOneWidget);
    });

    testWidgets('OrbitFeatureCard renders title, metric and icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrbitFeatureCard(
              title: 'Focus',
              metric: '1h 24m',
              subtitle: 'Deep Work',
              icon: Icons.center_focus_strong_rounded,
            ),
          ),
        ),
      );

      expect(find.text('Focus'), findsOneWidget);
      expect(find.text('1h 24m'), findsOneWidget);
      expect(find.text('Deep Work'), findsOneWidget);
    });

    testWidgets('OrbitBottomNav renders 3 destinations and responds to tap', (tester) async {
      int tappedIndex = -1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrbitBottomNav(
              currentIndex: 0,
              isDarkSurface: false,
              onTap: (index) => tappedIndex = index,
            ),
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome_rounded), findsOneWidget);
      expect(find.byIcon(Icons.person_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.person_rounded));
      expect(tappedIndex, equals(2));
    });

    testWidgets('OrbitPeriodSelector changes active tab', (tester) async {
      int selected = 0;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: OrbitPeriodSelector(
                  selectedIndex: selected,
                  onChanged: (i) => setState(() => selected = i),
                ),
              ),
            );
          },
        ),
      );

      expect(find.text('Day'), findsOneWidget);
      expect(find.text('Week'), findsOneWidget);
      expect(find.text('Month'), findsOneWidget);

      await tester.tap(find.text('Week'));
      await tester.pumpAndSettle();
      expect(selected, equals(1));
    });

    testWidgets('OrbitActivityGrid renders without errors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrbitActivityGrid(
              hourlyIntensity: List.generate(24, (i) => i / 24.0),
              maxSteps: 12000,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('12 AM'), findsNWidgets(2));
      expect(find.text('12 PM'), findsOneWidget);
    });

    testWidgets('OrbitStepsPage renders explicit disconnected banner when Health is unauthorized', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            healthAuthorizationProvider.overrideWith((ref) async => false),
            todayHealthSnapshotProvider.overrideWith((ref) async => HealthSnapshot.empty()),
            stepsComparisonProvider.overrideWith((ref) async => 0.0),
            weeklyStepsProvider.overrideWith((ref) async => []),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: OrbitStepsPage(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Health Connect Not Connected'), findsOneWidget);
      expect(find.text('Step Data Unavailable'), findsOneWidget);
    });

    testWidgets('OrbitFeatureHubPage renders Strava Not Connected when Strava is unauthenticated', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dashboardProvider.overrideWith((ref) async => DashboardState.empty()),
            stravaAuthStateStreamProvider.overrideWith((ref) => Stream.value(const StravaAuthState(status: StravaConnectionStatus.notConnected))),
            stravaActivitiesProvider.overrideWith((ref) async => []),
            pendingTasksProvider.overrideWith((ref) async => []),
            todayEventsProvider.overrideWith((ref) async => []),
            allHabitsProvider.overrideWith((ref) async => []),
            completedHabitsTodayCountProvider.overrideWith((ref) async => 0),
            allNotesCountProvider.overrideWith((ref) async => 0),
            healthAuthorizationProvider.overrideWith((ref) async => false),
            todayHealthSnapshotProvider.overrideWith((ref) async => HealthSnapshot.empty()),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: OrbitFeatureHubPage(onNavigateToSteps: () {}),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Photo-card anatomy: title/subtitle header + footer tag pill.
      expect(find.text('Strava Run'), findsOneWidget);
      expect(find.text('Tap to connect Strava'), findsOneWidget);
      expect(find.textContaining('Sync'), findsOneWidget);
      // Health card metric remains plain text when unauthorized.
      expect(find.text('Not Connected'), findsOneWidget);
    });
  });
}
