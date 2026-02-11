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
else
  branch="-"
  changes_str=""
fi

# Get current time
time=$(date +"%H:%M")

# Output status line
echo "$project | $branch$changes_str | $time"
