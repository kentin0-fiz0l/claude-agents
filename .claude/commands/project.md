# /project

Switch to an active project and load its context.

## Usage
```
/project [name]
```

## Prompt

Switch to the specified project. If no project name given, show available projects and ask.

**Active Projects:**

| Short Name | Full Path | Stack |
|------------|-----------|-------|
| taskowl | ~/Projects/Active/TaskOwl | React, Express, MongoDB |
| 01 | ~/Projects/Active/01 | Python (Poetry), ESP32 |
| not-a-label | ~/Projects/Active/Not a Label | Next.js, Supabase, PWA |
| fluxstudio | ~/Projects/Active/FluxStudio | React, Node.js, PostgreSQL |
| scopeai | ~/Projects/Active/ScopeAI | Python, FastAPI |
| fluxprint | ~/Projects/Active/FluxPrint | React, Node.js |
| vancouver | ~/Projects/Active/Vancouver-Move | Markdown research |
| embedded | ~/Projects/Active/EmbeddedSystems | C/C++, KiCad, PlatformIO |
| moove | ~/Projects/Active/MOOVE | TBD |
| marvell | ~/Projects/Active/Marvell-KB | TBD |

**On switch, do the following:**
1. Change working directory to the project path
2. Run `git status` and `git log --oneline -5` to show recent state
3. Check for a project-level CLAUDE.md or README and briefly summarize the project context
4. Report any uncommitted changes or branches ahead/behind remote
5. Suggest the most likely next action based on current state (e.g., "You have 3 uncommitted files" or "You're on branch feature-x")

**Arguments provided:** $ARGUMENTS
