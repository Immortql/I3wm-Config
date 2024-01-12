#!/bin/sh

function run {
  if ! pgrep -x $(basename $1 | head -c 15) 1>/dev/null;
  then
    $@&
  fi
}

run dunst -config ~/.config/i3/dunst/dunstrc &
run /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
run ~/.config/i3/scripts/wallpaper ~/.config/i3/wallpapers/ --bg-scale &
run ~/.config/i3/scripts/picom-toggle &

# Low battery notifier
run ~/.config/i3/scripts/check_battery.sh &
# Python version if you'd prefer it
#python ~/.config/qtile/scripts/check_battery.py & disown

# stop with that god damned bell sound! 3:<
run xset b off &
