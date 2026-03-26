# ~/.config/nushell/macos.nu

# everything under your $HOME
$env.GITLAB_BASE = (dirs::home | path join "Gitlab")
$env.NEOVIM      = (dirs::home | path join ".config" "nvim")

# macOS‐only tweaks…
