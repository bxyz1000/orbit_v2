# 06 Future Integrations

## Purpose
Roadmap for expanding Orbit's data reach.

## Priority 1: Health Platforms
- **Health Connect (Android)**: Steps, Heart Rate, Sleep.
- **Apple Health (iOS)**: Steps, Active Energy, Workouts.

## Priority 2: Calendar & Productivity
- **Google Calendar / Outlook**: Syncing events to the Orbit Planner.
- **Notion / Obsidian**: Task syncing for power users.

## Priority 3: Wearables
- **Garmin / Oura**: Deep sleep and recovery metrics to influence the "Recovery Mode" logic.

## Technical Strategy
- Implement a **Plugin Architecture** where each integration is a standalone package or feature module.
- Use **Adapter Pattern** to convert external data into Orbit Domain models (e.g., `GoogleCalendarEvent` -> `OrbitPlannerEvent`).

## Metadata
- **Version**: 1.0
- **Last Updated**: 2026-07-17
- **Dependencies**: None
