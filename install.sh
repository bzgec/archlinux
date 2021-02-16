#!/bin/sh
pacmanParams="-S --needed --noconfirm"


sudo pacman -Syy

sudo pacman $pacmanParams base-devel

# Microcode
sudo pacman $pacmanParams amd-ucode

# Random stuff
echo "####################################################################################"
echo "Random stuff"
echo "####################################################################################"
sudo pacman $pacmanParams rsync rofi openssh xclip nitrogen

# Window manager - awesome
echo "####################################################################################"
echo "Window manager"
echo "####################################################################################"
sudo pacman $pacmanParams xorg-server awesome

# Terminal emulator - Alacritty
echo "####################################################################################"
echo "Terminal emulator"
echo "####################################################################################"
sudo pacman $pacmanParams alacritty

# Display manager - LightDhttps://wiki.archlinux.org/index.php/DiscordM
echo "####################################################################################"
echo "Display manager"
echo "####################################################################################"
sudo pacman $pacmanParams lightdm-webkit2-greeter lightdm-webkit-theme-litarvan
systemctl enable lightdm

# AUR helper
echo "####################################################################################"
echo "AUR helper"
echo "####################################################################################"
git clone https://aur.archlinux.org/paru.git ~/paru
cd ~/paru
makepkg -si

# Go back to starting directory
cd -

# Terminal code editor - nigltly neovim
echo "####################################################################################"
echo "Terminal code editor - nightly neovim"
echo "####################################################################################"
paru $pacmanParams neovim-nightly-bin

# Shell prompt
echo "####################################################################################"
echo "Shell prompt"
echo "####################################################################################"
paru $pacmanParams starship

# Browser
echo "####################################################################################"
echo "Browser"
echo "####################################################################################"
paru $pacmanParams brave-bin

# GUI file manager
echo "####################################################################################"
echo "GUI file manager"
echo "####################################################################################"
sudo pacman $pacmanParams pcmanfm

# GUI code editor
echo "####################################################################################"
echo "GUI code editor"
echo "####################################################################################"
paru $pacmanParams vscodium-bin
sudo pacman $pacmanParams notepadqq

# Media programs
echo "####################################################################################"
echo "Media programs"
echo "####################################################################################"
sudo pacman $pacmanParams vlc obs-studio peek flameshot

# Other (python-gobject is needed by redshift-gtk)
echo "####################################################################################"
echo "Other GUI apps"
echo "####################################################################################"
sudo pacman $pacmanParams redshift python-gobject qbittorrent element-desktop discord

# Copy wallpapers collection
echo "####################################################################################"
echo "Copy wallpapers collection"
echo "####################################################################################"
cp -r ./wallpapers-collection ~/wallpapers-collection

# Setup snapper (btrfs)
echo "####################################################################################"
echo "Setup snapper"
echo "####################################################################################"
bash ./snapperSetup.sh

# Copy configuration files
echo "####################################################################################"
echo "Copy configuration files"
echo "####################################################################################"
bash ./copyConfig.sh
