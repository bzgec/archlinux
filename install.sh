#!/bin/sh
pacmanParams="-S --needed --noconfirm"

if [ "$1" != "no-gui" ]; then
    echo "Installing for GUI setup"
else
    echo "Installing for terminal setup"
fi

read -r -p "Continue? [y/N] " response
response=${response,,}    # tolower
if [[ "$response" =~ ^(yes|y)$ ]]; then
    echo "Executing script..."
else
    echo "Exiting script..."
    exit 0
fi

sudo pacman -Syy

sudo pacman $pacmanParams base-devel

# Random stuff
# udiskie - automount USB disks
echo "####################################################################################"
echo "Random stuff"
echo "####################################################################################"
if [ "$1" != "no-gui" ]; then
    sudo pacman $pacmanParams rofi openssh xclip nitrogen acpilight picom sxiv  \
                              rsync htop bluez bluez-utils snapper \
                              iw man nodejs npm python-pip udiskie
else
    sudo pacman $pacmanParams openssh xclip \
                              rsync htop snapper \
                              iw man nodejs npm python-pip udiskie
fi

# Audio stuff
# pavucontrol - PulseAudio Volume Control
echo "####################################################################################"
echo "Audio stuff"
echo "####################################################################################"
if [ "$1" != "no-gui" ]; then
    sudo pacman $pacmanParams pavucontrol pulseaudio-bluetooth
fi

# Enable colors for pacman
sudo sed -i 's/#Color/Color/' /etc/pacman.conf/

echo "####################################################################################"
echo "Copying xorg keyboard configuration files"
echo "####################################################################################"
# https://wiki.archlinux.org/index.php/Xorg/Keyboard_configuration
if [ "$1" != "no-gui" ]; then
    sudo cp 00-keyboard.conf /etc/X11/xorg.conf.d/
fi

# Window manager - awesome
echo "####################################################################################"
echo "Window manager"
echo "####################################################################################"
if [ "$1" != "no-gui" ]; then
    sudo pacman $pacmanParams xorg-server awesome
fi

# Terminal emulator - Alacritty
echo "####################################################################################"
echo "Terminal emulator"
echo "####################################################################################"
sudo pacman $pacmanParams alacritty

# Display manager (login manager) - LightDM
echo "####################################################################################"
echo "Display manager"
echo "####################################################################################"
if [ "$1" != "no-gui" ]; then
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
    sudo sed -i 's/\nwebkit_theme/\nwebkit_theme        = litarvan/' /etc/lightdm/lightdm-webkit2-greeter.conf
fi

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
if [ "$1" != "no-gui" ]; then
    sudo pacman $pacmanParams xss-lock
    # https://github.com/Raymo111/i3lock-color
    paru $pacmanParams i3lock-color
    sudo chmod +x ./dotfiles/.config/lock.sh
fi

# Terminal stuff
# Neovim - (terminal) editor
# Delta    - A viewer for git and diff output
# Starship - customizable prompt for any shell
# HSTR     - Navigate and search your command history (replacement for `CTRL+R`)
# lazygit  - A simple terminal UI for git commands
echo "####################################################################################"
echo "Terminal suff"
echo "####################################################################################"
paru $pacmanParams neovim-nightly-bin git-delta-bin starship hstr lazygit

# Set git editor to be nvim
git config --global core.editor nvim

# Install python neovim module
pip install --user neovim

# Browser
echo "####################################################################################"
echo "Browser"
echo "####################################################################################"
if [ "$1" != "no-gui" ]; then
    paru $pacmanParams brave-bin
fi

# GUI file manager
echo "####################################################################################"
echo "GUI file manager"
echo "####################################################################################"
if [ "$1" != "no-gui" ]; then
    sudo pacman $pacmanParams pcmanfm
fi

# GUI code editor
echo "####################################################################################"
echo "GUI code editor"
echo "####################################################################################"
if [ "$1" != "no-gui" ]; then
    paru $pacmanParams vscodium-bin
    sudo pacman $pacmanParams notepadqq
fi

# Media programs
echo "####################################################################################"
echo "Media programs"
echo "####################################################################################"
if [ "$1" != "no-gui" ]; then
    sudo pacman $pacmanParams vlc obs-studio peek flameshot
fi

# Other (python-gobject is needed by redshift-gtk)
echo "####################################################################################"
echo "Other GUI apps"
echo "####################################################################################"
if [ "$1" != "no-gui" ]; then
    sudo pacman $pacmanParams redshift python-gobject qbittorrent element-desktop discord \
                              qalculate-gtk libreoffice-fresh gimp okular calibre
fi

# Compress and archive apps
# https://wiki.archlinux.org/index.php/Archiving_and_compression
# handle files - https://wiki.archlinux.org/index.php/P7zip
# GUI only - https://archlinux.org/packages/community/x86_64/xarchiver/
echo "####################################################################################"
echo "Compress and archive apps"
echo "####################################################################################"
sudo pacman $pacmanParams p7zip xarchiver

echo "####################################################################################"
echo "Fix Windows and Linux showing different times"
echo "####################################################################################"
if [ "$1" != "no-gui" ]; then
    timedatectl set-local-rtc 1 --adjust-system-clock
fi

echo "####################################################################################"
echo "Touchpad: change scrolling direction, enable tapping..."
echo "####################################################################################"
if [ "$1" != "no-gui" ]; then
    FILE="/usr/share/X11/xorg.conf.d/40-libinput.conf"
    SEARCH_STRING='Identifier "libinput touchpad catchall"'

    APPEND_STRING='        Option "NaturalScrolling" "true"'
    sudo sed -i "/${SEARCH_STRING}/a\\${APPEND_STRING}" $FILE

    APPEND_STRING='        Option "Tapping" "on"'
    sudo sed -i "/${SEARCH_STRING}/a\\${APPEND_STRING}" $FILE

    APPEND_STRING='        Option "DisableWhileTyping" "on"'
    sudo sed -i "/${SEARCH_STRING}/a\\${APPEND_STRING}" $FILE
fi

# Copy wallpapers collection
echo "####################################################################################"
echo "Copy wallpapers collection"
echo "####################################################################################"
if [ "$1" != "no-gui" ]; then
    cp -r ./wallpapers-collection ~/wallpapers-collection
fi

# Setup snapper (btrfs)
echo "####################################################################################"
echo "Setup snapper"
echo "####################################################################################"
if [ "$1" != "no-gui" ]; then
    bash ./snapperSetup.sh
else
    bash ./snapperSetup.sh no-gui
fi

# Copy configuration files
echo "####################################################################################"
echo "Copy configuration files"
echo "####################################################################################"
bash ./copyConfig.sh
