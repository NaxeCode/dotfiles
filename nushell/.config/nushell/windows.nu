# ~/.config/nushell/windows.nu

# Enable when on windows
# use ~/.cache/starship/init.nu

# drive + base
$env.DRIVE_PREFIX = "C:\\"
$env.GITLAB_DIR   = "Gitlab"
$env.GITLAB_BASE  = ($env.DRIVE_PREFIX | path join $env.GITLAB_DIR)

# per‐machine paths
$env.NEOVIM = (dirs::home | path join "AppData" "Local" "nvim")
$env.WSL    = "WSL"

# any other Windows‐only vars…
