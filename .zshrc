# ============================================================
# .zshrc — sane defaults, dark theme
# ============================================================

# --- History -------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS       # skip duplicates
setopt HIST_IGNORE_SPACE      # skip commands prefixed with a space
setopt HIST_VERIFY            # confirm before running history expansion
setopt SHARE_HISTORY          # share history across sessions
setopt INC_APPEND_HISTORY     # write immediately, not on shell exit

# --- Options -------------------------------------------------
setopt AUTO_CD                # cd by typing a directory name
setopt CORRECT                # suggest typo corrections
setopt NO_BEEP                # silence the bell
setopt EXTENDED_GLOB          # extended glob patterns
setopt GLOB_DOTS              # include dotfiles in glob results

# --- Completion ----------------------------------------------
autoload -Uz compinit && compinit
setopt COMPLETE_IN_WORD       # complete from within a word
setopt MENU_COMPLETE          # auto-select the first completion
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # case-insensitive completion
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches --%f'

# --- Colors --------------------------------------------------
# 256-color dark palette (Catppuccin Mocha-inspired)
export CLICOLOR=1
export LSCOLORS="ExGxFxdxCxDxDxaccxaeex"   # BSD ls (macOS default)
# For GNU ls / gls:
export LS_COLORS="di=1;34:ln=1;36:so=1;35:pi=33:ex=1;32:bd=34;46:cd=34;43:su=30;41:sg=30;46:ow=34:tw=34"

# Grep highlight
export GREP_COLOR='1;32'
export GREP_COLORS="mt=1;32"

# Less colors (man pages, etc.)
export LESS_TERMCAP_mb=$'\e[1;35m'    # begin bold
export LESS_TERMCAP_md=$'\e[1;34m'    # begin bold (dark blue)
export LESS_TERMCAP_me=$'\e[0m'       # end mode
export LESS_TERMCAP_se=$'\e[0m'       # end standout
export LESS_TERMCAP_so=$'\e[1;33m'    # standout (yellow)
export LESS_TERMCAP_ue=$'\e[0m'       # end underline
export LESS_TERMCAP_us=$'\e[4;36m'    # underline (cyan)
export LESS="-R --use-color"

# --- Prompt --------------------------------------------------
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats ' %F{magenta}(%b)%f'
zstyle ':vcs_info:*' enable git

precmd() { vcs_info }
setopt PROMPT_SUBST

# Dark theme prompt: user@host  ~/path  (branch)
# green user, dim slash, blue path, magenta branch, white $
PROMPT='%F{green}%n%f%F{240}@%f%F{blue}%m%f %F{cyan}%~%f${vcs_info_msg_0_} %F{white}%(!.#.$)%f '

# Right prompt: exit code when non-zero
RPROMPT='%(?.%F{240}✓%f.%F{red}✗ %?%f)'

# --- Aliases — navigation ------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# --- Aliases — ls --------------------------------------------
# Use `gls` (from `brew install coreutils`) if available, else fall back to BSD ls
if command -v gls &>/dev/null; then
  alias ls='gls --color=auto --group-directories-first -h'
else
  alias ls='ls --color=auto -h' 2>/dev/null || alias ls='ls -Gh'
fi
alias ll='ls -lF'
alias la='ls -lAF'
alias l='ls -CF'

# --- Aliases — git -------------------------------------------
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'

# --- Aliases — utilities -------------------------------------
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias cp='cp -i'              # confirm overwrites
alias mv='mv -i'
alias mkdir='mkdir -pv'       # create parents, verbose
alias reload='source ~/.zshrc'

# --- Editor --------------------------------------------------
export EDITOR='vim'
export VISUAL="$EDITOR"

# --- PATH ----------------------------------------------------
# Homebrew (Apple Silicon)
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
# Homebrew (Intel)
if [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# User-local binaries
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# --- Key Bindings --------------------------------------------
bindkey -e                    # emacs-style line editing
bindkey '^[[A' history-search-backward   # up arrow — search history
bindkey '^[[B' history-search-forward    # down arrow
bindkey '^[[1;5C' forward-word           # ctrl+right
bindkey '^[[1;5D' backward-word          # ctrl+left

# --- Misc ----------------------------------------------------
# Avoid accidental ctrl+d logout
setopt IGNORE_EOF

# Word chars (exclude / so ctrl+w stops at path components)
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
