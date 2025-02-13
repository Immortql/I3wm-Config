#!/bin/bash

# Update the system (optional, but recommended)
read -p "Do you want to update the pkg list? (y/n): " update_choice
if [[ $update_choice == "y" ]]; then
    sudo -v
    sudo pacman -Syy
fi

# Define packages for pacman
pacman_packages=(
    git
    calc
    dmenu
    dunst
    feh
    firefox
    i3blocks
    i3lock
    i3status
    i3-wm
    imagemagick
    mpd
    mpv
    picom
    polybar
    rofi
    maim
    thunar
    xfce4-terminal
    xclip
    xdotool
    lxappearance
    epapirus-icon-theme
    xdg-user-dirs
    noto-fonts-cjk
    noto-fonts-emoji
    python-i3ipc
    xprintidle
)

# Install packages using pacman
for package in "${pacman_packages[@]}"; do
    sudo -v
    sudo pacman -S --needed --noconfirm "$package"
done

# Ask the user if they want to install AUR packages
read -p "Do you want to install AUR packages? (y/n): " aur_choice
if [[ $aur_choice == "y" ]]; then
    # Check if yay is installed
    if ! command -v yay &> /dev/null; then
        # Install yay
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ..
        rm -rf yay
    fi

    # Define packages for yay
    aur_packages=(
        xwinwrap-0.9-bin
    )

    # Install AUR packages using yay
    for package in "${aur_packages[@]}"; do
        sudo -v
        yay -S --needed --noconfirm "$package"
    done
fi

# Clone the git repo
git clone https://github.com/Immortql/I3wm-Config
cd I3wm-Config

# Backup the existing i3 directory if it exists
if [ -d "$HOME/.config/i3" ]; then
    mv "$HOME/.config/i3" "$HOME/.config/i3.bak"
fi

# Backup the existing fonts directory if it exists
if [ -d "$HOME/.local/share/fonts" ]; then
    mv "$HOME/.local/share/fonts" "$HOME/.local/share/fonts.bak"
fi

# Copy i3 to ~/.config
cp -r i3 "$HOME/.config"

# Copy fonts to ~/.local/share/fonts
cp -r fonts "$HOME/.local/share"

# Alert the user the process has finished
clear
echo "i3wm config has been installed. Enjoy! :3"
