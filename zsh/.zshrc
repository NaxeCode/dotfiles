export EDITOR="nvim"
export VISUAL="nvim"
export PATH="$HOME/.local/bin:$PATH"
export OLLAMA_API_BASE="http://127.0.0.1:11434"
export OLLAMA_MODEL="qwen3-coder:30b"
export AIDER_MODEL="ollama_chat/qwen3-coder:30b"
export OPENAI_API_BASE="$OLLAMA_API_BASE/v1"
export OPENCODE_API_BASE="http://localhost:11434/v1"
export OPENCODE_MODEL="ollama/qwen3-coder:30b"
export OPENCODE_API_KEY="ollama"
if command -v fd >/dev/null 2>&1; then
  _fd_bin="fd"
elif command -v fdfind >/dev/null 2>&1; then
  _fd_bin="fdfind"
else
  _fd_bin=""
fi
if [ -n "$_fd_bin" ]; then
  export FZF_DEFAULT_COMMAND="$_fd_bin --type f --hidden --follow --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="$_fd_bin --type d --hidden --follow --exclude .git"
fi
unset _fd_bin

# Better defaults when tools are present.
if command -v eza >/dev/null 2>&1; then
  alias ll='eza -la --group-directories-first --git'
  alias la='eza -a --group-directories-first'
  alias tree='eza --tree'
fi
if command -v colorls >/dev/null 2>&1; then
  alias ls='colorls --dark --sd'
fi
alias g='git status'
alias ga='git add'
alias gc='git commit -m'
if command -v batcat >/dev/null 2>&1; then
  alias cat='batcat --paging=never --style=plain'
elif command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never --style=plain'
fi
if command -v rg >/dev/null 2>&1; then
  alias grep='rg'
fi
if command -v fd >/dev/null 2>&1; then
  alias find='fd'
elif command -v fdfind >/dev/null 2>&1; then
  alias find='fdfind'
  alias fd='fdfind'
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  c() {
    z "$@"
  }
fi
if command -v yazi >/dev/null 2>&1; then
  y() {
    local tmp cwd
    tmp="$(mktemp -t yazi-cwd.XXXXXX)"
    yazi "$@" --cwd-file="$tmp"
    cwd="$(command cat -- "$tmp")"
    if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
  }
fi
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm use default --silent

### EVERFOREST START ###
# Everforest shell coloring.
export CLICOLOR=1
export LSCOLORS='exfxcxdxbxegedabagacad'

# Keep starship if present; otherwise use a simple Everforest prompt.
if ! command -v starship >/dev/null 2>&1; then
  PROMPT='%F{#a7c080}%n%f@%F{#83c092}%m%f %F{#7fbbb3}%~%f %# '
fi
### EVERFOREST END ###

### EVERFOREST PHASE1 START ###
# Everforest fzf palette
export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --border --color=bg+:#3d484d,bg:#2d353b,spinner:#a7c080,hl:#dbbc7f,fg:#d3c6aa,header:#83c092,info:#7fbbb3,pointer:#a7c080,marker:#e69875,fg+:#fff9e8,prompt:#a7c080,hl+:#e67e80"
### EVERFOREST PHASE1 END ###

# llama.cpp aliases
alias llama="~/llama.cpp/build/bin/llama-server -m ~/models/qwen35-27b/Qwen_Qwen3.5-27B-Q4_K_M.gguf --host 127.0.0.1 --port 8080 -ngl 999 -c 49152 --temp 0.2 --top-p 0.9"

# opencode settings
export OPENCODE_ENABLE_EXA=1
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# DeepSeek API Key
export DEEPSEEK_API_KEY="sk-bc261ea7b02042bf8c6b02279c84ef9a"

# OpenClaw Completion
source "/home/naxe/.openclaw/completions/openclaw.zsh"
