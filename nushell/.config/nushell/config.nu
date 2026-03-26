# ~/.config/nushell/config.nu
let _start = (date now)

# ─── Common env ────────────────────────────────────────────────────────────
$env.OPENAI_API_KEY      = '…'
$env.config = {
    show_banner: false, # Disable the bloated default banner
    buffer_editor: "nvim"
}

# ─── Load platform‐specific bits ────────────────────────────────────────────
# Note: source paths must be literal strings in Nushell
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

# ─── Minimal Startup Info ──────────────────────────────────────────────────
let _ms = (((date now) - $_start) / 1ms | math round --precision 2)
let _version = (version).version
print $"(ansi g)Nushell v($_version)(ansi reset)  (ansi y)load: ($_ms)ms(ansi reset)"

# ─── Starship Prompt ───────────────────────────────────────────────────────
use ~/.cache/starship/init.nu

