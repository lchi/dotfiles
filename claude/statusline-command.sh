#!/usr/bin/env bash
# Claude Code status line - path, git, model, context bar, 5h rate limit

input=$(cat)

# --- Path ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
# Collapse $HOME to ~
home="$HOME"
display_cwd="${cwd/#$home/~}"

# --- Git branch (skip optional locks) ---
git_branch=""
if [ -d "$cwd/.git" ] || git -C "$cwd" rev-parse --git-dir --no-optional-locks >/dev/null 2>&1; then
  git_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
fi

# --- Model ---
model=$(echo "$input" | jq -r '.model.display_name // ""')

# --- Context window bar ---
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx_part=""
if [ -n "$used_pct" ]; then
  used_int=$(printf '%.0f' "$used_pct")
  # 10-cell fill bar
  filled=$(( used_int / 10 ))
  empty=$(( 10 - filled ))
  bar=""
  for i in $(seq 1 $filled); do bar="${bar}█"; done
  for i in $(seq 1 $empty);  do bar="${bar}░"; done
  # Color: green <50, yellow <80, red >=80
  if [ "$used_int" -lt 50 ]; then
    ctx_color="\033[32m"
  elif [ "$used_int" -lt 80 ]; then
    ctx_color="\033[33m"
  else
    ctx_color="\033[31m"
  fi
  ctx_part="${ctx_color}[${bar}]\033[0m"
fi

# --- Rate limits with reset times ---
rate_part=""

five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
if [ -n "$five_pct" ]; then
  five_int=$(printf '%.0f' "$five_pct")
  if [ "$five_int" -lt 50 ]; then
    five_color="\033[0m"
  elif [ "$five_int" -lt 75 ]; then
    five_color="\033[33m"
  else
    five_color="\033[31m"
  fi
  if [ -n "$five_reset" ]; then
    now=$(date +%s)
    diff=$(( five_reset - now ))
    if [ "$diff" -le 0 ]; then
      reset_str="now"
    elif [ "$diff" -lt 3600 ]; then
      reset_str="$(( diff / 60 ))m"
    else
      reset_str="$(( diff / 3600 ))h$(( (diff % 3600) / 60 ))m"
    fi
    rate_part="${five_color}5h:${five_int}% (↺${reset_str})\033[0m"
  else
    rate_part="${five_color}5h:${five_int}%\033[0m"
  fi
fi

# --- Assemble ---
# Left: path  (branch)
printf "\033[36m%s\033[0m" "$display_cwd"

if [ -n "$git_branch" ]; then
  printf " \033[35m(%s)\033[0m" "$git_branch"
fi

# Separator
if [ -n "$model" ] || [ -n "$ctx_part" ] || [ -n "$rate_part" ]; then
  printf " \033[38;5;240m|\033[0m"
fi

if [ -n "$model" ]; then
  printf " \033[38;5;240m%s\033[0m" "$model"
fi

if [ -n "$ctx_part" ]; then
  printf " %b" "$ctx_part"
fi

if [ -n "$rate_part" ]; then
  printf " %b" "$rate_part"
fi

printf "\n"
