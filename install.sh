#!/bin/bash

# Make sure time synchronization is on (it's best to use UTC)
timedatectl set-ntp true

# Starts by upgrading and installing the system's dependencies
sudo pacman -Syu --needed git firefox code rclone libreoffice networkmanager \
    nm-connection-editor network-manager-applet kitty i3 git nano gvim \
    pacman-contrib xorg xfce4 xfce4-goodies lightdm lightdm-gtk-greeter \
    lightdm-gtk-greeter-settings pulseaudio pulseaudio-bluetooth pavucontrol \
    bluez bluez-utils ack nitrogen tmux autoconf automake gcc github-cli bash-completion \
    gvfs gvfs-afc ntfs-3g picom ttf-fira-code neofetch base-devel reflector \
    vi gimp klavaro noto-fonts-cjk okular ttf-joypixels usbutils intel-ucode fwupd \
    baobab p7zip libnotify


# Configure reflector
echo "Adjust reflector configuration for getting the best mirrors for you"
sudo vim /etc/xdg/reflector/reflector.conf

sudo systemctl enable --now lightdm.service NetworkManager.service reflector.timer bluetooth.service

mkdir -p ~/builds && cd ~/builds || exit

# AUR repository package manager
git clone https://aur.archlinux.org/paru.git
cd paru && makepkg -si

paru i3ipc-glib
paru i3-workspaces
pary -y google-chrome

echo "Keyboard layout, add the layouts: En US, En US international, Portuguese (Brazil)"

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

# Set up wifi printer
sudo pacman -Sy cups cups-pdf nss-mdns

echo "Edit nsswitch.conf's 'hosts' to match the folowing line:"
echo "hosts: mymachines mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns"
sudo vim /etc/nsswitch.conf

sudo systemctl enable --now avahi-daemon.service cups.service
avahi-browse --all --ignore-local --resolve --terminate

# Finally, reboot
reboot
