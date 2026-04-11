# /standup

Morning standup: check status across all active projects.

## Usage
```
/standup
```

## Prompt

Run a quick status check across all active projects in `~/Projects/Active/`. For each project directory:

1. Run `git status --porcelain` to count uncommitted changes
2. Run `git log --oneline -3 --since="3 days ago"` to see recent commits
3. Check current branch name
4. Check if branch is ahead/behind remote

**Present results as a table:**

| Project | Branch | Changes | Recent Commits | Status |
|---------|--------|---------|----------------|--------|

Where Status is one of:
- "Clean" - no uncommitted changes, up to date
- "X uncommitted" - has uncommitted changes
- "Ahead/Behind" - out of sync with remote
- "Active" - recent commits in last 3 days
- "Stale" - no commits in 3+ days

**After the table:**
- Highlight any projects with uncommitted work that should be committed
- Note any projects that are behind their remote
- Suggest which project to focus on based on recent activity

**Arguments provided:** $ARGUMENTS
