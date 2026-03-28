# NaxeCode Dotfiles

Everforest Medium theme system for Arch Linux / Hyprland.

## Repos

| Repo | Purpose |
|---|---|
| [dotfiles](https://github.com/NaxeCode/dotfiles) | Config files, organised by app |
| [dotfiles-chezmoi](https://github.com/NaxeCode/dotfiles-chezmoi) | Chezmoi source — manages symlinks and tracked files |
| [kickstart.nvim](https://github.com/NaxeCode/kickstart.nvim) | Neovim config (pulled automatically by chezmoi) |

## Fresh install

```bash
git clone git@github.com:NaxeCode/dotfiles.git ~/dotfiles
bash ~/dotfiles/bootstrap.sh
```

## What's managed

| App | Location | Method |
|---|---|---|
| Hyprland | `hypr/` | symlink via chezmoi |
| Waybar | `waybar/` | symlink via chezmoi |
| Wofi | `wofi/` | symlink via chezmoi |
| Dunst | `dunst/` | symlink via chezmoi |
| Ghostty | `ghostty/` | symlink via chezmoi |
| NuShell | `nushell/` | symlink via chezmoi |
| Starship | `starship/` | symlink via chezmoi |
| Yazi | (external) | symlink via chezmoi |
| Tmux | `tmux/` | symlink via chezmoi |
| Neovim | external git repo | chezmoi `.chezmoiexternal.toml` |
| Theme scripts | `scripts/` | symlink via chezmoi |
| Systemd units | `systemd/` | copied + enabled by bootstrap |

## Theme system

Dynamic light/dark switching at sunrise/sunset (Margate, FL) via systemd timers.

- `switch-theme.sh [dark|light]` — switches all components at once
- `toggle-theme.sh` — toggles current theme (`SUPER+SHIFT+T` in Hyprland)
- `solar-schedule.sh` — recalculates today's sunrise/sunset times

**Components switched:** Hyprland, Waybar, Wofi, Dunst, Ghostty, Neovim, NuShell, icons (Papirus-Dark/Light)

## Not tracked (intentional)

- `~/.config/systemd/user/timers.target.wants/` — managed by systemd at runtime
- `~/.config/hypr/theme.conf` — runtime symlink set by switch-theme.sh
- `~/.config/waybar/theme.css` — runtime symlink
- `~/.config/wofi/theme.css` — runtime symlink
- `~/.config/dunst/dunstrc` — runtime symlink
- `~/.config/ghostty/theme.conf` — runtime file
- `~/.config/theme` — runtime state file
- `nushell/history.txt`, `nushell/secrets.nu` — local only
