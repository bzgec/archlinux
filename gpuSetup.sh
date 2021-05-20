#!/bin/sh
# https://wiki.archlinux.org/index.php/NVIDIA
# The nvidia package contains a file which blacklists the nouveau module, so rebooting is necessary.

# GPU stuff
echo "####################################################################################"
echo "GPU stuff"
sudo pacman -S --needed nvidia nvidia-utils nvidia-settings

# optimus-manager - https://github.com/Askannz/optimus-manager
# optimus-manager seems quite promising but version which supports AMD/nvidia is not yet on AUR
# soo we need to wait - 2021/02/20
#sudo pacman -S --needed nvidia-prime
#paru -S --needed optimus-manager optimus-manager-qt
paru -S optimus-manager-git optimus-manager-qt-git

# Copy configuration files
sudo cp optimus-manager.conf /etc/optimus-manager/

# Using only nvidia GPU until optimus-manager supports AMD/nvidia on AUR
# doing this - https://wiki.archlinux.org/index.php/NVIDIA_Optimus#Use_NVIDIA_graphics_only
# Interesting read - https://bbs.archlinux.org/viewtopic.php?id=257449


# Setup for using NVIDIA only
## https://wiki.archlinux.org/index.php/NVIDIA_Optimus#LightDM
#sudo cp display_setup.sh /etc/lightdm/
#sudo chmod +x /etc/lightdm/display_setup.sh
#sudo sed -i 's/#display-setup-script=/display-setup-script=\/etc\/lightdm\/display_setup.sh/' /etc/lightdm/lightdm.conf
