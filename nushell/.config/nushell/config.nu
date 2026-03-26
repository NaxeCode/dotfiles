# ~/.config/nushell/config.nu
let _start = (date now)

# ─── Common env ────────────────────────────────────────────────────────────
$env.EDITOR               = "nvim"
$env.VISUAL               = "nvim"
$env.OLLAMA_API_BASE      = "http://127.0.0.1:11434"
$env.OLLAMA_MODEL         = "qwen3-coder:30b"
$env.AIDER_MODEL          = "ollama_chat/qwen3-coder:30b"
$env.OPENAI_API_BASE      = $"($env.OLLAMA_API_BASE)/v1"
$env.OPENCODE_API_BASE    = "http://localhost:11434/v1"
$env.OPENCODE_MODEL       = "ollama/qwen3-coder:30b"
$env.OPENCODE_API_KEY     = "ollama"
$env.DEEPSEEK_API_KEY     = "sk-bc261ea7b02042bf8c6b02279c84ef9a"
$env.CLICOLOR             = 1
$env.OPENCODE_ENABLE_EXA  = 1

$env.config = {
    show_banner: false,
    buffer_editor: "nvim"
}

# ─── Load platform‐specific bits ────────────────────────────────────────────
if $nu.os-info.family == "windows" {
  source windows.nu
} else if $nu.os-info.family == "macos" {
  source macos.nu
} else {
  source linux.nu
}

# ─── Cross‐platform Aliases ──────────────────────────────────────────────────
alias gl  = cd $env.GITLAB_BASE
alias pp  = cd ($env.GITLAB_BASE | path join "personal")
alias nv  = cd $env.NEOVIM
alias pc  = cd ($env.GITLAB_BASE | path join "playcheckv3")
alias pcg = cd ($env.GITLAB_BASE | path join "playcheckv3" "GamePlugins")
alias pr  = cd ($env.GITLAB_BASE | path join "playreview")
alias qt  = cd ($env.GITLAB_BASE | path join "quantumsystem")
alias gg  = cd ($env.GITLAB_BASE | path join "quantumsystem" "Quantum.GameFiles" "Games")
alias tb  = cd ($env.GITLAB_BASE | path join "quantum.toolbox")
alias or  = cd ($env.GITLAB_BASE | path join "quantum.orion")
alias ph  = cd ($env.GITLAB_BASE | path join "phoenix")

# ─── TMUX Aliases ──────────────────────────────────────────────────────────
alias t   = tmux
alias ta  = tmux attach
alias tls = tmux ls

# ─── Minimal Startup Info ──────────────────────────────────────────────────
let _ms = (((date now) - $_start) / 1ms | math round --precision 2)
let _version = (version).version
print $"(ansi g)Nushell v($_version)(ansi reset)  (ansi y)load: ($_ms)ms(ansi reset)"

# ─── Starship Prompt ───────────────────────────────────────────────────────
use ~/.cache/starship/init.nu
