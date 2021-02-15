# /bin/bash

sudo pacman -Syy

sudo pacman -S --needed base-devel

# Microcode
sudo pacman -S --needed amd-ucode

# Random stuff
sudo pacman -S --needed rsync dmenu

# Terminal code editor
sudo pacman -S --needed vim

# Window manager - awesome
sudo pacman -S xorg-server awesome

# Terminal emulator - Alacritty
sudo pacman -S --needed alacritty

# Display manager - LightDhttps://wiki.archlinux.org/index.php/DiscordM
sudo pacman -S --needed lightdm-webkit2-greeter lightdm-webkit-theme-litarvan
systemctl enable lightdm

# AUR helper
git clone https://aur.archlinux.org/paru.git ~/paru
cd ~/paru
makepkg -si

# Go back to starting directory
cd -

# Terminal code editor - nigltly neovim
paru -S --needed neovim-nightly-bin

# Shell prompt
paru -S --needed starship

# Browsers
paru -S --needed brave-bin

# GUI file manager
sudo pacman -S --needed pcmanfm

# GUI code editor
paru -S --needed vscodium-bin
sudo pacman -S --needed notepadqq

# Media programs
sudo pacman -S --needed vlc obs-studio peek flameshot

# Other
sudo pacman -S --needed redshift qbittorrent element-desktop discord

# GPU stuff
sudo pacman -S --needed nvidia nvidia-utils nvidia-settings
sudo pacman -S --needed nvidia-prime
paru -S --needed optimus-manager optimus-manager-qt

# Copy wallpapers collection
cp -r ./wallpapers-collection ~/wallpapers-collection

# Copy configuration files
./copyConfig.sh
