# CLAUDE.md

This file provides guidance to Claude Code when working in this workspace.

## Active Projects

All active projects are located in `/Users/kentino/Projects/Active/`:

| Project | Description | Tech Stack |
|---------|-------------|------------|
| **TaskOwl** | Task management application | React, Express, MongoDB |
| **01** | Open-source AI voice assistant | Python (Poetry), ESP32 hardware |
| **Not a Label** | Platform for independent musicians | Next.js, Supabase, PWA |
| **FluxStudio** | Creative collaboration platform | React, Node.js, PostgreSQL |
| **ScopeAI** | Business intelligence platform | Python, FastAPI, dashboards |
| **FluxPrint** | 3D printing management | React, Node.js |
| **Vancouver-Move** | Relocation research: Campbell CA to Vancouver WA | Markdown (property tracker, financing, neighborhoods) |

## Quick Commands by Project

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

## Architecture Patterns

### Frontend Projects (TaskOwl, FluxStudio, Not a Label)
- React with functional components and hooks
- State management varies by project
- JWT authentication with bcrypt
- Responsive design with CSS-in-JS or Tailwind

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

## Code Quality Standards

1. **Security First**: Never commit API keys or secrets
2. **Type Safety**: Use TypeScript where available
3. **Testing**: Write tests for new features
4. **Error Handling**: Proper try/catch and error responses
5. **Documentation**: Update README for significant changes

## Session Naming Convention

Use descriptive session names for easy resumption:
- `{project}-{feature}` (e.g., `fluxstudio-auth-refactor`)
- `{project}-{bugfix}` (e.g., `taskowl-api-fix`)

## Archived Projects

Located in `/Users/kentino/Projects/Archived/` - reference only, not actively developed.
