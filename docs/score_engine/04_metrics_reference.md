# 04 Metrics Reference

## Purpose
A comprehensive glossary and technical definition of every metric tracked by the Orbit system.

## Metrics

### Tasks
- **Unit**: Boolean (Completed/Incomplete).
- **Source**: Task Repository.
- **Attributes**: Title, DueDate, CompletionDate, Priority.
- **Notes**: Recurring tasks create a new Task instance on completion/reset.

### Habits
- **Unit**: Count/Boolean.
- **Source**: Habit Repository.
- **Attributes**: Title, Frequency, GoalCount, Color, Icon.
- **Notes**: Streak is tracked per individual habit and for the system as a whole.

### Focus
- **Unit**: Minutes.
- **Source**: Focus Session Repository.
- **Attributes**: Duration, StartTime, EndTime, Label.
- **Notes**: Must be active sessions. Manual entry is not scored as highly in future versions.

### Steps
- **Unit**: Count.
- **Source**: Health Integration (Health Connect / Google Fit) or Manual Entry.
- **Attributes**: Timestamp, Count.
- **Notes**: Integration data always overrides manual entry.

### Workout
- **Unit**: Minutes.
- **Source**: Health Integration or Manual Entry.
- **Attributes**: Type, Duration, Intensity.
- **Notes**: Minimum duration of 10 minutes to prevent "metric gaming."

### Sleep
- **Unit**: Hours/Minutes.
- **Source**: Health Integration or Manual Entry.
- **Attributes**: SleepStartTime, WakeTime, Quality.
- **Notes**: Default target is 8 hours unless changed in Settings.

### Goals
- **Unit**: Boolean.
- **Source**: Goal Repository.
- **Attributes**: Title, Deadline, Category.
- **Notes**: Daily Goals are reset at midnight.

## Technical Rules
- All durations are stored in **seconds** in the database for precision.
- All timestamps are stored in **UTC**.
- Display conversion to local time happens at the UI layer.

## Metadata
- **Version**: 1.0
- **Last Updated**: 2026-07-17
- **Dependencies**: None
