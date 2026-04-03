#!/usr/bin/env bash
set -euo pipefail

# shows: [cwd/worktree (git_branch_name [±] [⇣])] [model] [remaining_context] [session_cost]

input=$(cat)

# Extract values
MODEL=$(echo "$input" | jq -r '.model.display_name // "?"')
CWD=$(echo "$input" | jq -r '.workspace.current_dir // "."')
PROJECT_DIR=$(echo "$input" | jq -r '.workspace.project_dir // "."')
REMAINING=$(echo "$input" | jq -r '.context_window.remaining_percentage // 100')
CTX_USED=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // empty')
CTX_TOTAL=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')

# Detect git worktree vs regular directory
WORKTREE_NAME=""
GIT_BRANCH=""
GIT_DIRTY=""
GIT_BEHIND=""
cd "$CWD" 2>/dev/null
if git rev-parse --is-inside-work-tree &>/dev/null; then
    WORKTREE_PATH=$(git rev-parse --show-toplevel 2>/dev/null)
    GIT_COMMON_DIR=$(git rev-parse --git-common-dir 2>/dev/null)
    GIT_BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null || "")

    # Dirty check: any uncommitted changes (mirrors fish _git_is_dirty)
    if git status -s --ignore-submodules=dirty 2>/dev/null | grep -q .; then
        GIT_DIRTY="±"
    fi

    # Behind check: local branch is behind its upstream
    if [[ -n "$GIT_BRANCH" ]]; then
        UPSTREAM=$(git rev-parse --abbrev-ref "@{upstream}" 2>/dev/null || true)
        if [[ -n "$UPSTREAM" ]]; then
            BEHIND_COUNT=$(git rev-list --count HEAD.."$UPSTREAM" 2>/dev/null || echo 0)
            if [[ "$BEHIND_COUNT" -gt 0 ]]; then
                GIT_BEHIND="⇣${BEHIND_COUNT}"
            fi
        fi
    fi

    # Linked worktree detection
    if [[ "$GIT_COMMON_DIR" != ".git" && "$GIT_COMMON_DIR" != "$WORKTREE_PATH/.git" ]]; then
        WORKTREE_NAME=$(basename "$WORKTREE_PATH")
    fi
fi

BRANCH_DISPLAY=""
if [[ -n "$GIT_BRANCH" ]]; then
    GIT_STATE=""
    [[ -n "$GIT_DIRTY" ]] && GIT_STATE="${GIT_STATE}${GIT_DIRTY}"
    [[ -n "$GIT_BEHIND" ]] && GIT_STATE="${GIT_STATE} ${GIT_BEHIND}"
    if [[ -n "$GIT_STATE" ]]; then
        BRANCH_DISPLAY=" (${GIT_BRANCH} ${GIT_STATE})"
    else
        BRANCH_DISPLAY=" (${GIT_BRANCH})"
    fi
fi

if [[ -n "$WORKTREE_NAME" ]]; then
    DIR_DISPLAY="ϟ ${WORKTREE_NAME}${BRANCH_DISPLAY}"
else
    DIR_DISPLAY="✦ ${CWD##*/}${BRANCH_DISPLAY}"
fi

# Round remaining percentage
REMAINING_INT=$(printf "%.0f" "$REMAINING")

# Format context window size (e.g. 200k)
CTX_DISPLAY=""
if [[ -n "$CTX_TOTAL" ]]; then
    CTX_TOTAL_K=$(printf "%.0f" "$(echo "$CTX_TOTAL / 1000" | bc -l)")
    if [[ -n "$CTX_USED" ]]; then
        CTX_USED_K=$(printf "%.0f" "$(echo "$CTX_USED / 1000" | bc -l)")
        CTX_DISPLAY=" (${CTX_USED_K}k/${CTX_TOTAL_K}k)"
    else
        CTX_DISPLAY=" (${CTX_TOTAL_K}k)"
    fi
fi

# Format cost to 2 decimal places
COST_FORMATTED=$(printf "%.2f" "$COST")

# Assemble the statusline
echo "${DIR_DISPLAY} · ${MODEL} · ${REMAINING_INT}%${CTX_DISPLAY} · \$${COST_FORMATTED}"
