# 03 State Management

## Purpose
Guidelines for handling local and global state using Riverpod.

## Principles
1. **Providers over ViewModels**: Use Riverpod `AsyncNotifierProvider` or `NotifierProvider` for stateful logic.
2. **Immutability**: All state objects must be immutable (using `freezed` for models).
3. **Reactivity**: Use `.watch()` for UI and `.listen()` for cross-service communication.
4. **Scoped State**: Feature-specific state should be defined within the feature folder.

## Key Providers
- `taskProvider`: Manages the list of tasks and filters.
- `scoreProvider`: The heart of the app; calculates real-time score.
- `habitProvider`: Tracks daily habit completion.
- `focusProvider`: Manages the timer state.

## Rules
- Avoid `StatefulWidget` for complex business logic. Use it only for ephemeral UI state (e.g., Tab index, TextField focus).
- Always use `ref.watch` in build methods and `ref.read` in callbacks (event handlers).

## Metadata
- **Version**: 1.0
- **Last Updated**: 2026-07-17
- **Dependencies**: `flutter_riverpod`, `riverpod_annotation`
