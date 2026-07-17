# 02 Score Engine v1.1

## Purpose
The Score Engine is the primary processing unit that translates user activities into numerical values. Version 1.1 introduces weighting, historical recalculation protocols, and refined daily finalization.

## Scope
Defines the lifecycle of a score from activity detection to permanent database storage.

## Rules
1. **Daily Finalization**: Every day is finalized at **11:59:59 PM local time**. Late-night activities (e.g., sleep ending after midnight) are attributed to the logical day they belong to based on specific metric rules.
2. **Permanent Storage**: Once a day is finalized, its score is stored in the `DailyScore` collection.
3. **Weighting**: Scores are not a simple sum. They are weighted by category priority (Focus > Consistency > Health > Tasks).
4. **Historical Recalculation**: If the Scoring Algorithm (v1.1) changes, the system must offer the user a "System Update" prompt to recalculate previous months/years to maintain valid Personal Record comparisons.
5. **Score Removal**: Deleting a completed task or habit completion after finalization will trigger a recalculation of that specific day's score.

## Definitions
- **Active Score**: The real-time score of the current day.
- **Finalized Score**: A locked historical score.
- **Recalculation Buffer**: A 7-day window where minor changes are processed without deep system prompts.

## Implementation Details
- **Trigger**: Scores update on every state change in the relevant repositories (Tasks, Habits, Focus, etc.).
- **Debouncing**: Score calculation is debounced by 500ms to prevent UI flicker during rapid updates.

## Edge Cases
- **Timezone Travel**: If a user changes timezones, the "Daily Finalization" follows the device's local clock. Overlapping hours are handled by the `startedAt` timestamp of the events.
- **Manual Overrides**: If a user manually edits a record from 3 days ago, the Score Engine re-runs the v1.1 algorithm for that day.

## Future Considerations
v1.2 will explore "Adaptive Weighting," where the AI Coach adjusts the importance of certain pillars based on user goals (e.g., a "Health Month" increases the weight of Workout/Steps).

## Metadata
- **Version**: 1.1
- **Last Updated**: 2026-07-17
- **Dependencies**: [03 Scoring Algorithm](./03_scoring_algorithm.md)
