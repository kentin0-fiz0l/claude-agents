# Agent Feedback System

This directory stores feedback from agent self-assessments, enabling continuous improvement of the agent ecosystem.

## File Naming Convention

```
{agent-name}-{YYYY-MM-DD}-{sequence}.json
```

Example: `code-reviewer-2026-02-10-001.json`

## Feedback Schema

```json
{
  "agent": "agent-name",
  "date": "YYYY-MM-DD",
  "session_id": "optional-session-identifier",
  "trigger": "user-report|periodic-review|excellence-capture|self-assessment",
  "outcome": "success|partial|failure",
  "confidence": "high|medium|low",
  "issues": [
    {
      "type": "prompt-clarity|scope-creep|context-gap|coordination|output-format",
      "description": "What went wrong",
      "severity": "critical|high|medium|low"
    }
  ],
  "successes": [
    {
      "pattern": "What worked well",
      "reason": "Why it was effective"
    }
  ],
  "improvements_suggested": [
    {
      "type": "quick-fix|enhancement|architectural",
      "description": "Proposed improvement",
      "priority": "high|medium|low"
    }
  ],
  "improvements_applied": [
    "List of changes actually made"
  ],
  "metrics": {
    "items_reviewed": 0,
    "issues_found": 0,
    "false_positives": 0,
    "time_spent_estimate": "quick|moderate|lengthy"
  },
  "learnings": [
    "Key insights from this session"
  ]
}
```

## How to Use

### Manual Feedback Entry
When an agent performs exceptionally well or poorly, create a feedback entry to capture the learning.

### Triggering Improvement Analysis
Invoke the `agent-improver` agent with:
- A specific agent to analyze
- Recent feedback files from this directory
- Observations from the session

### Periodic Reviews
Monthly, use `agent-improver` to:
1. Analyze accumulated feedback
2. Identify patterns across agents
3. Generate systemic improvements
4. Update agent prompts accordingly

## Metrics to Track

| Metric | Description |
|--------|-------------|
| Effectiveness Rate | % of tasks where agent achieved objective |
| Precision | % of flagged issues that were genuine problems |
| Recall | % of actual issues that were caught |
| Coordination Quality | Smoothness of handoffs between agents |
| User Satisfaction | Subjective rating of output quality |

## Continuous Improvement Cycle

```
1. Agent performs task
   ↓
2. Self-assessment (captured via @agent-improver flags)
   ↓
3. Feedback logged here
   ↓
4. agent-improver analyzes patterns
   ↓
5. Improvements generated
   ↓
6. User approves changes
   ↓
7. Agent prompts updated
   ↓
   (cycle repeats)
```

The goal is agents that get measurably better with every interaction.
