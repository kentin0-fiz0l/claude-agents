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
| **voice-harness** | Minimal voice assistant (mic → STT → Ollama → TTS) | Python, faster-whisper, PyAudio |
| **MarchingArts** | Marching band SOPs & organizational knowledge base | Markdown (git + Google Drive) |

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

### voice-harness
```bash
cd ~/Projects/Active/voice-harness
pip install -r requirements.txt
# Copy and edit .env
cp .env.example .env
# Run (default: PTT mode, local Ollama)
python main.py
# Remote Ollama (homelab)
OLLAMA_HOST=http://192.168.x.x:11434 python main.py
# VAD (hands-free) mode
INPUT_MODE=vad python main.py
```

### MarchingArts
```bash
cd ~/Projects/Active/MarchingArts
# Find all TODOs needing program-specific details
grep -r "TODO" --include="*.md" .
# View structure
find . -name "*.md" | sort
```

## Homelab AI Infrastructure

### Overview

Self-hosted GPU inference server for embedded devices, voice assistants, and creative tools. Replaces cloud SaaS with on-premises compute and mesh networking.

**Selected Hardware Path**: Dual RTX 3090 + NVLink (Phase 2)  
**Target Cost**: ~$3,000–3,500  
**Performance**: 14–18 tok/s on 70B models, 40–50 tok/s on 27B models

### Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                   HOMELAB HARDWARE                           │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  GPU INFERENCE SERVER                                  │ │
│  │  • 2x RTX 3090 24GB (48GB pooled VRAM)                │ │
│  │  • Dell T5820/HP Z4 G4 workstation                    │ │
│  │  • 64-128GB ECC RAM                                    │ │
│  │  • Ubuntu Server 24.04 LTS                            │ │
│  │  • Ollama + vLLM + Open WebUI                         │ │
│  │  • Prometheus + Grafana monitoring                    │ │
│  │  • Tailscale mesh VPN                                 │ │
│  └────────────────────────────────────────────────────────┘ │
└──────────────────┬───────────────────────────────────────────┘
                   │
    ┌──────────────┴────────────┬────────────────┬──────────────┐
    ▼                           ▼                ▼              ▼
┌───────────┐          ┌─────────────┐    ┌──────────┐   ┌──────────┐
│ ESP32     │          │ 3D Printer  │    │ Voice    │   │ Hand     │
│ Devices   │          │ (FluxPrint) │    │ Clients  │   │ Tracking │
│ (01)      │          │             │    │ (01,     │   │ Devices  │
│           │          │             │    │  voice-  │   │          │
│ Custom HW │          │             │    │  harness)│   │          │
└───────────┘          └─────────────┘    └──────────┘   └──────────┘
```

### Deployment Strategy

**Phase 1** (In Progress): Single RTX 3090 (~$1,500)
- Build base infrastructure
- Validate with ESP32 devices and voice assistant
- Test 27B model performance (35–40 tok/s)

**Phase 2** (Planned): Add 2nd RTX 3090 + NVLink (~$900–1,100)
- Upgrade when daily 70B model use is validated
- Enables multi-user serving (5–10 concurrent)
- Pools VRAM for 48GB total

**Phase 3** (Future): Infrastructure hardening
- NAS for model storage (Synology DS220+)
- 10GbE networking
- UPS for clean shutdown

### Key Documentation

- **`homelab-scripts/GETTING-STARTED.md`** — Hardware paths guide for friends
- **`homelab-scripts/hardware-comparison.md`** — Dual 3090 vs Mac Studio deep dive
- **`homelab-scripts/gpu-inference-proposal.md`** — Detailed Phase 1 build plan
- **`homelab-scripts/homelab-research.md`** — Comprehensive 159KB hardware research
- **`homelab-scripts/shopping-list.sh`** — Interactive shopping list generator

### Performance Targets

| Model | Single RTX 3090 | Dual RTX 3090 NVLink |
|-------|----------------|---------------------|
| Qwen3.8 27B Q4 | 35–40 tok/s | 40–50 tok/s |
| Llama 3.1 70B Q4 | 3–5 tok/s (offload) | 14–18 tok/s |
| DeepSeek-R1 32B Q4 | 20–25 tok/s | 30–35 tok/s |
| Llama 3.1 8B Q8 | 65–90 tok/s | 80–120 tok/s |
| Max VRAM | 24GB | 48GB |
| Concurrent users | 2–3 | 5–10 (with vLLM) |
| ESP32 devices | 5–10 | 20+ (with batching) |

### Ecosystem Integration

**EmbeddedSystems** + **homelab-scripts** = Connected System
- ESP32 devices (voice, sensors, controllers) → Homelab backend
- Voice assistants (01 Project, voice-harness) → GPU inference
- 3D printer (FluxPrint) → Device management APIs
- HandTrack3D → Gesture-based control interface
- Mesh networking → Share compute with friends (optional)

### Quick Commands

```bash
# Deploy full homelab stack (Phase 1)
cd ~/Projects/Active/homelab-scripts
bash quick-start.sh

# Individual setup steps
bash 01-base-setup.sh       # Ubuntu hardening, Docker
bash 02-nvidia-setup.sh     # NVIDIA drivers
bash 03-ollama-setup.sh     # Ollama + models
bash 04-vllm-setup.sh       # vLLM (multi-user serving)
bash 05-deploy-stack.sh     # Open WebUI, monitoring
bash 06-tailscale-setup.sh  # Mesh VPN

# Generate shopping list for your hardware path
bash shopping-list.sh

# Check server health
curl http://localhost:11434/api/tags  # Ollama models
docker ps  # Running services
nvidia-smi  # GPU status
```

### Cost Analysis (3-Year Ownership)

| Component | Cost |
|-----------|------|
| Base workstation (used) | $320–580 |
| 1st RTX 3090 (used) | $820–1,050 |
| 2nd RTX 3090 (used) | $820–1,050 |
| NVLink bridge | $80–120 |
| **Hardware Total** | **$2,940–3,500** |
| Electricity (3yr @ 105W idle) | $414 |
| **TOTAL (3yr)** | **$3,354–3,914** |

**ROI**: Pays for itself in 4–8 months vs cloud APIs ($100–400/month)

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
