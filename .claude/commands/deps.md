# /deps

Check and manage dependencies for the current project.

## Usage
```
/deps [check|update|audit]
```

## Prompt

Manage dependencies for the current project. Default action is `check`.

**Actions:**

### `check` (default)
- Detect package manager (npm/yarn/pnpm/bun/poetry/pip/cargo)
- List outdated dependencies with current vs latest versions
- Highlight major version bumps that may have breaking changes

### `update`
- Update dependencies to latest compatible versions
- Run tests after updating to verify nothing broke
- Show a summary of what was updated

### `audit`
- Run security audit (`npm audit`, `pip-audit`, `cargo audit`)
- Categorize findings by severity (CRITICAL/HIGH/MEDIUM/LOW)
- Suggest fixes for known vulnerabilities

**Output Format:**
```
## Dependencies: [project name]

### Outdated (N packages)
| Package | Current | Latest | Type |
|---------|---------|--------|------|
| ...     | ...     | ...    | minor/major/patch |

### Security (N issues)
| Severity | Package | Issue | Fix |
|----------|---------|-------|-----|
| ...      | ...     | ...   | ... |
```

**Arguments provided:** $ARGUMENTS
