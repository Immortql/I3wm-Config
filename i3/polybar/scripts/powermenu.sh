#!/usr/bin/env bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

#########################################
# Modified By: Cadehlinha               #
# Github: https://github.com/Cadehlinha #
#########################################

dir="~/.config/i3/polybar/scripts/rofi"
uptime=$(uptime -p | sed -e 's/up //g')

rofi_command="rofi -no-config -theme $dir/powermenu.rasi"

# Options
shutdown=" Shutdown"
reboot=" Restart"
lock=" Lock"
suspend=" Sleep"
logout=" Logout"

# Confirmation
confirm_exit() {
	rofi -dmenu\
		-no-config\
        -i\
		-no-fixed-num-lines\
		-p "Are You Sure? : "\
		-theme $dir/confirm.rasi
}

# Message
msg() {
	rofi -no-config -theme "$dir/message.rasi" -e "Available Options  -  yes / y / no / n"
}

# Function to detect the user's window manager session
detect_session() {
    # Check if the specified process is running
    is_running() {
        pgrep -u "$USER" -x "$1" > /dev/null
    }

    # Check the window manager sessions in order of priority
    if is_running "i3"; then
        echo "i3"
    elif is_running "openbox"; then
        echo "openbox"
    elif is_running "bspwm"; then
        echo "bspwm"
    elif is_running "xmonad"; then
        echo "xmonad"
    elif is_running "dwm"; then
        echo "dwm"
    elif is_running "qtile"; then
        echo "qtile"
    elif is_running "herbstluftwm"; then
        echo "herbstluftwm"
    else
        echo "unknown"
    fi
}

# Function to perform logout based on the specified window manager session
perform_logout() {
    case $1 in
        "i3")
            # For i3, use i3-msg exit
            i3-msg exit ;;
        "openbox")
            # For Openbox, use openbox --exit
            openbox --exit ;;
        "bspwm")
            # For bspwm, use bspc quit
            bspc quit ;;
        "xmonad")
            # For xmonad, use xmonad --recompile && xmonad --restart
            xmonad --recompile && xmonad --restart ;;
        "dwm")
            # For dwm, use pkill dwm
            pkill dwm ;;
        "qtile")
            # For qtile, use qtile cmd-obj -o cmd -f shutdown
            qtile cmd-obj -o cmd -f shutdown ;;
        "herbstluftwm")
            # For herbstluftwm, use herbstclient quit
            herbstclient quit ;;
        *)
            # For other sessions, kill the user's processes
            pkill -KILL -u "$USER" ;;
    esac
}

# Variable passed to rofi
options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

chosen="$(echo -e "$options" | $rofi_command -p "Uptime: $uptime" -dmenu -selected-row 0)"
case $chosen in
    $shutdown)
		ans=$(confirm_exit &)
		if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
			systemctl poweroff
		elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
			exit 0
        else
			msg
        fi
        ;;
    $reboot)
		ans=$(confirm_exit &)
		if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
			systemctl reboot
		elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
			exit 0
        else
			msg
        fi
        ;;
    $lock)
		if [[ -f /usr/bin/i3lock ]]; then
			~/.config/i3/scripts/lock
		fi
        ;;
    $suspend)
		ans=$(confirm_exit &)
		if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
			mpc -q pause
			amixer set Master mute
			systemctl suspend
		elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
			exit 0
        else
			msg
        fi
        ;;
    $logout)
		ans=$(confirm_exit &)
		session=$(detect_session)
		if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
			#i3-msg exit
        	perform_logout "$session"
		elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
			exit 0
        else
			msg
        fi
        ;;
esac
