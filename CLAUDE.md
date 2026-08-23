# CLAUDE.md

You can use this file to configure how Claude Code works in your workspace.

## Active projects

You'll find all your active projects in `/Users/kentino/Projects/Active/`. The following table shows what each project does:

| Project | Description | Tech Stack |
|---------|-------------|------------|
| **TaskOwl** | Task management application | React, Express, MongoDB |
| **01** | Open-source AI voice assistant | Python (Poetry), ESP32 hardware |
| **Not a Label** | Platform for independent musicians | Next.js, Supabase, PWA |
| **FluxStudio** | Creative collaboration platform | React, Node.js, PostgreSQL |
| **ScopeAI** | Business intelligence platform | Python, FastAPI, dashboards |
| **FluxPrint** | 3D printing management | React, Node.js |
| **Vancouver-Move** | Relocation research: Campbell CA to Vancouver WA | Markdown (property tracker, financing, neighborhoods) |
| **EmbeddedSystems** | Full-stack hardware development | C/C++, KiCad, PlatformIO, Python |
| **AudioForge** | DAW plugin development (VST3) | C++17, JUCE framework |
| **HandTrack3D** | Webcam-based 3D hand interaction prototype | React, Three.js, MediaPipe, TypeScript |
| **MOOVE** | Project in planning | TBD |
| **Marvell-KB** | Keyboard firmware development | TBD |
| **homelab-scripts** | Homelab AI deployment scripts and research | Bash, Docker, Prometheus, Grafana |

## Quick commands by project

Use these commands to get started with each project:

### TaskOwl
```bash
cd ~/Projects/Active/TaskOwl
npm install && npm test
node server.js  # Start server
```

### 01 Project (AI Voice Assistant)
```bash
cd ~/Projects/Active/01
poetry install
poetry run 01                    # Run locally
poetry run 01 --server --expose  # Server mode
```

### Not a Label
```bash
cd ~/Projects/Active/Not\ a\ Label
npm install
npm run dev
```

### FluxStudio
```bash
cd ~/Projects/Active/FluxStudio
npm install
npm run dev
```

### ScopeAI
```bash
cd ~/Projects/Active/ScopeAI
pip install -r requirements.txt
python -m uvicorn main:app --reload
```

### EmbeddedSystems
```bash
cd ~/Projects/Active/EmbeddedSystems
# Firmware build (PlatformIO)
# pio run -e <env>
# pio run -t upload
```

### AudioForge
```bash
cd ~/Projects/Active/AudioForge
# Build SimpleGain plugin
cd plugins/SimpleGain
cmake -B build && cmake --build build
# Install to system plugin folder
cp -r build/SimpleGain_artefacts/VST3/SimpleGain.vst3 ~/Library/Audio/Plug-Ins/VST3/
```

### HandTrack3D
```bash
cd ~/Projects/Active/HandTrack3D
pnpm install
pnpm dev  # http://localhost:5173
# Allow webcam, then use hand gestures to interact with 3D objects
# Pinch to grab, open hand to release
```

### homelab-scripts
```bash
cd ~/Projects/Active/homelab-scripts
shellcheck *.sh helpers/*.sh       # Lint all scripts
bash shopping-list.sh              # Interactive shopping list
bash quick-start.sh                # Full deployment (on target server)
# Individual setup steps:
# bash 01-base-setup.sh through 08-maintenance-setup.sh
```

## Architecture patterns

These are the common architectural patterns used across the projects:

### Frontend Projects (TaskOwl, FluxStudio, Not a Label, HandTrack3D)
- React with functional components and hooks
- State management varies by project (Zustand for HandTrack3D)
- JWT authentication with bcrypt (where applicable)
- Responsive design with CSS-in-JS or Tailwind
- HandTrack3D uses React Three Fiber for 3D rendering

### Backend Services
- Express.js or FastAPI for APIs
- MongoDB (Mongoose) or PostgreSQL/Supabase
- RESTful API design
- Environment-based configuration

### 01 Project Specifics
- WebSocket server on localhost:10001
- LMC (Language Model Computer) message protocol
- ESP32 hardware integration for voice interface
- Supports local and server deployment modes

## Code quality standards

Follow these standards for all code contributions:

1. **Security First**: Never commit API keys or secrets
2. **Type Safety**: Use TypeScript where available
3. **Testing**: Write tests for new features
4. **Error Handling**: Proper try/catch and error responses
5. **Documentation**: Update README for significant changes

## Session naming convention

You can use descriptive session names for easier resumption:
- `{project}-{feature}` (e.g., `fluxstudio-auth-refactor`)
- `{project}-{bugfix}` (e.g., `taskowl-api-fix`)

## Slash commands

Use these commands to perform common development tasks:

| Command | Purpose |
|---------|---------|
| `/project [name]` | Switch to a project and load its context |
| `/team-review [scope]` | Parallel multi-agent code review (security + quality + UX + simplicity) |
| `/standup` | Morning status check across all projects |
| `/loop-quality [project]` | Code quality sweep (dead code, TODOs, type safety, security) |
| `/deploy [project]` | Deploy to configured environment |
| `/review` | Quick single-agent code review |
| `/security` | Security-focused review |
| `/test` | Run project test suite |
| `/health` | Project health check |
| `/deps` | Dependency audit |
| `/simplify` | Code simplification pass |

## Agent team

The following custom agents in `~/.claude/agents/` work together for orchestrated code reviews:
- **code-reviewer**: Code quality, patterns, bugs, test coverage
- **security-reviewer**: Vulnerabilities, auth, injection, secrets
- **code-simplifier**: Complexity, readability, dead code
- **ux-reviewer**: UI/UX, accessibility, interaction patterns
- **tech-lead-orchestrator**: Coordinates the full team
- **flux-studio-pm**: FluxStudio-specific project management
- **agent-architect**: Designs new specialized agents
- **agent-improver**: Meta-agent for improving other agents

## Keybindings

You can use these keyboard shortcuts for quick actions:

| Shortcut | Action |
|----------|--------|
| `Ctrl+P` | Toggle plan mode |
| `Ctrl+Shift+V` | Toggle voice mode |
| `Ctrl+M` | Model picker |
| `Ctrl+Shift+T` | Toggle thinking |
| `Ctrl+E` | External editor |
| `Alt+S` | Stash chat |
| `Ctrl+B` | Background task |

## Archived projects

You'll find archived projects in `/Users/kentino/Projects/Archived/`. Use them for reference only—they're no longer actively developed.
