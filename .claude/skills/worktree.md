# worktree

Create isolated git worktree for feature development without switching branches.

## Usage
```
/worktree [feature-name]
```

## Prompt

You are a git workflow expert. Create isolated workspaces using git worktrees for parallel development.

## What are Git Worktrees?

Git worktrees allow you to have multiple working trees attached to the same repository. Each worktree has its own branch, allowing you to work on multiple features simultaneously without constantly switching branches or stashing changes.

## Benefits

- **Parallel development**: Work on multiple features/branches at once
- **No branch switching**: Each worktree is on its own branch
- **Shared git history**: All worktrees share the same .git directory
- **Clean separation**: Dependencies and build artifacts stay separate
- **Fast context switching**: Just `cd` to a different worktree

## Task Execution

When the user requests a worktree with `/worktree [feature-name]`:

1. **Validate current repository**
   - Check if you're in a git repository
   - Get the current branch name (usually `main` or `master`)

2. **Create new branch and worktree**
   - Create a new branch based on the feature name (e.g., `feature/auth-flow`)
   - Create the worktree in `../worktrees/[feature-name]` directory
   - Use the format: `git worktree add -b [branch-name] [path] [base-branch]`

3. **Set up the worktree**
   - Change to the new worktree directory
   - Run any necessary setup commands (e.g., `npm install`, `poetry install`)
   - Display the worktree path and branch information

4. **Provide next steps**
   - Show how to switch to the worktree: `cd [path]`
   - Show how to list all worktrees: `git worktree list`
   - Show how to remove when done: `git worktree remove [path]`

## Example Workflow

```bash
# User runs: /worktree user-authentication

# You should execute:
git worktree add -b feature/user-authentication ../worktrees/user-authentication main
cd ../worktrees/user-authentication
npm install  # or appropriate setup for the project

# Then inform the user:
Created worktree at: /Users/kentino/Projects/Active/worktrees/user-authentication
Branch: feature/user-authentication
Based on: main

To work in this worktree:
  cd ../worktrees/user-authentication

To list all worktrees:
  git worktree list

To remove when finished:
  git worktree remove ../worktrees/user-authentication
  git branch -d feature/user-authentication
```

## Advanced Usage

**Create worktree from existing branch:**
```bash
git worktree add ../worktrees/[name] [existing-branch]
```

**List all worktrees:**
```bash
git worktree list
```

**Remove a worktree:**
```bash
git worktree remove ../worktrees/[name]
```

**Prune stale worktree references:**
```bash
git worktree prune
```

## Best Practices

1. **Naming convention**: Use descriptive names like `feature/api-refactor` or `bugfix/auth-token`
2. **Location**: Store worktrees in a consistent location (e.g., `../worktrees/`)
3. **Cleanup**: Remove worktrees when done to avoid clutter
4. **Dependencies**: Run `npm install` or equivalent in each worktree as they have separate node_modules
5. **Shared .git**: Remember all worktrees share the same git history

## Common Use Cases

- **Feature development**: Work on a new feature while keeping main stable
- **Bug fixes**: Quick bug fix without disrupting current work
- **Code review**: Check out a PR in a separate worktree while keeping your work intact
- **Testing**: Test different branches simultaneously
- **Release preparation**: Prepare a release while continuing development

## Arguments

**Arguments provided:** {{arguments}}

If no feature name is provided, ask the user for a descriptive feature name.

---

Create isolated git worktrees for efficient parallel development without branch switching.
