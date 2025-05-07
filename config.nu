# config.nu
#
# Installed by:
# version = "0.101.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

use std/dirs

use ~/.cache/starship/init.nu

$env.OPENAI_API_KEY = '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'

# Editor to use
$env.config.buffer_editor = "nvim"

# Base directory configuration
$env.DRIVE_PREFIX = "C:\\"
$env.GITLAB_DIR = "Gitlab"
$env.GITLAB_BASE = ($env.DRIVE_PREFIX | path join $env.GITLAB_DIR)

# Project directories - using the exact names you specified
$env.GITLAB = ""
$env.PERSONAL = "personal"
$env.NEOVIM = "Users\\aladdina\\AppData\\Local\\nvim"
$env.WSL = "WSL"
$env.PLAYCHECK = "playcheckv3"
$env.PLAYCHECK_GAMES = "GamePlugins"
$env.PLAYREVIEW = "playreview"
$env.QUANTUM = "quantumsystem"
$env.QUANTUM_GAMES = "Quantum.GameFiles\\Games"
$env.TOOLBOX = "quantum.toolbox"
$env.ORION = "quantum.orion"
$env.PHOENIX = "phoenix"

# Corrected aliases matching your specifications
alias gl = cd $env.GITLAB_BASE
alias pp = cd $"($env.GITLAB_BASE)\\($env.PERSONAL)"
alias nv = cd $"($env.DRIVE_PREFIX)\\($env.NEOVIM)"
alias _wsl = cd $"($env.DRIVE_PREFIX)\\($env.WSL)"
alias pc = cd $"($env.GITLAB_BASE)\\($env.PLAYCHECK)"
alias pcg = cd $"($env.GITLAB_BASE)\\($env.PLAYCHECK)\\($env.PLAYCHECK_GAMES)"
alias pr = cd $"($env.GITLAB_BASE)\\($env.PLAYREVIEW)"
alias qt = cd $"($env.GITLAB_BASE)\\($env.QUANTUM)"
alias gg = cd $"($env.GITLAB_BASE)\\($env.QUANTUM)\\($env.QUANTUM_GAMES)"
alias tb = cd $"($env.GITLAB_BASE)\\($env.TOOLBOX)"
alias or = cd $"($env.GITLAB_BASE)\\($env.ORION)"
alias ph = cd $"($env.GITLAB_BASE)\\($env.PHOENIX)"
