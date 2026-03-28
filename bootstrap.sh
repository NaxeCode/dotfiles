#!/usr/bin/env bash
# =============================================================================
# NaxeCode Dotfiles Bootstrap
# Recreates the full desktop setup on a fresh Arch Linux install.
#
# Usage:
#   1. Clone the dotfiles repo:
#        git clone git@github.com:NaxeCode/dotfiles.git ~/dotfiles
#   2. Run this script:
#        bash ~/dotfiles/bootstrap.sh
# =============================================================================

set -euo pipefail

DOTFILES="$HOME/dotfiles"
CHEZMOI_REPO="git@github.com:NaxeCode/dotfiles-chezmoi.git"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
info()  { echo -e "${GREEN}==>${NC} $*"; }
warn()  { echo -e "${YELLOW}[!]${NC} $*"; }
pause() { echo -e "${YELLOW}[>]${NC} $* — press Enter to continue or Ctrl-C to abort."; read -r; }

# ── 1. Packages ───────────────────────────────────────────────────────────────
info "Installing packages..."

PACKAGES=(
    # Hyprland
    hyprland hyprpolkitagent
    xdg-desktop-portal-hyprland xdg-desktop-portal-gtk

    # Bar / launcher / notifications
    waybar wofi dunst

    # Terminal & shell
    ghostty nushell

    # Fonts & icons
    ttf-jetbrains-mono-nerd papirus-icon-theme

    # Editor
    neovim

    # CLI tools
    starship zoxide yazi bat eza fd ripgrep fzf git tmux

    # Wayland utilities
    wl-clipboard cliphist grim slurp playerctl

    # Audio
    pipewire pipewire-pulse wireplumber

    # Network
    networkmanager network-manager-applet

    # File manager
    thunar

    # Neovim build deps (blink.cmp requires cargo)
    cargo nodejs npm make

    # Theme system
    python-astral
)

sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

# ── 2. Dotfiles repo ──────────────────────────────────────────────────────────
if [[ ! -d "$DOTFILES" ]]; then
    info "Cloning dotfiles..."
    git clone git@github.com:NaxeCode/dotfiles.git "$DOTFILES"
else
    info "dotfiles already present at $DOTFILES"
fi

# ── 3. Chezmoi ────────────────────────────────────────────────────────────────
if ! command -v chezmoi &>/dev/null; then
    info "Installing chezmoi..."
    sudo pacman -S --needed --noconfirm chezmoi
fi

if [[ ! -d "$(chezmoi source-path 2>/dev/null)" ]]; then
    info "Initialising chezmoi from $CHEZMOI_REPO..."
    chezmoi init "$CHEZMOI_REPO"
fi

warn "About to run 'chezmoi apply'."
warn "This will create symlinks for: hypr, waybar, wofi, dunst, ghostty, nushell,"
warn "starship, yazi, tmux, and the theme scripts in ~/.local/bin/."
warn "Review 'chezmoi diff' first if you want to inspect changes."
pause "Ready to apply chezmoi"

chezmoi apply
info "chezmoi applied."

# ── 4. Neovim (kickstart) ─────────────────────────────────────────────────────
# chezmoi handles this via .chezmoiexternal.toml — nvim is cloned automatically.
info "Neovim config managed by chezmoi external (NaxeCode/kickstart.nvim)."

# ── 5. Systemd timers ────────────────────────────────────────────────────────
info "Setting up systemd user timers..."

mkdir -p "$HOME/.config/systemd/user"
cp "$DOTFILES/systemd/.config/systemd/user/"*.{service,timer} \
    "$HOME/.config/systemd/user/"

systemctl --user daemon-reload
systemctl --user enable --now \
    everforest-dark.timer \
    everforest-light.timer \
    solar-schedule.timer

info "Timers enabled."

# ── 6. Runtime theme files ───────────────────────────────────────────────────
info "Initialising dark theme (creates runtime symlinks)..."
bash "$HOME/.local/bin/switch-theme.sh" dark

# ── 7. Solar schedule ────────────────────────────────────────────────────────
info "Running solar scheduler for today's sunrise/sunset times..."
bash "$HOME/.local/bin/solar-schedule.sh"

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}Bootstrap complete.${NC}"
echo ""
echo "Remaining manual steps:"
echo "  1. Set GTK theme:   gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'"
echo "  2. Set cursor:      gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'"
echo "  3. Log out and back in (or reboot) to start a clean Hyprland session."
echo "  4. Inside Neovim, run :Lazy sync to install plugins."
