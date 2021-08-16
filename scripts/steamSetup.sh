#!/bin/sh

# https://wiki.archlinux.org/index.php/steam
# https://github.com/lutris/docs/blob/master/InstallingDrivers.md
# https://www.youtube.com/watch?v=2_rLPVGGPAs

# Activate the “multilib” repository
# Uncomment lines:
#   #[multilib]
#   #Include = /etc/pacman.d/mirrorlist

# Replace line after `#[multilib]`
sudo sed -i '/#\[multilib\]/!b;n;cInclude = \/etc\/pacman.d\/mirrorlist' /etc/pacman.conf

# Replace line `#[multilib]`
sudo sed -i 's/#\[multilib\]/\[multilib\]/' /etc/pacman.conf

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
