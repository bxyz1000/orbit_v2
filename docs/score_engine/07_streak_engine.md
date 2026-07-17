# 07 Streak Engine

## Purpose
The Streak Engine is the core logic for measuring consistency. It is the most sensitive part of the Orbit motivation system.

## Definitions
- **Active Day**: A day where the user earns at least 50 points (v1.1 threshold).
- **Missed Day**: A day where the user earns < 50 points.
- **Grace Period**: The number of consecutive missed days allowed before the streak resets.

## Rules

### 1. The 5-Day Grace Period
- Orbit acknowledges that life is non-linear.
- A streak only resets to zero after **5 consecutive missed days**.
- If a user misses 4 days and performs on the 5th, the streak continues as `(Current Streak + 1)`.
- *Wait:* The "Missed Days" do not count toward the streak length. 
- *Example*: Streak is 10. User misses 3 days. User completes a day. Streak becomes 11.

### 2. Multiplier Application
- Streaks determine the **Consistency Multiplier** applied to the base score.
- Resets only affect future scores, never historical ones.

### 3. Visual Representation
- The UI displays a "Flame" icon with the current count.
- During the Grace Period, the flame "dims" to signal risk.

## Edge Cases
- **Manual Back-filling**: If a user logs data for a missed day within the 5-day window, the system recalculates the streak status immediately.
- **Leap Years**: Handled via standard UTC date comparison.

## Future Considerations
- "Streak Freeze" items (unlockable via high scores) to extend the 5-day grace period.

## Metadata
- **Version**: 1.0
- **Last Updated**: 2026-07-17
- **Dependencies**: [03 Scoring Algorithm](./03_scoring_algorithm.md)
