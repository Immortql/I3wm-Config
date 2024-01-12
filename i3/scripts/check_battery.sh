#!/bin/bash

#################################
# Created by: Cadehlinha        #
# https://github.com/Cadehlinha #
#################################

# Function to send notification using notify-send
send_notification() {
    local urgency=$1
    local timeout=$2
    local message=$3
    notify-send -u "$urgency" -t "$timeout" "Battery Status" "$message"
}

# Function to check battery capacity
check_battery_capacity() {
    capacity=$(cat /sys/class/power_supply/BAT0/capacity)
    state=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state | awk '{print $2}')

    if [[ $state != $prev_state ]]; then
        send_notification "normal" "5000" "Battery is now $state"
        prev_state=$state
    fi

    if [[ $capacity -lt 80 && $capacity -ge 50 && $low_notified -eq 0 ]]; then
        send_notification "normal" "8000" "Battery is low: $capacity%"
        low_notified=1
        crit_low_notified=0  # Reset critically low notification variable
    elif [[ $capacity -lt 50 && $crit_low_notified -eq 0 ]]; then
        send_notification "critical" "8000" "Battery is critically low: $capacity%"
        crit_low_notified=1
        low_notified=0  # Reset low notification variable
    elif [[ $capacity -ge 80 ]]; then
        low_notified=0  # Reset low notification variable
        crit_low_notified=0  # Reset critically low notification variable
    fi
}

# Initial state
prev_state=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state | awk '{print $2}')
low_notified=0
crit_low_notified=0

# Check battery capacity at a set interval (e.g., every 5 seconds)
while true; do
    check_battery_capacity
    sleep 5
done