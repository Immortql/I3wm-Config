#!/usr/bin/env bash

theme=$(cat "$HOME/.config/i3/.theme")
launcher_file=~/.config/i3/polybar/themes/$theme/rofi/launcher.rasi

if [[ -f "$launcher_file" ]]; then
    rofi -no-config -no-lazy-grab -show drun -modi drun -theme $launcher_file
else
    rofi -no-config -no-lazy-grab -show drun -modi drun
fi
