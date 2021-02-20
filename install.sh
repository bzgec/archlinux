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
sudo pacman $pacmanParams rofi openssh xclip nitrogen acpilight picom sxiv
sudo pacman $pacmanParams rsync htop bluez bluez-utils pulseaudio-bluetooth reflector snapper

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
sudo pacman $pacmanParams xorg-server lightdm-webkit2-greeter lightdm-webkit-theme-litarvan
systemctl enable lightdm
sudo sed -i 's/#greeter-sesstoin=example-gtk-gnome/greeter-session=lightdm-webkit2-greeter/' /etc/lightdm/lightdm.conf
# https://wiki.archlinux.org/index.php/LightDM#LightDM_does_not_appear_or_monitor_only_displays_TTY_output
sudo sed -i 's/#logind-check-graphical=false/logind-check-graphical=true/' /etc/lightdm/lightdm.conf

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

# Set git editor to be nvim
git config --global core.editor nvim

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
sudo pacman $pacmanParams redshift python-gobject qbittorrent element-desktop discord \
                          qalculate-gtk libreoffice-fresh

# Compress and archive apps
# https://wiki.archlinux.org/index.php/Archiving_and_compression
# handle files - https://wiki.archlinux.org/index.php/P7zip
# GUI only - https://archlinux.org/packages/community/x86_64/xarchiver/
echo "####################################################################################"
echo "Compress and archive apps"
echo "####################################################################################"
sudo pacman $pacmanParams p7zip xarchiver

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
