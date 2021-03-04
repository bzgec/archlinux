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
sudo pacman $pacmanParams rofi openssh xclip nitrogen acpilight picom sxiv  \
                          rsync htop bluez bluez-utils pulseaudio-bluetooth reflector snapper \
                          iw

echo "####################################################################################"
echo "Copying xorg keyboard configuration files"
echo "####################################################################################"
# https://wiki.archlinux.org/index.php/Xorg/Keyboard_configuration
sudo cp 00-keyboard.conf /etc/X11/xorg.conf.d/

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

# Display manager (login manager) - LightDM
echo "####################################################################################"
echo "Display manager"
echo "####################################################################################"
sudo pacman $pacmanParams xorg-server lightdm-webkit2-greeter lightdm-webkit-theme-litarvan \
                          numlockx
systemctl enable lightdm
sudo sed -i 's/#greeter-sesstoin=example-gtk-gnome/greeter-session=lightdm-webkit2-greeter/' /etc/lightdm/lightdm.conf
# https://wiki.archlinux.org/index.php/LightDM#LightDM_does_not_appear_or_monitor_only_displays_TTY_output
sudo sed -i 's/#logind-check-graphical=false/logind-check-graphical=true/' /etc/lightdm/lightdm.conf
# Enable numlock at boot
# https://wiki.archlinux.org/index.php/Activating_numlock_on_bootup
# https://wiki.archlinux.org/index.php/LightDM#NumLock_on_by_default
sudo sed -i 's/#greeter-setup-script=/greeter-setup-script=\/usr\/bin\/numlockx on/' /etc/lightdm/lightdm.conf
# Change clock format on login screen
sudo sed -i 's/time_format         = LT/time_format         = HH:mm/' /etc/lightdm/lightdm-webkit2-greeter.conf

# AUR helper
echo "####################################################################################"
echo "AUR helper"
echo "####################################################################################"
git clone https://aur.archlinux.org/paru.git ~/paru
cd ~/paru
makepkg -si

# Go back to starting directory
cd -

# Handle inactivity stuff
echo "####################################################################################"
echo "Handle inactivity stuff"
echo "####################################################################################"
sudo pacman $pacmanParams xss-lock
# https://github.com/Raymo111/i3lock-color
paru $pacmanParams i3lock-color
sudo chmod +x ./dotfiles/.config/lock.sh

# Terminal stuff
# Neovim - (terminal) editor
# Delta - A viewer for git and diff output
# Starship - customizable prompt for any shell
echo "####################################################################################"
echo "Terminal suff"
echo "####################################################################################"
paru $pacmanParams neovim-nightly-bin git-delta-bin starship

# Set git editor to be nvim
git config --global core.editor nvim

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
                          qalculate-gtk libreoffice-fresh gimp

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
