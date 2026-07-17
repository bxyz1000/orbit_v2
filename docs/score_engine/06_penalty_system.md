# 06 Penalty System

## Purpose
Penalties are used sparingly to discourage procrastination and neglect without causing psychological burnout. Orbit focuses on "positive pressure."

## Penalty Types

### 1. Overdue Task
- **Logic**: Any task with a due date <= Today's Date that is not completed.
- **Penalty**: -2 points per task.
- **Occurrence**: Applied every day the task remains overdue at the time of finalization.
- **Cap**: Maximum -20 points per day to prevent a single bad week from destroying a score.

### 2. Missed Step Goal
- **Logic**: User sets a step goal; system detects steps < goal at finalization.
- **Penalty**: -10 points.
- **Note**: Only applies if the user has enabled "Health Stakes" in settings.

### 3. Deleting Completed History
- **Logic**: User deletes a completed task or habit entry from a previous day.
- **Penalty**: Recalculation of that day's score (results in score reduction).
- **Note**: This is not a "penalty" per se, but an adjustment for accuracy.

## Anti-Penalty Rules (Mercy Logic)
1. **No Negative Total**: A Daily Score can never drop below zero.
2. **The "Life Happens" Rule**: No penalties are applied for health metrics if the user has toggled "Recovery Mode" (e.g., due to illness or injury).
3. **No Streak Penalty**: Breaking a streak does not reduce the user's score; it only resets the multiplier for future days.

## Metadata
- **Version**: 1.0
- **Last Updated**: 2026-07-17
- **Dependencies**: [03 Scoring Algorithm](./03_scoring_algorithm.md)
