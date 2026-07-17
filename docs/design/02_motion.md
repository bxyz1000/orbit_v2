# 02 Motion & Animation

## Purpose
Motion is used in Orbit not just for beauty, but for **feedback and reward**.

## Key Animations

### 1. Score Counter
- **Effect**: Rolling numbers when the score updates.
- **Duration**: 400ms.
- **Curve**: `Curves.easeOutExpo`.

### 2. Milestone Celebration
- **Effect**: Subtle particle burst when a PR or Goal is reached.
- **Logic**: Used sparingly to maintain impact.

### 3. List Transitions
- **Effect**: Staggered fade-in for list items to reduce cognitive load.
- **Duration**: 200ms per item.

### 4. The "Orbit Pulse"
- **Effect**: A subtle glow around the main score indicator when the user is in an "Active Streak."

## Performance
- All animations must maintain 60/120 FPS.
- Motion can be toggled off in "Performance Mode" for older devices.

## Metadata
- **Version**: 1.0
- **Last Updated**: 2026-07-17
- **Dependencies**: None
