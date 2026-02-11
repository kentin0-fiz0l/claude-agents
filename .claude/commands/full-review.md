# /full-review

Run a comprehensive review using all review agents in parallel.

## Usage
```
/full-review [files or feature]
```

## Prompt

Coordinate a full review pipeline using Agent Teams to run reviews in parallel.

**Full Review Process:**

1. Create a review team with teammates for each domain
2. Create parallel tasks:
   - Code quality review (code-reviewer)
   - Security audit (security-reviewer)
   - UX evaluation (ux-reviewer)
   - Complexity analysis (code-simplifier)
3. Launch teammates to work in parallel
4. Synthesize all findings into a unified report
5. Prioritize by severity: CRITICAL > HIGH > MEDIUM > LOW
6. Provide go/no-go recommendation

**Output Format:**
```
## Full Review Summary

### Code Quality: [PASS/WARN/FAIL]
[Key findings]

### Security: [PASS/WARN/FAIL]
[Key findings]

### UX/Accessibility: [PASS/WARN/FAIL]
[Key findings]

### Complexity: [PASS/WARN/FAIL]
[Key findings]

## Recommendation: [APPROVE/CHANGES REQUESTED/BLOCKED]
[Action items]
```

**Arguments provided:** $ARGUMENTS
