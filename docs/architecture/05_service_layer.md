# 05 Service Layer

## Purpose
The Service Layer acts as the bridge between raw data (Repositories) and the UI. It contains the core logic that isn't specific to a single model.

## Key Services

### `ScoreService`
- **Function**: Listen to all entity changes and calculate the `TotalScore`.
- **Method**: `calculateActiveScore(DateTime date)`
- **Logic**: Implements [03 Scoring Algorithm](../score_engine/03_scoring_algorithm.md).

### `AnalyticsService`
- **Function**: Generate weekly and monthly trends.
- **Method**: `getWeeklyPerformance()`
- **Output**: `ProductivityStats` domain model.

### `StreakService`
- **Function**: Validates and updates streaks at finalization.
- **Logic**: Implements [07 Streak Engine](../score_engine/07_streak_engine.md).

### `BackupService`
- **Function**: Handles export/import of Isar data to JSON/SQLite for user portability.

## Rules
- Services should be stateless whenever possible, relying on Repositories for data.
- They should return `Future` or `Stream` to avoid blocking the Main Thread.

## Metadata
- **Version**: 1.0
- **Last Updated**: 2026-07-17
- **Dependencies**: All Repositories
