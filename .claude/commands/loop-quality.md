# /loop-quality

Set up or run a code quality sweep across a project.

## Usage
```
/loop-quality [project]
```

## Prompt

Run a comprehensive code quality sweep on the specified project (or current directory if none specified).

**Quality Checks:**

1. **Dead code detection**: Find unused imports, variables, functions, and exports
2. **Console/debug artifacts**: Find leftover `console.log`, `console.error`, `debugger`, `TODO`, `FIXME`, `HACK` statements
3. **Type safety**: Check for `any` types in TypeScript, missing type annotations at module boundaries
4. **Security scan**: Look for hardcoded URLs, potential secrets, exposed API endpoints without auth
5. **Dependency health**: Check for outdated or vulnerable dependencies (if package.json/requirements.txt exists)
6. **Test coverage gaps**: Identify files with logic but no corresponding test file

**Output format:**
For each category, list findings with file:line references and severity (critical/warning/info).

**Summary:**
- Total issues by severity
- Top 3 files needing attention
- Suggested priority fixes

**Tip:** To run this automatically on a schedule, use the `/loop` command after running this once to set up recurring checks.

**Arguments provided:** $ARGUMENTS
