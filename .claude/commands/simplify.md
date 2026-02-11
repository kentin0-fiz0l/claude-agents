# /simplify

Reduce code complexity using the code-simplifier agent.

## Usage
```
/simplify [file or function]
```

## Prompt

You are coordinating code simplification. Use the code-simplifier agent to reduce complexity.

**Simplification Process:**
1. Analyze the specified code for complexity issues
2. Launch the code-simplifier agent
3. Identify: cyclomatic complexity >10, functions >25 lines, nesting >3 levels
4. Provide refactored code with explanations
5. Ensure behavior is preserved

**Arguments provided:** $ARGUMENTS
