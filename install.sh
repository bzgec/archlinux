#!/bin/sh

pacman_install() { sudo pacman -S --needed --noconfirm "$@"; }
AUR_helper_install() { paru -S --needed --noconfirm "$@"; }

if [ "$1" != "no-gui" ]; then
    echo "Installing for GUI setup"
else
    echo "Installing for terminal setup"
fi

printf "Continue? [y/N] "
read -r response
response=$(echo "$response" | tr '[:upper:]' '[:lower:]')  # tolower
if [ "$response" = "y"  ] || [ "$response" = "yes" ]; then
    echo "Executing script..."
else
    echo "Exiting script..."
    exit 0
fi

sudo pacman -Syy

pacman_install base-devel

# Random stuff
# udiskie - automount USB disks
echo "####################################################################################"
echo "Random stuff"
echo "####################################################################################"
if [ "$1" != "no-gui" ]; then
    pacman_install rofi openssh xclip nitrogen acpilight picom sxiv  \
                   rsync htop bluez bluez-utils snapper alsa-utils \
                   iw man nodejs npm python-pip udiskie shellcheck
else
    pacman_install openssh xclip \
                   rsync htop snapper \
                   iw man nodejs npm python-pip udiskie shellcheck
fi

# Gitlab fix for `client_global_hostkeys_private_confirm: server gave bad signature for RSA key 0`
# https://stackoverflow.com/a/66876321/14246508
# https://www.reddit.com/r/archlinux/comments/lyazre/openssh_update_causes_problems/
FILE=~/.ssh/config
{
    echo "Host gitlab.com"
    echo "  UpdateHostKeys no"
} >> $FILE

# Audio stuff
# pavucontrol - PulseAudio Volume Control
echo "####################################################################################"
echo "Audio stuff"
echo "####################################################################################"
if [ "$1" != "no-gui" ]; then
    pacman_install pavucontrol pulseaudio-bluetooth
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
    pacman_install xorg-server awesome
fi

# Terminal emulator - Alacritty
echo "####################################################################################"
echo "Terminal emulator"
echo "####################################################################################"
pacman_install alacritty

# Display manager (login manager) - LightDM
echo "####################################################################################"
echo "Display manager"
echo "####################################################################################"
if [ "$1" != "no-gui" ]; then
    pacman_install xorg-server lightdm-webkit2-greeter lightdm-webkit-theme-litarvan \
                   numlockx
    systemctl enable lightdm
    sudo sed -i 's/#greeter-sessoin=example-gtk-gnome/greeter-session=lightdm-webkit2-greeter/' /etc/lightdm/lightdm.conf
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
# Use a ( subshell ) to avoid having to cd back.
(
    cd ~/paru || exit
    makepkg -si
)

# Handle inactivity stuff
echo "####################################################################################"
echo "Handle inactivity stuff"
echo "####################################################################################"
if [ "$1" != "no-gui" ]; then
    pacman_install xss-lock
    # https://github.com/Raymo111/i3lock-color
    AUR_helper_install i3lock-color
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
AUR_helper_install neovim-nightly-bin starship hstr lazygit
pacman_install git-delta

# Set git editor to be nvim
git config --global core.editor nvim

# Install python neovim module
pip install --user neovim

# Browser
echo "####################################################################################"
echo "Browser"
echo "####################################################################################"
if [ "$1" != "no-gui" ]; then
    AUR_helper_install brave-bin
fi

# GUI file manager
echo "####################################################################################"
echo "GUI file manager"
echo "####################################################################################"
if [ "$1" != "no-gui" ]; then
    pacman_install pcmanfm
fi

# GUI code editor
echo "####################################################################################"
echo "GUI code editor"
echo "####################################################################################"
if [ "$1" != "no-gui" ]; then
    AUR_helper_install vscodium-bin
    pacman_install notepadqq
fi

# Media programs
echo "####################################################################################"
echo "Media programs"
echo "####################################################################################"
if [ "$1" != "no-gui" ]; then
    pacman_install vlc obs-studio peek flameshot
fi

# Other (python-gobject is needed by redshift-gtk)
echo "####################################################################################"
echo "Other GUI apps"
echo "####################################################################################"
if [ "$1" != "no-gui" ]; then
    pacman_install redshift python-gobject qbittorrent discord \
                   qalculate-gtk libreoffice-fresh gimp okular calibre gparted \
                   screenkey
fi

# Compress and archive apps
# https://wiki.archlinux.org/index.php/Archiving_and_compression
# handle files - https://wiki.archlinux.org/index.php/P7zip
# GUI only - https://archlinux.org/packages/community/x86_64/xarchiver/
echo "####################################################################################"
echo "Compress and archive apps"
echo "####################################################################################"
pacman_install p7zip xarchiver

echo "####################################################################################"
echo "Fix Windows and Linux showing different times"
echo "####################################################################################"
sudo timedatectl set-ntp true
sudo hwclock --systohc
if [ "$1" != "no-gui" ]; then
    timedatectl set-local-rtc 1 --adjust-system-clock
fi

echo "####################################################################################"
echo "Touchpad: change scrolling direction, enable tapping..."
echo "####################################################################################"
if [ "$1" != "no-gui" ]; then
    sudo cp 40-libinput.conf /etc/X11/xorg.conf.d/
fi

echo "####################################################################################"
echo "Setting default applications"
echo "####################################################################################"
# https://www.reddit.com/r/linuxquestions/comments/5z3n81/default_applications_in_arch_linux/dev24vo?utm_source=share&utm_medium=web2x&context=3
# Location: /usr/share/applications/
# Get default for specific file: xdg-mime query filetype myImage.jpg
# Set default: xdg-mime default sxiv.desktop image/jpg
# Get default: xdg-mime query default application/pdf
if [ "$1" != "no-gui" ]; then
    xdg-mime default sxiv.desktop image/jpeg
    xdg-mime default sxiv.desktop image/jpg
    xdg-mime default sxiv.desktop image/png
    xdg-mime default sxiv.desktop image/svg+xml
    xdg-mime default sxiv.desktop image/gif
    xdg-mime default sxiv.desktop image/bmp
    xdg-mime default pcmanfm.desktop inode/directory
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

bash ./setupFirewall.sh
