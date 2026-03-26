# ~/.config/nushell/windows.nu
$env.DRIVE_PREFIX = "C:\\"
$env.GITLAB_DIR   = "Gitlab"
$env.GITLAB_BASE  = ($env.DRIVE_PREFIX | path join $env.GITLAB_DIR)
$env.NEOVIM      = ($env.USERPROFILE | path join "AppData" "Local" "nvim")
$env.WSL         = "WSL"

