#!/bin/bash
# Claude Code Status Line Script

# Get project name from directory
project=$(basename "$(pwd)")

# Get git branch (if in git repo)
branch=$(git branch --show-current 2>/dev/null)

# Get uncommitted changes count
if [ -n "$branch" ]; then
  changes=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  if [ "$changes" -gt 0 ]; then
    changes_str=" *$changes"
  else
    changes_str=""
  fi

  # Check ahead/behind remote
  ahead_behind=$(git rev-list --left-right --count HEAD...@{upstream} 2>/dev/null)
  if [ -n "$ahead_behind" ]; then
    ahead=$(echo "$ahead_behind" | awk '{print $1}')
    behind=$(echo "$ahead_behind" | awk '{print $2}')
    sync=""
    [ "$ahead" -gt 0 ] && sync=" ↑$ahead"
    [ "$behind" -gt 0 ] && sync="$sync ↓$behind"
  else
    sync=""
  fi
else
  branch="-"
  changes_str=""
  sync=""
fi

# Get runtime version based on project type
runtime=""
if [ -f "package.json" ]; then
  runtime=" | node $(node -v 2>/dev/null || echo '?')"
elif [ -f "pyproject.toml" ] || [ -f "requirements.txt" ]; then
  runtime=" | py$(python3 --version 2>/dev/null | awk '{print $2}' || echo '?')"
fi

# Output status line
echo "$project | $branch$changes_str$sync$runtime"
