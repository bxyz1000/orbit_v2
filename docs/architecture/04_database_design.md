# 04 Database Design

## Purpose
Detailed schema definition for local-first persistence using Isar.

## Primary Collections

### `UserScore`
- `id` (Id)
- `date` (DateTime, Index)
- `totalScore` (int)
- `breakdown` (JSON/Embedded: {tasks: int, focus: int, etc.})
- `finalized` (bool)

### `Task`
- `id` (Id)
- `title` (String)
- `completed` (bool)
- `dueDate` (DateTime?)
- `createdAt` (DateTime)
- `completedAt` (DateTime?)

### `Habit`
- `id` (Id)
- `title` (String)
- `icon` (int)
- `color` (int)
- `currentStreak` (int)
- `bestStreak` (int)
- `history` (Links to `HabitCompletion`)

### `FocusSession`
- `id` (Id)
- `durationSeconds` (int)
- `startTime` (DateTime)
- `label` (String?)

## Rules
- Use `@Index()` on all fields used in filters (e.g., `date`, `completed`).
- Use `@Backlink()` for efficient relationships.
- Use `@embedded` for small, nested objects that don't need independent querying.

## Metadata
- **Version**: 1.0
- **Last Updated**: 2026-07-17
- **Dependencies**: `isar`
