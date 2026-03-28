#!/usr/bin/env bash
current=$(readlink "$HOME/.config/hypr/theme.conf")
if [[ "$current" == *dark* ]]; then
    exec "$HOME/.local/bin/switch-theme.sh" light
else
    exec "$HOME/.local/bin/switch-theme.sh" dark
fi
