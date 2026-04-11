# /team-review

Run a comprehensive parallel code review using the full agent team.

## Usage
```
/team-review [scope]
```

## Prompt

Orchestrate a parallel multi-agent code review. Scope can be:
- A file path or glob pattern
- "staged" - review staged git changes
- "branch" - review all changes on current branch vs main
- "recent" - review changes in the last commit
- If no scope given, default to staged changes, falling back to last commit

**Review Team (run ALL in parallel using the Task tool):**

1. **code-reviewer** agent: Code quality, patterns, bugs, test coverage
2. **security-reviewer** agent: Vulnerabilities, auth issues, injection risks, secrets exposure
3. **code-simplifier** agent: Complexity reduction, readability improvements, dead code
4. **ux-reviewer** agent: UI/UX concerns (only if changes include frontend files like .tsx, .jsx, .css, .html)

**Process:**
1. First, determine the diff/files to review based on scope argument
2. Launch all applicable review agents in parallel using the Task tool with the appropriate subagent_type
3. Each agent receives the same diff/file context
4. Collect all results and present a unified summary with:
   - Critical issues (must fix)
   - Warnings (should fix)
   - Suggestions (nice to have)
   - Overall verdict: APPROVE / CHANGES REQUESTED

**IMPORTANT:** Launch agents in parallel, not sequentially. Use a single message with multiple Task tool calls.

**Arguments provided:** $ARGUMENTS
