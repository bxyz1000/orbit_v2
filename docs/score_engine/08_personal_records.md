# 08 Personal Records (PR)

## Purpose
Personal Records are the primary "competitive" element of Orbit. They provide benchmarks for the user to surpass.

## Categories of PRs

### 1. Highest Score
- **Daily**: Best single day.
- **Weekly**: Best rolling 7-day sum.
- **Monthly**: Best calendar month total.

### 2. Consistency
- **Longest Streak**: Most consecutive active days (including grace period logic).
- **Most Tasks in a Day**: Peak task volume.

### 3. Focus
- **Longest Session**: Single longest focus timer run.
- **Most Focus in a Day**: Total daily minutes peak.

### 4. Health
- **Step Peak**: Highest step count in 24h.
- **Workout Duration**: Single longest workout.

## Logic
- When a PR is broken, the user receives an immediate **Celebration Notification**.
- PRs are stored in a `UserStats` singleton collection.
- PRs are recalculated if historical data is modified/deleted.

## Metadata
- **Version**: 1.0
- **Last Updated**: 2026-07-17
- **Dependencies**: [02 Score Engine v1.1](./02_score_engine_v1.1.md)
