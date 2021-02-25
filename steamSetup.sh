#!/bin/sh

# https://wiki.archlinux.org/index.php/steam
# https://github.com/lutris/docs/blob/master/InstallingDrivers.md
# https://www.youtube.com/watch?v=2_rLPVGGPAs

# Enable multilib
#[multilib]
#Include = /etc/pacman.d/mirrorlist
#sudo sed 's/#\[multilib\]\n#Include = \/etc\/pacman.d\/mirrorlist/\[multilib\]\nInclude = \/etc\/pacman.d\/mirrorlist/' /etc/pacman.conf
# https://unix.stackexchange.com/questions/26284/how-can-i-use-sed-to-replace-a-multi-line-string
cat /etc/pacman.conf | tr '\n' '\f' | tr '\r' '\f' | tr '\f\f' '\f' | sed -e 's/#\[multilib\]\f#Include = \/etc\/pacman.d\/mirrorlist/\[multilib\]\fInclude = \/etc\/pacman.d\/mirrorlist/' | tr '\f' '\n' | sudo tee /etc/pacman.conf 1>/dev/null
# cat /etc/pacman.conf | tr '\n' '\f' | tr '\r' '\f' | tr '\f\f' '\f' | sed -e 's/#\[multilib\]\f#Include = \/etc\/pacman.d\/mirrorlist/\[multilib\]\fInclude = \/etc\/pacman.d\/mirrorlist/' | tr '\f' '\n' | tee tmp.txt 1>/dev/null

# Then upgrade the system
sudo pacman -Syu

# https://github.com/lutris/docs/blob/master/InstallingDrivers.md
# For nVidia, it would be:
#   sudo pacman -S nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader
# For AMD, it would be:
#   sudo pacman -S lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader
# And for Intel, it would be:
#   sudo pacman -S lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader

sudo pacman -S nvidia nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader

# Install steam
sudo pacman -S steam
