# 03 Component Library

## Purpose
Reusable UI components that form the "Orbit UI" package.

## Core Components

### `OrbitScoreCard`
- **Use**: Displays the current daily score and category breakdown.
- **Variants**: Compact (Dashboard), Expanded (Analytics).

### `OrbitActionTile`
- **Use**: For Tasks and Habits.
- **Interactions**: Swipe to complete, Long-press for details.

### `OrbitFocusCircle`
- **Use**: Large progress ring for the Focus Timer.
- **Visuals**: Thickness changes based on remaining time.

### `OrbitStatGrid`
- **Use**: 2x2 or 3x3 grid for high-level health and consistency metrics.

### `OrbitSectionHeader`
- **Use**: Bold titles with a subtitle and optional action button.

## Design Specs
- All components use the `OrbitTheme` data.
- Padding should strictly follow the `OrbitSpacing` tokens (8, 16, 24, 32).

## Metadata
- **Version**: 1.0
- **Last Updated**: 2026-07-17
- **Dependencies**: [04 Design Tokens](./04_design_tokens.md)
