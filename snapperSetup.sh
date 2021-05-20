#!/bin/sh

# https://www.youtube.com/watch?v=Xynotc9BKe8
# https://wiki.archlinux.org/index.php/snapper


AUR_HELPER="paru"

pacman_install() { sudo pacman -S --needed --noconfirm "$@"; }

if [ "$1" != "no-gui" ]; then
    echo "Installing for GUI setup"
else
    echo "Installing for terminal setup"
fi

# Add user + change limits for snapshots to keep
printf "Enter user: "
read -r user
echo "$user"

printf "Continue? [y/N] "
read -r response
response=$(echo "$response" | tr '[:upper:]' '[:lower:]')  # tolower
if [ "$response" = "y"  ] || [ "$response" = "yes" ]; then
#if [[ "$response" =~ ^(yes|y)$ ]]; then
    echo "Executing script..."
else
    echo "Exiting script..."
    exit 0
fi

pacman_install snapper

# Snapper stuff
sudo umount /.snapshots
sudo rm -r /.snapshots
sudo snapper -c root create-config /
sudo btrfs subvolume delete /.snapshots
sudo mkdir /.snapshots
sudo mount -a
sudo chmod 750 /.snapshots

# Enable users to view snapshots
sudo chmod a+rx /.snapshots
sudo chown :"$user" /.snapshots

addUserSedCmd="s/ALLOW_USERS=\"\"/ALLOW_USERS=\"${user}\"/"
echo "$addUserSedCmd"
sudo sed -i "$addUserSedCmd" /etc/snapper/configs/root
sudo sed -i 's/TIMELINE_LIMIT_HOURLY="10"/TIMELINE_LIMIT_HOURLY="5"/' /etc/snapper/configs/root
sudo sed -i 's/TIMELINE_LIMIT_DAILY="10"/TIMELINE_LIMIT_DAILY="7"/' /etc/snapper/configs/root
sudo sed -i 's/TIMELINE_LIMIT_WEEKLY="0"/TIMELINE_LIMIT_WEEKLY="0"/' /etc/snapper/configs/root
sudo sed -i 's/TIMELINE_LIMIT_MONTHLY="10"/TIMELINE_LIMIT_MONTHLY="0"/' /etc/snapper/configs/root
sudo sed -i 's/TIMELINE_LIMIT_YEARLY="10"/TIMELINE_LIMIT_YEARLY="0"/' /etc/snapper/configs/root

sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer

if [ "$1" != "no-gui" ]; then
    echo "Install 'snap-pac-grub' and 'snapper-gui' from AUR"
    $AUR_HELPER -S snap-pac-grub snapper-gui
else
    echo "Install 'snap-pac-grub' from AUR"
    $AUR_HELPER -S snap-pac-grub
fi

sudo mkdir /etc/pacman.d/hooks
echo '''
[Trigger]
Operation = Upgrade
Operation = Install
Operation = Remove
Type = Path
Target = /boot/*

[Action]
Depends = rsync
Description = Backing up /boot...
When = PreTransaction
Exec = /usr/bin/rsync -a --delete /boot /.bootbackup
''' | sudo tee -a /etc/pacman.d/hooks/50-bootbackup.hook

pacman_install rsync

echo "Remove 'fsck' from 'HOOKS'"
printf "You understand? [y/N] "
read -r yn
case $yn in
    [Yy]* ) ;;
    [Nn]* ) exit;;
    * ) echo "Please anwser yes or no.";;
esac
sudo vim /etc/mkinitcpio.conf

# Enable snapshots for /home subvolume
sudo snapper -c home create-config /home
