# 02 Folder Structure

## Purpose
Standardized directory layout for a scalable, modular Flutter application.

## Structure
```
lib/
├── app/                  # Main App Widget & Global Shell
├── core/                 # Cross-cutting concerns
│   ├── database/         # Isar initialization & schema migrations
│   ├── theme/            # Orbit Design System (Tokens, Theme)
│   ├── utils/            # Extensions, Formatters, Constants
│   └── providers/        # Global providers (ScoreEngine, AI)
├── features/             # Domain-specific modules
│   ├── tasks/
│   │   ├── domain/       # Models
│   │   ├── data/         # Repositories
│   │   ├── application/  # Services (Specific logic)
│   │   └── presentation/ # Widgets & Screen Controllers
│   ├── focus/
│   ├── health/
│   ├── habits/
│   ├── planner/
│   ├── goals/
│   └── analytics/
├── shared/               # Reusable Widgets & Logic
│   └── widgets/          # OrbitUI components
└── main.dart             # Entry point
```

## Rules
- Features should be as decoupled as possible.
- Shared widgets must remain agnostic of specific feature state.
- Business logic resides in `application/` or `providers/`, never in the Widget `build` method.

## Metadata
- **Version**: 1.0
- **Last Updated**: 2026-07-17
- **Dependencies**: None
