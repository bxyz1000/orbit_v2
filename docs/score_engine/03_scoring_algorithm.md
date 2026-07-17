# 03 Scoring Algorithm

## Purpose
Detailed mathematical breakdown of how the Orbit Score is calculated.

## Scope
Applicable to the `ScoreService` implementation in the Flutter codebase.

## The Algorithm (v1.1)

```math
TotalScore = (TaskScore + HabitScore + FocusScore + HealthScore + PlannerScore + GoalScore) * ConsistencyMultiplier
```

### 1. Task Score
- **Points**: +10 per completed task.
- **Penalty**: -2 per overdue task (calculated at finalization).
- **Rule**: Unlimited.

### 2. Habit Score
- **Points**: +15 per habit completion.
- **Rule**: Only scores if habit configuration allows completion for the current interval.

### 3. Focus Score
- **Points**: `(Minutes / 25) * 20`.
- **Cap**: Bonus points for going beyond the user-defined `MaxDailyFocus`, but with diminishing returns (0.5x multiplier after cap).

### 4. Health Score
- **Steps**: 
  - Goal reached: +50 points.
  - Over-achievement: +2 points per 1,000 steps above goal (capped at +20 bonus).
- **Workout**: 
  - `Duration (mins) * 1.5`. 
  - Minimum 10 mins required to score.
- **Sleep**: 
  - Healthy range (User Goal ± 1hr): +40 points.
  - Outside range: 0 points (No negative penalty).

### 5. Planner Score
- **Points**: +10 per completed planned event.
- **Rule**: Creating an event gives 0 points. Only the execution is rewarded.

### 6. Goal Score
- **Points**: +100 per Daily Goal completed.
- **Rule**: No partial credit for long-term goals until milestone completion.

### 7. Consistency Multiplier
Calculated based on the Current Streak:
- 1-6 Days: 1.0x
- 7-29 Days: 1.1x
- 30-99 Days: 1.2x
- 100+ Days: 1.5x

## Examples
- **User A**: Completes 5 tasks, 2 habits, 50 mins focus, 10k steps (goal met), 8hrs sleep.
  - `(50) + (30) + (40) + (50) + (40) = 210`.
  - **Multiplier**: 1.1x (7-day streak).
  - **Total**: 231.

## Metadata
- **Version**: 1.1
- **Last Updated**: 2026-07-17
- **Dependencies**: [04 Metrics Reference](./04_metrics_reference.md)
