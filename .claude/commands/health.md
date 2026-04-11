# /health

Run a health check across all active projects. Designed for use with `/loop` for recurring checks.

## Usage
```
/health [project]
```

## Prompt

Run a quick health check across active projects. If a specific project is provided, check only that project.

**For each project in ~/Projects/Active/:**

1. **Dependency Health**
   - Check for outdated dependencies (`npm outdated` or `pip list --outdated`)
   - Flag any security vulnerabilities (`npm audit` or `pip-audit`)

2. **Git Health**
   - Uncommitted changes
   - Branches ahead/behind remote
   - Stale branches (no commits in 30+ days)

3. **Build Health**
   - Can the project build without errors?
   - Are there any TypeScript/lint errors?

4. **Test Health**
   - Run test suite if available
   - Report pass/fail/skip counts

**Output Format:**
```
## Project Health Report

### [Project Name]: [HEALTHY/WARNING/CRITICAL]
- Dependencies: [OK/N outdated/N vulnerable]
- Git: [clean/N uncommitted changes]
- Build: [OK/FAIL]
- Tests: [N passed, N failed, N skipped]
```

If run via `/loop`, keep output concise — only show projects with warnings or issues.

**Arguments provided:** $ARGUMENTS
