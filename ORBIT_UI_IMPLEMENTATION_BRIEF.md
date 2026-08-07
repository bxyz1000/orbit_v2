# ORBIT UI IMPLEMENTATION BRIEF
**Architecture & Implementation Specification for Premium UI/UX Redesign**

---

## 1. Executive Summary

Orbit is a Flutter-based personal operating system built around the guiding philosophy: **"Become better than yesterday."**

The backend architecture—including score mathematics (`ScoreEngineV2`), insight generation (`InsightServiceImpl`), health pipelines (`HealthServiceImpl`, `HealthRepository`), Strava integration (`StravaRepositoryImpl`), and local persistence (`IsarDatabase`)—is fully built, tested, and verified.

This document serves as the authoritative blueprint for a major premium UI/UX redesign. The target visual aesthetic is a **Dribbble-grade, editorial, sophisticated, calm, and high-end personal operating system**. Inspired by premium wearable and health applications, the design prioritizes:
- Large expressive typography and clear hierarchy
- Generous whitespace and organic rounded geometry
- A subtle warm copper accent palette (`#CC7A4A`, `#D4885C`, `#E8A878`, `#FFF5EE`)
- Soft ambient glow gradients and subtle depth
- Asymmetric feature compositions
- Tactile, restrained micro-interactions

**Crucial Constraint**: This redesign is strictly frontend presentation-layer. All existing backend engines, Isar database schemas, Riverpod data providers, score calculations, and insight generation logic **MUST NOT BE MODIFIED**.

---

## 2. Current UI Architecture

The Orbit frontend architecture follows a feature-first modular structure with Riverpod state management.

```
lib/
├── app/
│   ├── main.dart
│   ├── orbit_app.dart
│   └── app_shell.dart
├── core/
│   ├── database/
│   │   └── isar_database.dart
│   └── theme/
│       ├── orbit_colors.dart
│       ├── orbit_gradients.dart
│       ├── orbit_radius.dart
│       ├── orbit_shadows.dart
│       ├── orbit_spacing.dart
│       ├── orbit_theme.dart
│       └── orbit_typography.dart
├── features/
│   ├── ai/presentation/orbit_ai_page.dart
│   ├── analytics/presentation/insights_page.dart
│   ├── dashboard/presentation/providers/dashboard_provider.dart
│   ├── focus/presentation/focus_page.dart
│   ├── goals/presentation/
│   ├── habits/presentation/habits_page.dart
│   ├── health/presentation/
│   │   ├── orbit_steps_page.dart
│   │   └── providers/
│   │       ├── health_providers.dart
│   │       └── steps_page_providers.dart
│   ├── home/presentation/
│   │   ├── orbit_home_page.dart
│   │   ├── orbit_score_page.dart
│   │   ├── orbit_feature_hub_page.dart
│   │   └── widgets/
│   ├── insights/presentation/
│   ├── integrations/
│   │   └── strava/presentation/providers/strava_providers.dart
│   ├── notes/presentation/notes_page.dart
│   ├── planner/presentation/planner_page.dart
│   ├── profile/presentation/profile_page.dart
│   ├── score/presentation/providers/score_providers.dart
│   ├── settings/presentation/
│   │   ├── settings_page.dart
│   │   └── providers/preferences_providers.dart
│   └── tasks/presentation/tasks_page.dart
└── shared/
    ├── providers/
    │   ├── data_providers.dart
    │   └── repository_providers.dart
    └── widgets/
        ├── orbit_action_card.dart
        ├── orbit_activity_grid.dart
        ├── orbit_bottom_nav.dart
        ├── orbit_dialogs.dart
        ├── orbit_feature_card.dart
        ├── orbit_group_card.dart
        ├── orbit_hero_score.dart
        ├── orbit_info_tile.dart
        ├── orbit_insight_card_v2.dart
        ├── orbit_metric_card.dart
        ├── orbit_page_indicator.dart
        ├── orbit_period_selector.dart
        ├── orbit_search_bar.dart
        ├── orbit_section_header.dart
        ├── orbit_stat_card.dart
        └── orbit_weekly_steps_chart.dart
```

---

## 3. Navigation Architecture

### Current Implementation
- Root widget: `OrbitApp` (`file:///a:/orbit_v2/lib/app/orbit_app.dart`)
- Application Shell: `AppShell` (`file:///a:/orbit_v2/lib/app/app_shell.dart`)
- Primary Navigation: A horizontal `PageView` (3 pages):
  - **LEFT (Index 0)**: `OrbitFeatureHubPage` ("Your Orbit" / Feature Hub)
  - **CENTER (Index 1)**: `OrbitScorePage` (Orbit Score - Default Landing)
  - **RIGHT (Index 2)**: `OrbitStepsPage` (Steps & Activity Analytics)
- Bottom Navigation Bar: Floating pill `OrbitBottomNav` (`file:///a:/orbit_v2/lib/shared/widgets/orbit_bottom_nav.dart`) with exactly 3 destinations:
  - **HOME (Index 0)**: Animates `PageView` back to Center (`OrbitScorePage`)
  - **AI ASSISTANT (Index 1)**: Opens `OrbitAiPage` via `Navigator.push`
  - **PROFILE (Index 2)**: Opens `ProfilePage` via `Navigator.push`

### Architectural Recommendation
- **PRESERVE** the 3-page horizontal `PageView` structure + 3-pill floating bottom navigation shell.
- **MODIFY**: Optimize transition curve (`Curves.easeOutCubic`), page indicator alignment, and ensure bottom safe-area padding prevents clipping on edge-to-edge mobile screens.

---

## 4. Center Score Page Audit (`OrbitScorePage`)

### File Path
[orbit_score_page.dart](file:///a:/orbit_v2/lib/features/home/presentation/orbit_score_page.dart)

### Current Implementation
- Displays header greeting ("Good morning, Bhavik") with user avatar.
- Renders `OrbitHeroScore` (arc gauge with score count-up).
- Renders a 2x2 category metric grid (`OrbitMetricCard` for Tasks, Focus, Habits, Health).
- Renders "Today's Insight" section at the bottom.

### Issues Identified
- The 2x2 category metric grid (`Tasks`, `Focus`, `Habits`, `Health`) competes visually with the Hero Orbit Score.
- The reference visual language dictates that the center page must make **Orbit Score the visual hero** without competing 2x2 category boxes.

### Recommended Change
1. **REMOVE** `_buildCategoryGrid` from the Center page.
2. **RESTRUCTURE** hierarchy to follow exact reference layout:
   ```
   Greeting ("Good morning, Bhavik")
   ↓
   ORBIT SCORE label
   ↓
   Large 96pt score number ("78")
   ↓
   Premium semicircular copper score arc meter with tick marks & glow dot
   ↓
   Baseline comparison badge ("↑ 6.4% vs your 7-day baseline")
   ↓
   Minimal motivation/insight container ("+ You're ahead of yesterday. Keep building momentum.")
   ```
3. Move category metrics to the Feature Hub (Your Orbit) page or context modal.

### Reason
Allows the center page to achieve the serene, editorial hero score focus demonstrated in the target wearable reference without visual clutter.

---

## 5. Steps Page Audit (`OrbitStepsPage`)

### File Path
[orbit_steps_page.dart](file:///a:/orbit_v2/lib/features/health/presentation/orbit_steps_page.dart)

### Current Implementation
- Day / Week / Month tab selector (`OrbitPeriodSelector`).
- Disconnected banner when Health Connect is unauthorized.
- Day View: Animated step count (`TweenAnimationBuilder`), comparison badge ("↑ 14.2% vs last week"), `OrbitActivityGrid` (24-hour intensity bars), Distance & Active Time pills (`_StatPill`), and Daily Goal progress bar.
- Week View: `OrbitWeeklyStepsChart` (horizontal bar chart with average & personal best stars).
- Month View: Unavailable placeholder container.
- Orbit Insights list at the bottom.

### Recommended Changes
1. **DAY VIEW**:
   - Upgrade typography of step count to `fontSize: 56`, `fontWeight: FontWeight.w800`.
   - Redesign `OrbitActivityGrid` into a stacked square intensity block grid (resembling the reference heat-map grid: 24 columns x 8 rows of rounded orange/copper squares).
   - Display compact Stat Pills for `Distance` and `Active Time` side-by-side with icon containers.
   - Refine Daily Goal progress bar with a slim orange bar (`height: 6`) and rounded capsule background.
2. **WEEK VIEW**:
   - Refine `OrbitWeeklyStepsChart` horizontal bars with warm pastel orange fill for non-today bars and vibrant copper gradient for today's bar.
   - Retain star indicator `★` for personal best days.
3. **DISCONNECTED / UNAVAILABLE STATE**:
   - Ensure clean, non-intrusive disconnected state when `healthAuthorizationProvider` returns `false` or step data is empty.

### Data Mapping
- Step count: `todayHealthSnapshotProvider` (`snapshot.steps`)
- Distance: `todayHealthSnapshotProvider` (`snapshot.distance`)
- Active minutes: `todayHealthSnapshotProvider` (`snapshot.activeMinutes`)
- Weekly history: `weeklyStepsProvider` (`List<DailyStepEntry>`)
- Comparison: `stepsComparisonProvider` (`double` % change)
- Health Auth: `healthAuthorizationProvider` (`bool`)

---

## 6. Feature Hub Audit (`OrbitFeatureHubPage` - "Your Orbit")

### File Path
[orbit_feature_hub_page.dart](file:///a:/orbit_v2/lib/features/home/presentation/orbit_feature_hub_page.dart)

### Current Implementation
- Simple vertical list of card rows (Strava wide card, Notes & Timer, Planner & Focus, Habits & Tasks, Goals & Analytics, Health wide card).

### Issues Identified
- Looked like a rigid, symmetrical grid rather than an organic, editorial personal OS feature hub.

### Recommended Change
Redesign into a **Premium Asymmetric Feature Composition**:
- **Hero Feature Tile (Top Left)**: Strava Activity / Run Card with dark ambient image/gradient overlay (`8.42 km Today's Run`).
- **Notes Tile (Top Right)**: Tall card showing note count (`12 Notes`) with orange badge indicator (`3`).
- **Timer Tile**: Compact Pomodoro timer preview (`25:00 Pomodoro`) with radial clock graphic.
- **Planner Tile**: Mini calendar preview widget (`4 Events Today`).
- **Habits Tile**: Circular completion progress ring (`4 / 6 Completed`).
- **Focus Tile**: Waveform focus chart preview (`1h 24m Deep Work`).
- **Goals Tile**: Mountain/Flag aesthetic card (`3 Active Goals`).
- **Analytics Tile**: Sparkline chart card (`78 Avg. Score`).
- **Health Tile**: Wide bottom tile for steps (`7,231 Steps Today`).

### Provider Mapping
| Feature | Provider | Primary Metric | Navigation Route | Disconnected State |
| :--- | :--- | :--- | :--- | :--- |
| **Strava** | `stravaAuthStateStreamProvider`, `stravaActivitiesProvider` | Latest workout distance (`km`) | Connect workflow / `StravaAuthNotifier` | "Not Connected - Tap to connect" |
| **Notes** | `allNotesCountProvider` | Saved note count | `NotesPage` | "0 Notes" |
| **Timer / Focus** | `dashboardProvider`, `todaySessionsProvider` | Focus minutes completed today | `FocusPage` | "0m Completed" |
| **Planner** | `todayEventsProvider` | Events count today | `PlannerPage` | "0 Events Today" |
| **Habits** | `allHabitsProvider`, `completedHabitsTodayCountProvider` | Completed / Total habits | `HabitsPage` | "0 / 0 Completed" |
| **Tasks** | `pendingTasksProvider` | Pending task count | `TasksPage` | "0 Pending" |
| **Goals** | `dashboardProvider` | Active / Completed goals | `InsightsPage` / Goals | "0 Active Goals" |
| **Analytics** | `dashboardProvider` | Current score / average | `InsightsPage` | "Score --" |
| **Health** | `healthAuthorizationProvider`, `todayHealthSnapshotProvider` | Step count today | `OrbitStepsPage` | "Not Connected - Tap to connect" |

---

## 7. Profile / Settings Audit (`ProfilePage`)

### File Path
[profile_page.dart](file:///a:/orbit_v2/lib/features/profile/presentation/profile_page.dart)

### Current Implementation
- Unified destination for Profile & Settings.
- Header: User avatar with edit badge, username (`prefs.userName`), tagline (`prefs.userTagline`).
- Stats Row: `Orbit Score` card & `Day Streak` card (`🔥`).
- Personal Records section (`personalRecordsProvider`).
- Appearance section (Theme selection: System, Light, Dark).
- Integrations section (Health Connect toggle, Strava Connect/Disconnect button).
- Preferences section (Notifications, AI Assistant, Planner Sync).
- About section (Philosophy: "Become better than yesterday", Version: "7.1 Certified").

### Provider Mapping
- User Preferences: `userPreferencesProvider` / `userPreferencesStreamProvider`
- Theme Mode: `appThemeModeProvider` / `preferencesNotifierProvider`
- Score: `currentDailyScoreProvider`
- Streak: `currentStreakProvider`
- Personal Records: `personalRecordsProvider`
- Health Auth: `healthAuthorizationProvider`
- Strava Auth: `stravaAuthStateStreamProvider`

### Recommended Changes
- Retain single unified Profile + Settings experience.
- Refine styling using `OrbitGroupCard` with subtle borders (`Border.all(color: Colors.white10)`), pill switches, and warm copper accents.
- Remove redundant standalone `SettingsPage` (`file:///a:/orbit_v2/lib/features/settings/presentation/settings_page.dart`) or route it directly to `ProfilePage`.

---

## 8. AI Page Audit (`OrbitAiPage`)

### File Path
[orbit_ai_page.dart](file:///a:/orbit_v2/lib/features/ai/presentation/orbit_ai_page.dart)

### Current Implementation
- Chat interface with suggestions chips (`"What's my score today?"`, etc.).
- Input field with send button.
- Disabled state when `prefs.aiAssistantEnabled` is `false`.

### Recommended Changes
- Apply dark warm copper ambient theme to chat bubbles.
- User bubbles: Warm copper background (`#CC7A4A`).
- AI bubbles: Soft warm surface background with subtle glassmorphic outline.
- Input bar: Floating capsule with micro-animation on focus.

---

## 9. Bottom Navigation Audit (`OrbitBottomNav`)

### File Path
[orbit_bottom_nav.dart](file:///a:/orbit_v2/lib/shared/widgets/orbit_bottom_nav.dart)

### Current Implementation
- Floating pill widget (`height: 60`, `maxWidth: 320`) with 3 destinations (`Home`, `AI`, `Profile`).
- `AnimatedContainer` pill highlight when selected.

### Recommended Changes
- Retain exact 3 destinations: **HOME**, **AI ASSISTANT**, **PROFILE**.
- Upgrade styling to match reference image 3:
  - Clean cream/white floating pill container with rounded radius `30`.
  - Subtle drop shadow (`OrbitShadows.navBar`).
  - Active tab text expansion animation.
  - Proper `SafeArea` handling to avoid bottom edge overlaps on iOS home indicator / Android gesture bar.

---

## 10. Design System Audit

### Colors (`OrbitColors`)
[orbit_colors.dart](file:///a:/orbit_v2/lib/core/theme/orbit_colors.dart)
- **Retain**: Warm Copper Palette (`copper50` to `copper900`, primary `copper500` `#CC7A4A`).
- **Retain**: Warm Neutrals (`warmWhite` `#FFFFFAF5`, `cream` `#F8F2EB`, `warmGray50` to `warmGray900`).
- **Modify**: Ensure dark mode surface colors (`darkBackground` `#121010`, `darkSurface` `#1C1816`, `darkElevated` `#262220`) strictly conform to the dark warm aesthetic.

### Gradients (`OrbitGradients`)
[orbit_gradients.dart](file:///a:/orbit_v2/lib/core/theme/orbit_gradients.dart)
- **Retain**: `heroGradient`, `scoreGlow`, `warmSurface`, `glass`, `strava`.
- **Add**: `copperAura` (soft radial background gradient for score hero page), `featureCardGlow`.

### Shadows (`OrbitShadows`)
[orbit_shadows.dart](file:///a:/orbit_v2/lib/core/theme/orbit_shadows.dart)
- **Retain**: `card`, `elevated`, `navBar`, `scoreGlow`, `glass`.

### Typography (`OrbitTypography`)
[orbit_typography.dart](file:///a:/orbit_v2/lib/core/theme/orbit_typography.dart)
- Uses `GoogleFonts.inter`.
- **Retain**: `scoreHero` (96pt), `metricLarge` (48pt), `metricMedium` (28pt), `metricSmall` (20pt), `sectionLabel` (11pt uppercase, letterSpacing: 1.5).

### Spacing & Radius (`OrbitSpacing`, `OrbitRadius`)
- Radii: `xs: 4`, `sm: 8`, `md: 12`, `lg: 16`, `xl: 24`, `circular: 999`.

---

## 11. Provider & Data Mapping Table

| UI Component | Data Source Provider | Stream/Future Type | Domain Entity |
| :--- | :--- | :--- | :--- |
| **Orbit Score Hero** | `dashboardProvider` / `currentDailyScoreProvider` | `FutureProvider` | `DailyScore` |
| **7-Day Baseline** | `lastSevenDaysScoresProvider` | `FutureProvider` | `List<DailyScore>` |
| **Today's Insight** | `dailyInsightsProvider` | `FutureProvider` | `List<OrbitInsight>` |
| **Step Count & Activity** | `todayHealthSnapshotProvider` | `FutureProvider` | `HealthSnapshot` |
| **Weekly Step History** | `weeklyStepsProvider` | `FutureProvider` | `List<DailyStepEntry>` |
| **Step Comparison** | `stepsComparisonProvider` | `FutureProvider` | `double` |
| **Health Auth Status** | `healthAuthorizationProvider` | `FutureProvider` | `bool` |
| **Strava Auth State** | `stravaAuthStateStreamProvider` | `StreamProvider` | `StravaAuthState` |
| **Strava Activities** | `stravaActivitiesProvider` | `FutureProvider` | `List<StravaActivity>` |
| **User Profile & Prefs** | `userPreferencesProvider` / `userPreferencesStreamProvider` | `FutureProvider` / `StreamProvider` | `UserPreferences` |
| **Streak** | `currentStreakProvider` | `FutureProvider` | `int` |
| **Personal Records** | `personalRecordsProvider` | `FutureProvider` | `List<PersonalRecord>` |
| **Pending Tasks** | `pendingTasksProvider` | `FutureProvider` | `List<Task>` |
| **Today Events** | `todayEventsProvider` | `FutureProvider` | `List<PlannerEvent>` |
| **Habits & Completions**| `allHabitsProvider`, `completedHabitsTodayCountProvider` | `FutureProvider` | `List<Habit>`, `int` |
| **Notes Count** | `allNotesCountProvider` | `FutureProvider` | `int` |

---

## 12. Reusable Components to Preserve

1. `OrbitHeroScore` ([orbit_hero_score.dart](file:///a:/orbit_v2/lib/shared/widgets/orbit_hero_score.dart)) - Semicircular score arc gauge with count-up animation and glow dot.
2. `OrbitBottomNav` ([orbit_bottom_nav.dart](file:///a:/orbit_v2/lib/shared/widgets/orbit_bottom_nav.dart)) - Floating 3-pill bottom navigation bar.
3. `OrbitPageIndicator` ([orbit_page_indicator.dart](file:///a:/orbit_v2/lib/shared/widgets/orbit_page_indicator.dart)) - Smooth dots page indicator.
4. `OrbitInsightCardV2` ([orbit_insight_card_v2.dart](file:///a:/orbit_v2/lib/shared/widgets/orbit_insight_card_v2.dart)) - Redesigned insight card with priority color coding and trend indicators.
5. `OrbitPeriodSelector` ([orbit_period_selector.dart](file:///a:/orbit_v2/lib/shared/widgets/orbit_period_selector.dart)) - Day / Week / Month tab selector capsule.
6. `OrbitWeeklyStepsChart` ([orbit_weekly_steps_chart.dart](file:///a:/orbit_v2/lib/shared/widgets/orbit_weekly_steps_chart.dart)) - Horizontal weekly steps bar chart with personal best star indicators.
7. `OrbitGroupCard` & `OrbitInfoTile` ([orbit_group_card.dart](file:///a:/orbit_v2/lib/shared/widgets/orbit_group_card.dart), [orbit_info_tile.dart](file:///a:/orbit_v2/lib/shared/widgets/orbit_info_tile.dart)) - Grouped setting container and tile components.

---

## 13. Components to Redesign

1. `OrbitScorePage` ([orbit_score_page.dart](file:///a:/orbit_v2/lib/features/home/presentation/orbit_score_page.dart))
   - Remove 2x2 category metric grid. Elevate hero score gauge and baseline comparison.
2. `OrbitFeatureHubPage` ([orbit_feature_hub_page.dart](file:///a:/orbit_v2/lib/features/home/presentation/orbit_feature_hub_page.dart))
   - Replace linear 2-column list with an asymmetric feature layout.
3. `OrbitActivityGrid` ([orbit_activity_grid.dart](file:///a:/orbit_v2/lib/shared/widgets/orbit_activity_grid.dart))
   - Upgrade from simple vertical bar columns to a stacked square block intensity grid matching the wearable reference.
4. `OrbitMetricCard` ([orbit_metric_card.dart](file:///a:/orbit_v2/lib/shared/widgets/orbit_metric_card.dart))
   - Update typography hierarchy, border treatment, and warm copper progress indicators.
5. `OrbitFeatureCard` ([orbit_feature_card.dart](file:///a:/orbit_v2/lib/shared/widgets/orbit_feature_card.dart))
   - Enhance micro-interaction scaling (`0.97`), gradient backgrounds, and badge layout.

---

## 14. Responsive Issues & Layout Strategies

### Audit Findings
- Hardcoded bottom paddings (`bottom: 120`) in `SingleChildScrollView` instances across `OrbitScorePage`, `OrbitStepsPage`, `OrbitFeatureHubPage` cause inconsistent scroll end clearance across devices with different screen heights.
- Fixed height containers (`SizedBox(height: 140)`) in `OrbitFeatureHubPage` can lead to text overflow on small screen devices (e.g. iPhone SE / small Android phones).
- Potential PageView horizontal swipe gesture conflicts with inner horizontal lists (e.g., suggestions list in `OrbitAiPage` or horizontal chart sliders).

### Responsive Layout Rules for Implementation
1. **Dynamic Safe Area Padding**: Replace fixed `120` bottom padding with:
   `EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 90)`
2. **Flexible Aspect Ratios**: Replace fixed-height feature card boxes (`height: 140`) with `AspectRatio` widgets or flexible `LayoutBuilder` constraints.
3. **Text Truncation Safety**: Ensure all metric titles, subtitles, and labels specify `maxLines: 1` and `overflow: TextOverflow.ellipsis`.

---

## 15. Animation Opportunities

1. **Score Meter Count-Up**:
   - `OrbitHeroScore`: 1400ms count-up with `Curves.easeOutCubic` and scale bounce (`0.92` to `1.0`).
2. **Step Counter Count-Up**:
   - `OrbitStepsPage`: 1200ms count-up for step numbers using `TweenAnimationBuilder<int>`.
3. **Card Press Feedback**:
   - `OrbitFeatureCard`: `AnimatedScale(scale: _isPressed ? 0.97 : 1.0)` with 120ms duration.
4. **PageView Page Transition**:
   - Smooth horizontal page drag physics using `BouncingScrollPhysics()` and 350ms `Curves.easeInOutCubic` for programmatic taps.
5. **Activity Grid Load**:
   - Staggered column animation (`delay: i / 24`).

---

## 16. Fake Data Findings Audit

Every file in the codebase was audited for hardcoded metrics, placeholder values, or fake data arrays.

| File Path | Location | Description / Code | Assessment & Action |
| :--- | :--- | :--- | :--- |
| `lib/features/ai/presentation/orbit_ai_page.dart` | Lines 20-26 | Hardcoded `_suggestions` array (`"What's my score today?"`, etc.) | **KEEP**: These are static UI prompt suggestions for user convenience. |
| `lib/features/ai/presentation/orbit_ai_page.dart` | Lines 50-54 | Mock AI response string ("Orbit AI is ready to connect...") | **RETAIN UNTIL AI BACKEND INTEGRATED**: Explicit fallback state. |
| `lib/features/health/presentation/orbit_steps_page.dart` | Line 358 | `const goal = 10000;` Hardcoded daily step goal target | **RETAIN AS DEFAULT**: Standard default daily step target. |
| `lib/features/health/presentation/orbit_steps_page.dart` | Lines 568-582 | `_calculateHourlyIntensity` proportional distribution fallback when hourly breakdown is missing | **RETAIN**: Algorithmic fallback based on real total steps & active minutes. |
| `lib/features/home/presentation/orbit_score_page.dart` | Line 230 | `state.healthSteps / 10000 * 100` Hardcoded 10,000 target for % | **RETAIN AS DEFAULT**: Standard default target for percentage calculation. |
| `lib/features/home/presentation/orbit_feature_hub_page.dart` | Line 204 | `focusMinutesTarget ?? 120` Fallback target | **RETAIN**: Default target fallback when state value is null. |
| `lib/features/settings/presentation/settings_page.dart` | Line 74 | `'Orbit MVP 0.1.0'` Version text | **REPLACE / UNIFY**: Align with ProfilePage version tag. |

---

## 17. Files Opus MUST NOT Modify

The following files constitute verified backend, domain, database, and repository pipelines. **THEY MUST NOT BE EDITED**:

```
lib/features/score/domain/services/score_engine_v2.dart
lib/features/score/domain/services/score_engine_v1_1.dart
lib/features/score/domain/services/score_service.dart
lib/features/score/domain/services/motivation_service.dart
lib/features/score/data/score_service_impl.dart
lib/features/score/data/motivation_service_impl.dart
lib/features/score/data/repositories/score_repository.dart
lib/features/score/data/repositories/achievement_repository.dart
lib/features/score/data/repositories/personal_record_repository.dart
lib/features/score/data/models/*.dart

lib/features/insights/domain/services/i_insight_service.dart
lib/features/insights/data/services/insight_service_impl.dart

lib/features/analytics/data/services/analytics_service_impl.dart

lib/features/health/domain/repositories/i_health_service.dart
lib/features/health/data/services/health_service_impl.dart
lib/features/health/data/health_repository.dart
lib/features/health/data/models/*.dart

lib/features/integrations/strava/domain/repositories/i_strava_repository.dart
lib/features/integrations/strava/domain/services/*.dart
lib/features/integrations/strava/data/repositories/strava_repository_impl.dart
lib/features/integrations/strava/data/services/strava_auth_service_impl.dart
lib/features/integrations/strava/data/datasources/*.dart
lib/features/integrations/strava/data/models/*.dart

lib/core/database/isar_database.dart

lib/shared/providers/repository_providers.dart
lib/shared/providers/data_providers.dart
```

---

## 18. Files Opus MAY Modify

The following UI presentation layer files **MAY BE EDITED** to achieve the redesign:

```
lib/app/orbit_app.dart
lib/app/app_shell.dart

lib/core/theme/orbit_colors.dart
lib/core/theme/orbit_gradients.dart
lib/core/theme/orbit_radius.dart
lib/core/theme/orbit_shadows.dart
lib/core/theme/orbit_spacing.dart
lib/core/theme/orbit_theme.dart
lib/core/theme/orbit_typography.dart

lib/features/home/presentation/orbit_home_page.dart
lib/features/home/presentation/orbit_score_page.dart
lib/features/home/presentation/orbit_feature_hub_page.dart

lib/features/health/presentation/orbit_steps_page.dart
lib/features/ai/presentation/orbit_ai_page.dart
lib/features/profile/presentation/profile_page.dart

lib/shared/widgets/orbit_action_card.dart
lib/shared/widgets/orbit_activity_grid.dart
lib/shared/widgets/orbit_bottom_nav.dart
lib/shared/widgets/orbit_dialogs.dart
lib/shared/widgets/orbit_feature_card.dart
lib/shared/widgets/orbit_group_card.dart
lib/shared/widgets/orbit_hero_score.dart
lib/shared/widgets/orbit_info_tile.dart
lib/shared/widgets/orbit_insight_card_v2.dart
lib/shared/widgets/orbit_metric_card.dart
lib/shared/widgets/orbit_page_indicator.dart
lib/shared/widgets/orbit_period_selector.dart
lib/shared/widgets/orbit_search_bar.dart
lib/shared/widgets/orbit_section_header.dart
lib/shared/widgets/orbit_stat_card.dart
lib/shared/widgets/orbit_weekly_steps_chart.dart

test/features/ui/orbit_ui_test.dart
```

---

## 19. Required UI Changes Summary

| Target Area | File Path | Current Implementation | Recommended Change | Reason |
| :--- | :--- | :--- | :--- | :--- |
| **Theme System** | [orbit_colors.dart](file:///a:/orbit_v2/lib/core/theme/orbit_colors.dart), [orbit_theme.dart](file:///a:/orbit_v2/lib/core/theme/orbit_theme.dart) | Standard Material 3 light/dark seed colors | Refine palette with copper tones (`#CC7A4A`), warm white surfaces, and dark background tokens | Establishes the editorial, warm copper visual foundation across all screens |
| **App Shell** | [app_shell.dart](file:///a:/orbit_v2/lib/app/app_shell.dart) | PageView shell with hardcoded bottom nav positioning | Add dynamic safe area inset handling, smooth scroll physics, and optimized page change callbacks | Ensures zero bottom navigation clipping on edge-to-edge screens |
| **Center Page** | [orbit_score_page.dart](file:///a:/orbit_v2/lib/features/home/presentation/orbit_score_page.dart) | Renders hero score alongside a 2x2 category metric grid | Remove 2x2 grid. Elevate hero score gauge, 7-day baseline pill, and minimal motivation container | Concentrates focus on the Orbit Score as the sole visual hero on the landing page |
| **Steps Page** | [orbit_steps_page.dart](file:///a:/orbit_v2/lib/features/health/presentation/orbit_steps_page.dart) | Simple step count text, basic bar grid, standard linear goal progress | Implement 56pt expressive step typography, stacked square intensity grid, and compact stat pills | Matches the target wearable health reference UI closely |
| **Feature Hub** | [orbit_feature_hub_page.dart](file:///a:/orbit_v2/lib/features/home/presentation/orbit_feature_hub_page.dart) | Symmetric vertical list of card rows | Implement asymmetric feature layout with specialized feature previews (Strava, Notes, Focus, Planner, Habits) | Creates a dynamic, state-of-the-art personal OS feature hub experience |
| **Bottom Nav** | [orbit_bottom_nav.dart](file:///a:/orbit_v2/lib/shared/widgets/orbit_bottom_nav.dart) | Floating container with 3 destination items | Refine border radii (30), background blur/fill, and smooth label expand animation | Delivers a floating pill bottom nav |
| **Profile Page** | [profile_page.dart](file:///a:/orbit_v2/lib/features/profile/presentation/profile_page.dart) | Basic list tiles and cards | Apply warm dark/light surface containers, copper switches, and clean record tiles | Maintains visual harmony with the rest of the application |

---

## 20. Test Coverage Audit

### Current Test Suite Status
- **13 test suites passed** (100% passing rate).
- Key UI Test file: `test/features/ui/orbit_ui_test.dart` covers:
  - `OrbitHeroScore` rendering and motivation text
  - `OrbitMetricCard` title, value, percentage
  - `OrbitFeatureCard` title, metric, icon
  - `OrbitBottomNav` 3 destinations and tap callbacks
  - `OrbitPeriodSelector` tab changes
  - `OrbitActivityGrid` rendering
  - `OrbitStepsPage` Health Connect disconnected banner
  - `OrbitFeatureHubPage` Strava disconnected card state

### Required Test Maintenance & Additions for Redesign
1. **Unchanged Tests**: Keep `score_engine_v2_test.dart`, `insight_service_test.dart`, `strava_*_test.dart`, and `analytics_service_test.dart` completely intact.
2. **Updated Tests**: Update `orbit_ui_test.dart` to verify `OrbitScorePage` renders without the 2x2 category grid, and verify the new asymmetric layout elements on `OrbitFeatureHubPage`.
3. **New Widget Tests**:
   - Test `OrbitActivityGrid` stacked square intensity block painter with non-zero step data.
   - Test `ProfilePage` theme mode toggle interactions.

---

## 21. Recommended Implementation Order

Opus coding agent should execute the redesign in the following sequential phases:

```
Phase 1: Design System & Theme Foundations
  ├── Refine orbit_colors.dart, orbit_gradients.dart, orbit_typography.dart
  └── Update orbit_theme.dart light & dark ThemeDatas

Phase 2: Component Refinements
  ├── Refine orbit_hero_score.dart (arc gauge painter & glow)
  ├── Redesign orbit_activity_grid.dart (stacked square block grid)
  ├── Refine orbit_feature_card.dart (micro-interactions & gradients)
  └── Refine orbit_bottom_nav.dart (floating capsule styling)

Phase 3: Center Score Page Redesign
  ├── Redesign orbit_score_page.dart
  └── Verify hero score layout & removal of 2x2 competing grid

Phase 4: Steps Page Redesign
  ├── Redesign orbit_steps_page.dart
  └── Verify Day / Week / Month views & disconnected Health states

Phase 5: Feature Hub Page Redesign ("Your Orbit")
  ├── Redesign orbit_feature_hub_page.dart
  └── Implement asymmetric feature composition with real providers

Phase 6: Profile & AI Page Polish
  ├── Refine profile_page.dart (unified profile & settings)
  └── Polish orbit_ai_page.dart chat styling

Phase 7: Verification & Test Suite Execution
  ├── Run `flutter test` across all test suites
  └── Verify responsive layout on small & large screen dimensions
```

---

## 22. Acceptance Criteria

To deem the UI/UX redesign complete, the implementation MUST meet the following criteria:

1. **Visual Quality**:
   - Clean, Dribbble-grade, editorial look matching the supplied visual reference images.
   - Warm copper accents (`#CC7A4A`), large expressive typography, generous whitespace, organic rounded geometry.
2. **Center Page Focus**:
   - Orbit Score is the sole visual hero on the Center page. No competing 2x2 metric grid present on `OrbitScorePage`.
3. **Steps Page Precision**:
   - Displays expressive step count, stacked square block activity grid, compact stat pills, weekly chart with personal best stars, and elegant Health Connect authorization states.
4. **Asymmetric Feature Hub**:
   - `OrbitFeatureHubPage` presents an asymmetric feature composition consuming real Riverpod providers without demo grids.
5. **Floating Bottom Navigation**:
   - Exactly 3 destinations (`HOME`, `AI ASSISTANT`, `PROFILE`), floating capsule design, no safe area clipping.
6. **Backend Protection & Data Integrity**:
   - Zero modifications to `ScoreEngineV2`, Isar schemas, Riverpod data providers, health repositories, or Strava sync pipelines.
   - No hardcoded fake data introduced.
7. **Test Suite Integrity**:
   - All tests run via `flutter test` pass cleanly with 100% success rate.
