# /bin/bash

sudo pacman -Syy

sudo pacman -S --needed base-devel

# Microcode
#sudo pacman -S --needed amd-ucode

# Random stuff
echo "####################################################################################"
echo "Random stuff"
sudo pacman -S --needed rsync rofi openssh xclip nitrogen

# Window manager - awesome
echo "####################################################################################"
echo "Window manager"
sudo pacman -S xorg-server awesome

# Terminal emulator - Alacritty
echo "####################################################################################"
echo "Terminal emulator"
sudo pacman -S --needed alacritty

# Display manager - LightDhttps://wiki.archlinux.org/index.php/DiscordM
echo "####################################################################################"
echo "Display manager"
sudo pacman -S --needed lightdm-webkit2-greeter lightdm-webkit-theme-litarvan
systemctl enable lightdm

# https://wiki.archlinux.org/index.php/NVIDIA_Optimus#LightDM
sudo echo """#!/bin/sh
xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto
""" >> /etc/lightdm/display_setup.sh
sudo chmod +x /etc/lightdm/display_setup.sh
sudo echo "display-setup-script=/etc/lightdm/display_setup.sh" >> /etc/lightdm/lightdm.conf
sudo echo "greeter-session=webkit2-greeter" >> /etc/lightdm/lightdm.conf

# AUR helper
echo "####################################################################################"
echo "AUR helper"
git clone https://aur.archlinux.org/paru.git ~/paru
cd ~/paru
makepkg -si

# Go back to starting directory
cd -

# Terminal code editor - nigltly neovim
echo "####################################################################################"
echo "Terminal code editor - nightly neovim"
paru -S --needed neovim-nightly-bin

# Shell prompt
echo "####################################################################################"
echo "Shell prompt"
paru -S --needed starship

# Browser
echo "####################################################################################"
echo "Browser"
paru -S --needed brave-bin

# GUI file manager
echo "####################################################################################"
echo "GUI file manager"
sudo pacman -S --needed pcmanfm

# GUI code editor
echo "####################################################################################"
echo "GUI code editor"
paru -S --needed vscodium-bin
sudo pacman -S --needed notepadqq

# Media programs
echo "####################################################################################"
echo "Media programs"
sudo pacman -S --needed vlc obs-studio peek flameshot

# Other
echo "####################################################################################"
echo "Other"
sudo pacman -S --needed redshift python-gobject qbittorrent element-desktop discord

# GPU stuff
echo "####################################################################################"
echo "GPU stuff"
sudo pacman -S --needed nvidia nvidia-utils nvidia-settings
sudo pacman -S --needed nvidia-prime
paru -S --needed optimus-manager optimus-manager-qt

# Copy wallpapers collection
echo "####################################################################################"
echo "Copy wallpapers collection"
cp -r ./wallpapers-collection ~/wallpapers-collection

# Fix some snapper stuff (btrfs)
bash ./snapperSetup.sh

# Copy configuration files
echo "####################################################################################"
echo "Copy configuration files"
bash ./copyConfig.sh
