#!/usr/bin/env bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

theme=$(cat "$HOME/.config/i3/.theme")
dir=~/.config/i3/polybar/themes/$theme/rofi
launcher_file=$dir/powermenu.rasi
uptime=$(uptime -p | sed -e 's/up //g')

if [[ -f "$launcher_file" ]]; then
    rofi_command="rofi -no-config -theme $dir/powermenu.rasi"
else
    rofi_command="rofi -no-config"
fi

# Options
shutdown=" Shutdown"
reboot=" Restart"
lock=" Lock"
suspend=" Sleep"
logout=" Logout"

# Confirmation
confirm_exit() {
    if [[ -f "$launcher_file" ]]; then
	    rofi -dmenu\
            -no-config\
		    -i\
		    -no-fixed-num-lines\
		    -p "Are You Sure? : "\
		    -theme $dir/confirm.rasi
    else
	    rofi -dmenu\
            -no-config\
		    -i\
		    -no-fixed-num-lines\
		    -p "Are You Sure? : "
    fi
}

# Message
msg() {
    if [[ -f "$launcher_file" ]]; then
	    rofi -no-config -theme "$dir/message.rasi" -e "Available Options  -  yes / y / no / n"
    else
        rofi -no-config -e "Available Options  -  yes / y / no / n"
    fi
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
		~/.config/i3/scripts/lock
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
		if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
			if [[ "$DESKTOP_SESSION" == "Openbox" ]]; then
				openbox --exit
			elif [[ "$DESKTOP_SESSION" == "bspwm" ]]; then
				bspc quit
			elif [[ "$DESKTOP_SESSION" == "i3" ]]; then
				i3-msg exit
			fi
		elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
			exit 0
        else
			msg
        fi
        ;;
esac
