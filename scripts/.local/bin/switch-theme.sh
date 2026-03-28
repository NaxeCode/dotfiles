#!/usr/bin/env bash

THEME=$1

if [[ "$THEME" != "dark" && "$THEME" != "light" ]]; then
    echo "Usage: $0 [dark|light]"
    exit 1
fi

echo "Switching to Everforest $THEME..."

# Theme state file (read by Neovim, NuShell, etc.)
echo "$THEME" > "$HOME/.config/theme"

# Hyprland
ln -sf "$HOME/.config/hypr/themes/everforest-$THEME.conf" "$HOME/.config/hypr/theme.conf"
hyprctl reload

# Waybar
ln -sf "$HOME/.config/waybar/themes/everforest-$THEME.css" "$HOME/.config/waybar/theme.css"
killall -SIGUSR2 waybar

# Wofi
ln -sf "$HOME/.config/wofi/themes/everforest-$THEME.css" "$HOME/.config/wofi/theme.css"

# Ghostty — update theme.conf, then send SIGUSR2 to trigger reload
cp "$HOME/.config/ghostty/themes/everforest-$THEME.conf" "$HOME/.config/ghostty/theme.conf"
sed -i "s/^# active-theme = .*$/# active-theme = $THEME/" "$HOME/.config/ghostty/config"
pkill -USR2 ghostty 2>/dev/null || true

# Dunst
ln -sf "$HOME/.config/dunst/dunstrc-$THEME" "$HOME/.config/dunst/dunstrc"
killall dunst
dunst &

# Icons
if [[ "$THEME" == "dark" ]]; then
    gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
else
    gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Light'
fi

# Neovim — call global theme switcher on all running instances
for socket in /run/user/$(id -u)/nvim.*.0; do
    [[ -S "$socket" ]] && nvim --server "$socket" \
        --remote-expr "v:lua.switch_everforest_theme('$THEME')" \
        2>/dev/null || true
done

echo "Theme update complete."
