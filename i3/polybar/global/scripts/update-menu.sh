#!/usr/bin/env bash

menu() {
    printf "1. Update System (pacman -Syu)\n"
    printf "2. Force Refresh & Update (pacman -Syyu)\n"
    printf "3. Exit\n"
}

main() {
    local theme_file="$HOME/.config/i3/polybar/themes/$(cat "$HOME/.config/i3/.theme")/rofi/launcher.rasi"

    local choice
    if [[ -f "$theme_file" ]]; then
        choice=$(menu | rofi -theme "$theme_file" -dmenu | cut -d. -f1)
    else
        choice=$(menu | rofi -dmenu | cut -d. -f1)
    fi

    case "$choice" in
        1)
            exo-open --launch TerminalEmulator -e bash -c "sudo pacman -Syu; exec bash"
            ;;
        2)
            exo-open --launch TerminalEmulator -e bash -c "sudo pacman -Syyu; exec bash"
            ;;
        3)
            exit 0
            ;;
    esac
}

main