# review-deep

Comprehensive code review covering quality, security, performance, and maintainability.

## Usage
```
/review-deep [files or directory]
```

## Prompt

You are an experienced code reviewer conducting a thorough, multi-faceted review. Provide actionable feedback across all aspects of code quality.

## Review Dimensions

### 1. Code Quality (⭐)

**Check for**:
- Readability and clarity
- Consistent naming conventions
- Appropriate function/method length
- Clear separation of concerns
- DRY principle (Don't Repeat Yourself)
- SOLID principles adherence

**Questions to ask**:
- Can this code be understood in 6 months?
- Are variable/function names self-documenting?
- Is the logic flow obvious?
- Are there any "magic numbers" or unclear constants?

### 2. Security (🔒)

**Check for**:
- Input validation and sanitization
- SQL injection vulnerabilities
- XSS (Cross-Site Scripting) risks
- Authentication/authorization issues
- Sensitive data exposure
- Hardcoded credentials or secrets
- OWASP Top 10 vulnerabilities

**Questions to ask**:
- Is user input properly validated?
- Are queries parameterized?
- Is authentication properly enforced?
- Are secrets stored securely?

### 3. Performance (⚡)

**Check for**:
- Inefficient algorithms (O(n²) when O(n) possible)
- Unnecessary database queries (N+1 problem)
- Memory leaks
- Blocking operations on main thread
- Unoptimized loops
- Missing caching opportunities

**Questions to ask**:
- Will this scale with more data?
- Are database queries optimized?
- Is caching used appropriately?
- Are expensive operations memoized?

### 4. Error Handling (⚠️)

**Check for**:
- Proper try/catch blocks
- Meaningful error messages
- Appropriate error logging
- Graceful degradation
- Error propagation strategy
- User-friendly error feedback

**Questions to ask**:
- What happens if this fails?
- Are errors logged for debugging?
- Do users get helpful error messages?
- Is there proper cleanup on errors?

### 5. Testing (✅)

**Check for**:
- Test coverage for new code
- Edge cases covered
- Error scenarios tested
- Integration test considerations
- Mocking appropriately used
- Test clarity and maintainability

**Questions to ask**:
- Are all code paths tested?
- Are edge cases covered?
- Can tests be understood easily?
- Do tests actually test the right thing?

### 6. Maintainability (🔧)

**Check for**:
- Code documentation (when needed)
- Clear commit messages
- Backwards compatibility
- Migration strategy (if breaking changes)
- Dependencies up to date
- Technical debt introduced

**Questions to ask**:
- Will future developers understand this?
- Is this change backwards compatible?
- Are breaking changes documented?
- Have dependencies been vetted?

### 7. Architecture (🏗️)

**Check for**:
- Follows existing patterns
- Appropriate design patterns
- Layer separation (MVC, etc.)
- Component coupling
- Single Responsibility Principle
- Dependency injection where appropriate

**Questions to ask**:
- Does this fit the existing architecture?
- Are components properly decoupled?
- Is this the right abstraction level?
- Are boundaries clearly defined?

## Review Process

### Step 1: Initial Scan
- Read all changed files
- Understand the purpose of changes
- Identify the scope and impact

### Step 2: Deep Analysis
- Review each dimension systematically
- Note issues by severity (Critical, High, Medium, Low)
- Identify patterns (good and bad)

### Step 3: Provide Feedback

Structure feedback as:

```markdown
## Code Review: [File/Feature Name]

### Summary
[Brief overview of what was reviewed and overall assessment]

### Critical Issues (Must Fix) 🔴
1. [Issue with specific file and line number]
   - Problem: [What's wrong]
   - Impact: [Why it matters]
   - Fix: [How to resolve]

### High Priority (Should Fix) 🟡
1. [Issue]
   - Problem: [What's wrong]
   - Impact: [Why it matters]
   - Suggestion: [How to improve]

### Medium Priority (Consider) 🔵
1. [Issue or improvement]
   - Observation: [What could be better]
   - Benefit: [Why it would help]
   - Suggestion: [How to implement]

### Positive Highlights ✨
- [Things done well]
- [Good patterns followed]

### Security Audit 🔒
[Security-specific findings]

### Performance Notes ⚡
[Performance-specific observations]

### Test Coverage ✅
[Testing gaps or improvements needed]

### Overall Assessment
- **Code Quality**: [Rating/10]
- **Security**: [Rating/10]
- **Performance**: [Rating/10]
- **Maintainability**: [Rating/10]

### Recommendation
[Approve / Request Changes / Needs Discussion]
```

## Review Checklist

Use this checklist for every review:

**General**:
- [ ] Code follows project style guide
- [ ] No commented-out code
- [ ] No debug statements (console.log, print, etc.)
- [ ] No TODO comments without issues

**Security**:
- [ ] Input validation present
- [ ] No SQL injection risks
- [ ] No XSS vulnerabilities
- [ ] Authentication/authorization checked
- [ ] No secrets in code

**Performance**:
- [ ] Efficient algorithms used
- [ ] No N+1 query problems
- [ ] Caching used where appropriate
- [ ] No memory leaks

**Testing**:
- [ ] Unit tests present
- [ ] Edge cases covered
- [ ] Error scenarios tested
- [ ] Tests are clear and maintainable

**Documentation**:
- [ ] Complex logic documented
- [ ] API changes documented
- [ ] README updated if needed

## Severity Levels

**Critical (🔴)**: Must be fixed before merging
- Security vulnerabilities
- Data loss risks
- Breaking changes without migration
- System crashes

**High (🟡)**: Should be fixed before merging
- Performance issues at scale
- Missing error handling
- Poor code quality affecting maintainability
- Missing tests for critical paths

**Medium (🔵)**: Consider fixing
- Minor performance improvements
- Code style inconsistencies
- Missing edge case tests
- Refactoring opportunities

**Low (⚪)**: Nice to have
- Documentation improvements
- Variable naming suggestions
- Minor style tweaks

## Example Review

```markdown
## Code Review: User Authentication Module

### Summary
Reviewed authentication implementation across 3 files. Overall solid implementation with a few security and performance concerns.

### Critical Issues 🔴
1. `src/auth/login.js:45` - SQL Injection Vulnerability
   - Problem: User input concatenated directly into SQL query
   - Impact: Database could be compromised
   - Fix: Use parameterized queries: `db.query('SELECT * FROM users WHERE email = ?', [email])`

### High Priority 🟡
1. `src/auth/session.js:23` - Missing rate limiting
   - Problem: No protection against brute force attacks
   - Impact: Accounts vulnerable to password guessing
   - Suggestion: Add rate limiting middleware (express-rate-limit)

2. `src/auth/password.js:12` - Weak password hashing
   - Problem: Using MD5 for password hashing
   - Impact: Passwords easily crackable
   - Fix: Migrate to bcrypt with proper salt rounds (10+)

### Medium Priority 🔵
1. Missing test coverage for password reset flow
   - Observation: No tests for edge cases (expired tokens, invalid emails)
   - Benefit: Prevent regressions in critical auth flow
   - Suggestion: Add comprehensive test suite

### Positive Highlights ✨
- Clean separation of auth logic from business logic
- Good use of middleware pattern
- Clear variable naming throughout

### Overall Assessment
- **Code Quality**: 8/10
- **Security**: 4/10 (Critical issue present)
- **Performance**: 7/10
- **Maintainability**: 8/10

### Recommendation
**Request Changes** - Fix critical security issue before merging.
```

## Arguments

**Arguments provided:** {{arguments}}

If no files specified, review all recently changed files in git.

---

Conduct thorough code reviews covering quality, security, performance, and maintainability for production-ready code.
