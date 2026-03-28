#!/usr/bin/env bash
set -euo pipefail

LAT="26.2437"
LON="-80.2062"
TZ="America/New_York"
OVERRIDE_DIR="$HOME/.config/systemd/user"

# ── Calculate today's sunrise and sunset ──────────────────────────────────────
read -r SUNRISE SUNSET < <(python3 - <<EOF
from astral import LocationInfo
from astral.sun import sun
from datetime import date
import zoneinfo

loc = LocationInfo(latitude=$LAT, longitude=$LON, timezone="$TZ")
s = sun(loc.observer, date=date.today(), tzinfo=zoneinfo.ZoneInfo("$TZ"))
print(s['sunrise'].strftime('%Y-%m-%d %H:%M:%S'), s['sunset'].strftime('%Y-%m-%d %H:%M:%S'))
EOF
)

echo "Today: sunrise $SUNRISE, sunset $SUNSET"

# ── Write drop-in overrides ───────────────────────────────────────────────────
mkdir -p "$OVERRIDE_DIR/everforest-light.timer.d"
cat > "$OVERRIDE_DIR/everforest-light.timer.d/solar.conf" <<EOF
[Timer]
OnCalendar=
Persistent=false
OnCalendar=$SUNRISE
EOF

mkdir -p "$OVERRIDE_DIR/everforest-dark.timer.d"
cat > "$OVERRIDE_DIR/everforest-dark.timer.d/solar.conf" <<EOF
[Timer]
OnCalendar=
Persistent=false
OnCalendar=$SUNSET
EOF

systemctl --user daemon-reload
systemctl --user restart everforest-light.timer everforest-dark.timer

# ── Apply the correct theme for right now (important on boot) ─────────────────
NOW=$(date +%s)
SUNRISE_EPOCH=$(date -d "$SUNRISE" +%s)
SUNSET_EPOCH=$(date -d "$SUNSET" +%s)

if [[ $NOW -ge $SUNRISE_EPOCH && $NOW -lt $SUNSET_EPOCH ]]; then
    echo "Currently daytime — applying light theme"
    "$HOME/.local/bin/switch-theme.sh" light
else
    echo "Currently nighttime — applying dark theme"
    "$HOME/.local/bin/switch-theme.sh" dark
fi
