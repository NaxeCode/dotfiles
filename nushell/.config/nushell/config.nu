# ~/.config/nushell/config.nu

use std/dirs

# ─── Common env ────────────────────────────────────────────────────────────
$env.OPENAI_API_KEY      = '…'
$env.config.buffer_editor = "nvim"

# ─── Load platform‐specific bits ────────────────────────────────────────────
if $nu.platform == "windows" {
  source ~/.config/nushell/windows.nu
}
elif $nu.platform == "macos" {
  source ~/.config/nushell/macos.nu
}
else {
  source ~/.config/nushell/linux.nu
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
