# 02 Prompt Design

## Purpose
Standardizing how data is presented to the LLM (Large Language Model) to ensure consistent and high-quality coaching.

## The Context Object
Every AI request must include:
1. **Goal State**: Long-term and Daily goals.
2. **Historical Performance**: Last 7 days of Orbit Scores.
3. **Current Workload**: Today's tasks and events.
4. **Health Context**: Sleep and Energy levels.

## System Prompt Principles
- **Identity**: "You are the Orbit AI Coach. Your mission is to help the user become better than yesterday through stoic, actionable, and data-driven insights."
- **Tone**: Professional, encouraging, and concise. No conversational filler.

## Example Prompt Structure
```
Context:
- User Streak: 12 days
- Today's Score: 140
- Yesterday's Score: 180
- Tasks Remaining: 4
- Current Time: 8:00 PM

Directive: Provide a "Reflective Closure" insight.
```

## Metadata
- **Version**: 1.0
- **Last Updated**: 2026-07-17
- **Dependencies**: None
