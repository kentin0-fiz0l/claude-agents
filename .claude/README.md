# Claude Code Agent Ecosystem

A self-improving agent ecosystem for [Claude Code](https://claude.ai/claude-code) with 8 specialized agents for code review, security, UX, and multi-project coordination.

## Overview

This repository contains a comprehensive agent ecosystem designed for a multi-project development workflow. Each agent has a specific responsibility and can coordinate with others to provide thorough, high-quality feedback on code changes.

### Key Features

- **Self-Improving**: All agents include feedback protocols that enable continuous improvement
- **Multi-Project Aware**: Agents understand context across 6 different project types and tech stacks
- **Consistent Standards**: Unified severity classification (CRITICAL/HIGH/MEDIUM/LOW) across all review agents
- **Quantitative Thresholds**: Specific metrics replace vague guidance (e.g., "cyclomatic complexity >10")
- **Clear Escalation**: Explicit triggers for when to involve other agents or escalate to users

## Agents

| Agent | Purpose | Model | Lines |
|-------|---------|-------|-------|
| [agent-improver](agents/agent-improver.md) | Meta-agent for continuous ecosystem improvement | opus | 404 |
| [agent-architect](agents/agent-architect.md) | Design and validate new agents | sonnet | 339 |
| [code-simplifier](agents/code-simplifier.md) | Reduce complexity, improve readability | sonnet | 355 |
| [tech-lead-orchestrator](agents/tech-lead-orchestrator.md) | Architectural decisions, multi-project coordination | opus | 309 |
| [flux-studio-pm](agents/flux-studio-pm.md) | Feature review pipeline coordination | sonnet | 267 |
| [ux-reviewer](agents/ux-reviewer.md) | User experience, accessibility, design | sonnet | 256 |
| [security-reviewer](agents/security-reviewer.md) | Vulnerabilities, auth, data protection | sonnet | 254 |
| [code-reviewer](agents/code-reviewer.md) | Code quality, testing, best practices | opus | 243 |

**Total: 2,427 lines of agent configuration**

## Agent Relationships

```
                    ┌─────────────────────┐
                    │   agent-improver    │ ◄── Improves all agents
                    │    (meta-agent)     │
                    └─────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
    ┌─────────────────┐ ┌───────────┐ ┌─────────────────┐
    │ agent-architect │ │ All other │ │ tech-lead-      │
    │ (creates new)   │ │  agents   │ │ orchestrator    │
    └─────────────────┘ └───────────┘ └─────────────────┘
                                              │
                              ┌───────────────┼───────────────┐
                              ▼               ▼               ▼
                    ┌─────────────┐  ┌─────────────┐  ┌─────────────┐
                    │code-reviewer│  │security-    │  │ux-reviewer  │
                    │             │  │reviewer     │  │             │
                    └─────────────┘  └─────────────┘  └─────────────┘
                              │
                              ▼
                    ┌─────────────────┐
                    │ code-simplifier │
                    └─────────────────┘
```

## Installation

1. Clone this repository to your Claude Code configuration directory:

```bash
git clone https://github.com/kentin0-fiz0l/claude-agents.git ~/.claude
```

Or if you already have a `~/.claude` directory:

```bash
cd ~/.claude
git remote add origin https://github.com/kentin0-fiz0l/claude-agents.git
git pull origin main
```

2. The agents will be automatically available in Claude Code.

## Usage

Agents are invoked automatically by Claude Code based on context, or you can reference them explicitly:

```
"Use the code-reviewer agent to review my authentication changes"

"Let the security-reviewer audit this API endpoint"

"Have the agent-architect suggest agents for my new project"
```

### Agent Selection Guide

| Scenario | Agent to Use |
|----------|--------------|
| Code has been written, needs review | code-reviewer |
| Security-sensitive changes (auth, API, data) | security-reviewer |
| UI/UX changes, accessibility concerns | ux-reviewer |
| Complex code needs simplification | code-simplifier |
| Architectural decisions, multi-project work | tech-lead-orchestrator |
| FluxStudio feature coordination | flux-studio-pm |
| Want to design new agents | agent-architect |
| Agent performed poorly, needs improvement | agent-improver |

## Customization

### Adapting to Your Projects

The agents are configured for a specific multi-project workspace. To adapt them to your projects:

1. Update the **Workspace Context** section in each agent with your projects and tech stacks
2. Modify **Escalation Triggers** to match your team's workflow
3. Adjust **Quantitative Thresholds** based on your codebase's characteristics

### Adding New Agents

Use the `agent-architect` agent to design new agents that fit your workflow:

```
"I need an agent to help with database migrations"
```

The agent-architect will:
- Assess if a new agent is necessary
- Design the agent specification
- Ensure it fits with the existing ecosystem

## Self-Improvement System

All agents include a self-improvement protocol:

1. **Feedback Flags**: Agents can flag issues with `@agent-improver: [observation]`
2. **Proven Patterns**: 8 validated improvement patterns are documented in agent-improver
3. **Severity Classification**: Consistent CRITICAL/HIGH/MEDIUM/LOW across all agents
4. **Quarterly Reviews**: Ecosystem health checks ensure agents stay effective

### Proven Improvement Patterns

| Pattern | Description |
|---------|-------------|
| Quantitative Thresholds | Replace vague guidance with specific numbers |
| Project-Specific Context | Add tables with project stacks and patterns |
| Severity Classification | Standardize on CRITICAL/HIGH/MEDIUM/LOW |
| Escalation Triggers | Explicit "escalate when" scenarios |
| Deployment Blocking Criteria | "Automatic blocks" vs "Conditional blocks" |
| Before/After Examples | Concrete code showing transformations |
| Handoff Protocols | Clear coordination triggers between agents |
| Validation Checklists | Checkbox lists before output |

## Project Context

These agents were designed for a workspace with these projects:

| Project | Stack |
|---------|-------|
| TaskOwl | React, Express, MongoDB |
| 01 Project | Python (Poetry), ESP32 |
| Not a Label | Next.js, Supabase, PWA |
| FluxStudio | React, Node.js, PostgreSQL |
| ScopeAI | Python, FastAPI |
| FluxPrint | React, Node.js |

## License

MIT License - feel free to adapt these agents for your own workflows.

## Contributing

Improvements welcome! If you discover new patterns or enhance an agent:

1. Document the change and rationale
2. Update the agent's self-improvement section if applicable
3. Submit a PR with before/after examples if possible
