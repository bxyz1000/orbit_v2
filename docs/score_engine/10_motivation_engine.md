# 10 Motivation Engine

## Purpose
The Motivation Engine governs the timing and tone of system communications (Notifications, Dashboard Quotes, AI Insights) to maintain the "Become Better Than Yesterday" mindset.

## Scope
Interfaces with the UI and Notification services.

## Logic
1. **Morning Kickstart**: (8:00 AM) - Highlights yesterday's score and Today's Goal.
2. **Mid-day Momentum**: (1:00 PM) - Checks focus timer progress.
3. **Evening Reflection**: (9:00 PM) - Encourages closing out tasks to avoid penalties.
4. **The "Slump" Detector**: If score drops for 3 consecutive days, the AI Coach shifts tone from "Challenging" to "Empathetic."

## Tone Principles
- **Direct**: No fluff.
- **Stoic**: Focus on action and discipline.
- **Encouraging**: Celebrate PRs with high intensity.

## Metadata
- **Version**: 1.0
- **Last Updated**: 2026-07-17
- **Dependencies**: [08 Personal Records](./08_personal_records.md), [AI Coach](../ai/01_ai_coach.md)
