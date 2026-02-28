#!/usr/bin/env bash
set -euo pipefail

# shows: [cwd/worktree (git_branch_name)] [model] [remaining_context] [session_cost]

input=$(cat)

# Extract values
MODEL=$(echo "$input" | jq -r '.model.display_name // "?"')
CWD=$(echo "$input" | jq -r '.workspace.current_dir // "."')
PROJECT_DIR=$(echo "$input" | jq -r '.workspace.project_dir // "."')
REMAINING=$(echo "$input" | jq -r '.context_window.remaining_percentage // 100')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')

# Detect git worktree vs regular directory
WORKTREE_NAME=""
GIT_BRANCH=""
cd "$CWD" 2>/dev/null
if git rev-parse --is-inside-work-tree &>/dev/null; then
    WORKTREE_PATH=$(git rev-parse --show-toplevel 2>/dev/null)
    GIT_COMMON_DIR=$(git rev-parse --git-common-dir 2>/dev/null)
    GIT_BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null || "")

    # Linked worktree detection
    if [[ "$GIT_COMMON_DIR" != ".git" && "$GIT_COMMON_DIR" != "$WORKTREE_PATH/.git" ]]; then
        WORKTREE_NAME=$(basename "$WORKTREE_PATH")
    fi
fi

BRANCH_DISPLAY=""
if [[ -n "$GIT_BRANCH" ]]; then
    BRANCH_DISPLAY=" ($GIT_BRANCH)"
fi

if [[ -n "$WORKTREE_NAME" ]]; then
    DIR_DISPLAY="ϟ ${WORKTREE_NAME}${BRANCH_DISPLAY}"
else
    DIR_DISPLAY="✦ ${CWD##*/}${BRANCH_DISPLAY}"
fi

# Round remaining percentage
REMAINING_INT=$(printf "%.0f" "$REMAINING")

# Format cost to 2 decimal places
COST_FORMATTED=$(printf "%.2f" "$COST")

# Assemble the statusline
echo "${DIR_DISPLAY} · ${MODEL} · ${REMAINING_INT}% · \$${COST_FORMATTED}"
