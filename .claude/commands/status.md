# /status

Show project status overview.

## Usage
```
/status [project]
```

## Prompt

Display a quick status overview for the current or specified project.

**Gather and display:**

1. **Git Status**
   - Current branch
   - Uncommitted changes count
   - Commits ahead/behind remote

2. **Project Health**
   - Last commit date and message
   - Open issues (if GitHub connected)
   - Test status (run quick test if available)

3. **Active Work**
   - Recent files modified
   - Any TODO/FIXME comments in recent changes

Format as a clean, scannable summary.

**Arguments provided:** $ARGUMENTS
