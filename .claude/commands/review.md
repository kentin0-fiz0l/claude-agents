# /review

Trigger a comprehensive code review using the agent ecosystem.

## Usage
```
/review [files or description]
```

## Prompt

You are coordinating a code review. Use the code-reviewer agent to analyze the specified files or recent changes.

If no files specified, review the most recent uncommitted changes using `git diff`.

**Review Process:**
1. Identify what needs reviewing (files specified or git diff)
2. Launch the code-reviewer agent with appropriate context
3. Summarize findings with severity levels (CRITICAL/HIGH/MEDIUM/LOW)
4. Provide actionable recommendations

**Arguments provided:** $ARGUMENTS
