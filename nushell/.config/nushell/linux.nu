# ~/.config/nushell/linux.nu

# same as macOS, but feel free to diverge if needed
$env.GITLAB_BASE = (dirs::home | path join "Gitlab")
$env.NEOVIM      = (dirs::home | path join ".config" "nvim")

# Linux‐only tweaks…
