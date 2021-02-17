#!/bin/sh
# https://wiki.archlinux.org/index.php/NVIDIA
# The nvidia package contains a file which blacklists the nouveau module, so rebooting is necessary.

# GPU stuff
echo "####################################################################################"
echo "GPU stuff"
sudo pacman -S --needed nvidia nvidia-utils nvidia-settings
#sudo pacman -S --needed nvidia-prime
#paru -S --needed optimus-manager optimus-manager-qt

# https://wiki.archlinux.org/index.php/NVIDIA_Optimus#LightDM
sudo echo """#!/bin/sh
xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto
""" >> /etc/lightdm/display_setup.sh
sudo chmod +x /etc/lightdm/display_setup.sh
sudo sed -i 's/#display-setup-script=/display-setup-script=/etc/lightdm/display_setup.sh/' /etc/lightdm/lightdm.conf
