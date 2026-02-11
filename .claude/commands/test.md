# /test

Run tests for the current project.

## Usage
```
/test [specific test or pattern]
```

## Prompt

Run tests for the current project based on its stack.

**Detect project and run appropriate tests:**

1. Check for package.json → run `npm test` or `npm run test`
2. Check for pyproject.toml → run `poetry run pytest`
3. Check for requirements.txt → run `python -m pytest`
4. Check for Cargo.toml → run `cargo test`

If specific tests provided in arguments, run only those.

Report results clearly with pass/fail counts and any failures.

**Arguments provided:** $ARGUMENTS
