#!/bin/bash

# Starts by upgrading and installing the system's dependencies
sudo pacman -Syu --needed git firefox code rclone libreoffice networkmanager \
    nm-connection-editor network-manager-applet kitty i3 git nano gvim \
    pacman-contrib xorg xfce4 xfce4-goodies lightdm lightdm-gtk-greeter \
    lightdm-gtk-greeter-settings pulseaudio pulseaudio-bluetooth pavucontrol \
    bluez ack nitrogen tmux autoconf automake gcc github-cli bash-completion \
    gvfs gvfs-afc ntfs-3g picom ttf-fira-code neofetch base-devel reflector \
    vi gimp klavaro noto-fonts-cjk

# Configure reflector
echo "Adjust reflector configuration for getting the best mirrors for you"
sudo vim /etc/xdg/reflector/reflector.conf

sudo systemctl enable lightdm.service NetworkManager.service reflector.timer

mkdir -p ~/builds && cd ~/builds || exit

# AUR repository package manager
git clone https://aur.archlinux.org/paru.git
cd paru && makepkg -si

paru i3ipc-glib
paru i3-workspaces

echo "Keyboard layout, add the layouts: En US, En US international, Pt Brazil Thinkpad (ABNT)"

echo "Remove xfwm4 and xdesktop from session startup (set them to never)"
echo "Add i3 to session startup"

echo "Remove workspace viewer from panel"
echo "Add i3-workspaces to panel"

echo "On appearence, change theme to adwaita dark"

echo "Choose wallpaper"
nitrogen

# Log in to github
gh auth login

# Make basic system directories
mkdir -p ~/{Workspace,Pictures,Documents,Downloads,GoogleDrive,builds,bin}

# Install Bashtion
cd ~/Workspace || exit
git clone https://github.com/gianpietrodimatteo/Bashtion.git
cd Bashtion && ./install.sh

# Install Vimcent
cd ~/Workspace || exit
git clone https://github.com/gianpietrodimatteo/Vimcent.git
cd Vimcent && ./install.sh

# Install LinuxGDriveSync
cd ~/Workspace || exit
git clone https://github.com/gianpietrodimatteo/LinuxGDriveSync.git
cd LinuxGDriveSync && ./install.sh

rmLn() {
    rm -f "$2"
    ln -sv "$1" "$2"
}

# Install i3 config
mkdir -p ~/.config/i3
rmLn "$(pwd)/i3-config" ~/.config/i3/config

# Set up Xmodmap
rmLn "$(pwd)/Xmodmap" ~/.Xmodmap

# Install vscode config
rmLn "$(pwd)/vscode-settings.json" "$HOME/.config/Code - OSS/User/settings.json"
rmLn "$(pwd)/vscode-keybindings.json" "$HOME/.config/Code - OSS/User/keybindings.json"

# Install kitty config
rmLn "$(pwd)/kitty.conf" ~/.config/kitty/kitty.conf

# Picom config
rmLn "$(pwd)/picom.conf" ~/.config/picom.conf

# Git config
rmLn "$(pwd)/gitconfig" ~/.gitconfig

# Finally, reboot
reboot
