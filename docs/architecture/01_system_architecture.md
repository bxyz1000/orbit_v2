# 01 System Architecture

## Purpose
High-level overview of the Orbit technical stack and data flow.

## Stack
- **Framework**: Flutter (Stable)
- **Language**: Dart
- **State Management**: Riverpod (Functional approach)
- **Local Database**: Isar (NoSQL, high-performance)
- **Navigation**: GoRouter (Declarative)
- **Design System**: Custom Material 3 wrapper (Orbit Design System)

## Layers
1. **Domain (Core)**: Models, Entities, and immutable logic.
2. **Data (Infrastructure)**: Repositories, Isar Schemas, API Clients (Future).
3. **Application (Service)**: Business logic, Score Engine, AI Prompt construction.
4. **Presentation (UI)**: Widgets, Providers, Theme.

## Data Flow
- User Interaction -> Provider -> Repository -> Isar -> Stream -> UI Update.
- Score Service listens to all Repository changes -> Calculates Active Score -> Updates Score Provider.

## Versioning
- Orbit v1.0 builds on local-first principles.
- Future versions will introduce Sync via a custom Service Layer.

## Metadata
- **Version**: 1.0
- **Last Updated**: 2026-07-17
- **Dependencies**: Flutter SDK
