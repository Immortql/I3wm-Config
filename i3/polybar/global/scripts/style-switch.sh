#!/usr/bin/env bash

theme=$(cat "$HOME/.config/i3/.theme")
theme_dir="$HOME/.config/i3/polybar/themes/$theme"
SDIR="$HOME/.config/i3/polybar/global/scripts"

# Launch Rofi
MENU="$(rofi -no-config -no-lazy-grab -sep "|" -dmenu -i -p '' \
-theme $theme_dir/rofi/styles.rasi \
<<< " Default| Nord| Gruvbox| Dark| Cherry|")"
            case "$MENU" in
				*Default) "$SDIR"/styles.sh --default ;;
				*Nord) "$SDIR"/styles.sh --nord ;;
				*Gruvbox) "$SDIR"/styles.sh --gruvbox ;;
				*Dark) "$SDIR"/styles.sh --dark ;;
				*Cherry) "$SDIR"/styles.sh --cherry ;;
            esac
