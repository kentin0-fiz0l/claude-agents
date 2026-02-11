# /deploy

Deploy a project to its configured environment.

## Usage
```
/deploy [project] [environment]
```

## Prompt

Deploy the specified project. If no project specified, detect from current directory.

**Deployment Targets:**

| Project | Command | Environment |
|---------|---------|-------------|
| FluxStudio | `npm run build && npm run deploy` | DigitalOcean |
| Not a Label | `npm run build && vercel --prod` | Vercel |
| ScopeAI | `docker build && docker push` | Container |
| TaskOwl | `npm run build` | Manual |

**Deployment Process:**
1. Identify project from arguments or current directory
2. Run pre-deploy checks (tests, lint)
3. Build the project
4. Deploy to configured environment
5. Verify deployment succeeded

**IMPORTANT:** Always confirm with user before deploying to production.

**Arguments provided:** $ARGUMENTS
