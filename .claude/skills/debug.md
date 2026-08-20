# debug

Systematic debugging workflow to identify and fix issues efficiently.

## Usage
```
/debug [error-description or error-message]
```

## Prompt

You are a debugging expert following a systematic approach to identify and resolve issues. Use the Scientific Method for debugging: hypothesize, test, analyze, repeat.

## The Debugging Scientific Method

1. **Observe**: What's the actual behavior?
2. **Hypothesize**: What might be causing it?
3. **Test**: How can we verify the hypothesis?
4. **Analyze**: What did the test reveal?
5. **Iterate**: Refine and repeat

## Systematic Debugging Workflow

### Phase 1: Understand the Problem (🔍)

**Gather information**:
1. **What's the error?**
   - Exact error message
   - Stack trace
   - Error code/type

2. **When does it occur?**
   - Always or intermittently?
   - Specific conditions?
   - Recent changes that might have caused it?

3. **What's the expected vs actual behavior?**
   - What should happen
   - What actually happens
   - Minimal reproduction steps

4. **What's the environment?**
   - Development, staging, production?
   - OS, browser, runtime versions
   - Configuration differences

### Phase 2: Reproduce the Issue (🔄)

**Create minimal reproduction**:

1. **Isolate the problem**:
   - Remove unnecessary code
   - Simplify inputs
   - Eliminate dependencies

2. **Make it consistent**:
   - Find reliable steps to trigger it
   - Document exact reproduction steps
   - Identify required conditions

3. **Create test case**:
   ```javascript
   // Minimal reproduction
   function reproduceIssue() {
     // Step 1: Setup
     const data = { /* minimal test data */ };

     // Step 2: Execute
     const result = problematicFunction(data);

     // Step 3: Observe
     console.log('Expected:', expectedResult);
     console.log('Actual:', result);
   }
   ```

### Phase 3: Investigate Root Cause (🔬)

**Systematic investigation techniques**:

#### 1. Add Logging
```javascript
// Strategic console logs
console.log('Input:', input);
console.log('After step 1:', intermediateValue);
console.log('Before error:', stateBeforeError);
console.log('Final output:', output);
```

#### 2. Use Debugger
```javascript
// Set breakpoints
debugger; // Execution pauses here

// Inspect variables
// Step through code line by line
// Watch expressions
```

#### 3. Binary Search Debugging
```javascript
// Comment out half the code
// Does error still occur?
// If yes: problem is in remaining half
// If no: problem is in commented half
// Repeat until isolated
```

#### 4. Rubber Duck Debugging
- Explain the code line by line
- Articulate what each part does
- Often reveals the issue

#### 5. Check Recent Changes
```bash
# Git blame - what changed recently?
git blame [file]

# Git diff - compare to working version
git diff [commit] [file]

# Git bisect - find breaking commit
git bisect start
git bisect bad  # Current broken state
git bisect good [last-known-good-commit]
```

### Phase 4: Form Hypotheses (💡)

**Common bug categories**:

1. **Logic Errors**:
   - Off-by-one errors
   - Incorrect conditionals
   - Wrong operators (= vs ==, && vs ||)

2. **State Management**:
   - Uninitialized variables
   - Race conditions
   - Stale data

3. **Type Issues**:
   - Type coercion (JS: "1" + 1 = "11")
   - Null/undefined
   - Type mismatches

4. **Scope Problems**:
   - Variable shadowing
   - Closure issues
   - this binding (JavaScript)

5. **Async Issues**:
   - Missing await
   - Promise not resolved
   - Callback hell
   - Race conditions

6. **External Dependencies**:
   - API changes
   - Library version mismatch
   - Environment differences

### Phase 5: Test Hypotheses (🧪)

**For each hypothesis**:

1. **Make a prediction**:
   - If hypothesis is correct, what will happen?

2. **Design a test**:
   - How can we verify it?

3. **Run the test**:
   - Execute and observe

4. **Analyze results**:
   - Hypothesis confirmed or rejected?

**Example**:
```javascript
// Hypothesis: array is unexpectedly empty
console.log('Array length:', myArray.length); // Test

// Hypothesis: async function not awaited
console.log('Before async call');
const result = await asyncFunction(); // Add await
console.log('After async call:', result); // Verify

// Hypothesis: type coercion issue
console.log('Type of value:', typeof value); // Check type
console.log('Value comparison:', value === expectedValue); // Strict equality
```

### Phase 6: Fix the Issue (🔧)

**Implement the fix**:

1. **Make targeted change**:
   - Fix only the specific issue
   - Don't refactor while debugging
   - Keep changes minimal

2. **Verify the fix**:
   - Run reproduction steps
   - Error should be gone
   - Expected behavior restored

3. **Test edge cases**:
   - Does fix work for all cases?
   - Any new issues introduced?

4. **Add regression test**:
   ```javascript
   it('should handle [the bug scenario]', () => {
     // Test that prevented regression
     const result = functionThatWasBuggy(edgeCaseInput);
     expect(result).toBe(expectedOutput);
   });
   ```

### Phase 7: Verify and Document (📝)

1. **Run full test suite**:
   ```bash
   npm test
   pytest
   ```

2. **Manual testing**:
   - Test in actual environment
   - Verify in all affected scenarios

3. **Document the fix**:
   ```markdown
   ## Bug Fix: [Issue description]

   **Problem**: [What was wrong]

   **Root Cause**: [Why it happened]

   **Solution**: [What was changed]

   **Files Changed**:
   - [file:line] - [change description]

   **Testing**: [How verified]
   ```

## Debugging Techniques by Issue Type

### Stack Trace Analysis

```
Error: Cannot read property 'name' of undefined
    at getUserName (user.js:45:20)
    at processUser (app.js:123:15)
    at main (app.js:200:5)
```

**Reading a stack trace**:
1. Start from the top (most recent call)
2. Identify your code (ignore library internals)
3. Line numbers point to exact location
4. Work backwards through call chain

### Async/Promise Debugging

```javascript
// Common async bugs

// 1. Missing await
const data = fetchData(); // Returns promise, not data
console.log(data); // Promise object, not data

// Fix
const data = await fetchData();

// 2. Unhandled rejection
promise.then(data => process(data)); // Error in process not caught

// Fix
promise
  .then(data => process(data))
  .catch(err => console.error('Error:', err));

// 3. Race condition
const [user, posts] = await Promise.all([
  fetchUser(),
  fetchPosts() // May try to use user before it's available
]);

// Fix: Ensure proper dependency
const user = await fetchUser();
const posts = await fetchPosts(user.id);
```

### Memory Leak Debugging

```javascript
// Common memory leaks

// 1. Event listeners not removed
element.addEventListener('click', handler);
// Later: forgot to remove
// element.removeEventListener('click', handler);

// 2. Closures holding references
function createClosure() {
  const largeData = new Array(1000000);
  return () => {
    console.log(largeData[0]); // Holds entire array in memory
  };
}

// 3. Timers not cleared
const intervalId = setInterval(() => {}, 1000);
// Later: forgot to clear
// clearInterval(intervalId);
```

## Debugging Tools

### Browser DevTools

```javascript
// Console API
console.log('Simple log');
console.error('Error message');
console.warn('Warning');
console.table(arrayOfObjects); // Nice table format
console.time('operation'); // Start timer
console.timeEnd('operation'); // End timer

// Debugger
debugger; // Pauses execution

// Conditional breakpoint
if (specificCondition) debugger;
```

### Node.js Debugging

```bash
# Run with inspector
node --inspect app.js

# Break on first line
node --inspect-brk app.js

# Chrome DevTools
# Open chrome://inspect in Chrome
```

### Python Debugging

```python
# Built-in debugger
import pdb; pdb.set_trace()

# Or Python 3.7+
breakpoint()

# Commands:
# n - next line
# s - step into
# c - continue
# p variable - print variable
# l - list code around current line
```

## Common Bug Patterns

### Off-by-One Errors

```javascript
// Array iteration
for (let i = 0; i <= array.length; i++) { // ❌ <= causes error
  console.log(array[i]);
}

// Fix
for (let i = 0; i < array.length; i++) { // ✅ < is correct
  console.log(array[i]);
}
```

### Type Coercion (JavaScript)

```javascript
// Unexpected behavior
"5" + 5 // "55" (string concatenation)
"5" - 5 // 0 (numeric subtraction)
[] + [] // "" (empty string)
[] + {} // "[object Object]"

// Fix: explicit conversion
Number("5") + 5 // 10
parseInt("5", 10) + 5 // 10
```

### Scope Issues

```javascript
// Problem
for (var i = 0; i < 5; i++) {
  setTimeout(() => console.log(i), 100);
}
// Logs: 5 5 5 5 5

// Fix: use let
for (let i = 0; i < 5; i++) {
  setTimeout(() => console.log(i), 100);
}
// Logs: 0 1 2 3 4
```

## Debugging Checklist

When debugging, check:

- [ ] Is the error message clear? Read it carefully
- [ ] Can you reproduce it consistently?
- [ ] What changed recently that might have caused it?
- [ ] Are all variables initialized?
- [ ] Are all promises awaited?
- [ ] Are types what you expect?
- [ ] Is data in the expected format?
- [ ] Are all dependencies up to date?
- [ ] Does it work in a different environment?
- [ ] Have you checked the documentation?
- [ ] Have you searched for similar issues?

## Output Format

```markdown
## Debug Analysis: [Issue Description]

### Problem Summary
[Brief description of the bug]

### Reproduction Steps
1. [Step 1]
2. [Step 2]
3. [Step 3]

### Investigation
[What was checked, what was found]

### Root Cause
[Why the bug occurred]

### Hypotheses Tested
1. ❌ [Hypothesis 1] - Rejected because [reason]
2. ❌ [Hypothesis 2] - Rejected because [reason]
3. ✅ [Hypothesis 3] - Confirmed by [evidence]

### Solution
[What needs to change]

### Implementation
```[language]
[Code changes]
```

### Verification
- [ ] Bug reproduction steps no longer trigger error
- [ ] Tests pass
- [ ] No new issues introduced

### Prevention
[How to avoid this in the future]
```

## Arguments

**Arguments provided:** {{arguments}}

If no error description provided, ask for:
- Error message/stack trace
- Steps to reproduce
- Expected vs actual behavior

---

Debug systematically using the scientific method: reproduce, investigate, hypothesize, test, fix, verify.
