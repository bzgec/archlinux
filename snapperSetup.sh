#!/bin/sh

# https://www.youtube.com/watch?v=Xynotc9BKe8
# https://wiki.archlinux.org/index.php/snapper


AUR_HELPER="paru"

sudo pacman -S snapper

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
sudo chown :bzgec /.snapshots

echo 'Add your user to `ALLOW_USERS=""` -> `ALLOW_USERS="bzgec"'
echo 'Define how many snapshots you want to keep in the system -> change `TIMELINE_LIMIT...`'
echo '''
TIMELINE_MIN_AGE="1800"
TIMELINE_LIMIT_HOURLY="5"
TIMELINE_LIMIT_DAILY="7"
TIMELINE_LIMIT_WEEKLY="0"
TIMELINE_LIMIT_MONTHLY="0"
TIMELINE_LIMIT_YEARLY="0"
'''
read -p "You understand?" yn
case $yn in
    [Yy]* ) ;;
    [Nn]* ) exit;;
    * ) echo "Please anwser yes or no.";;
esac
sudo vim /etc/snapper/configs/root

sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer

echo "Install 'snap-pac-grub' and 'snapper-gui' from AUR"
$AUR_HELPER -S snap-pac-grub snapper-gui

sudo mkdir /etc/pacman.d/hooks
sudo echo '''
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
''' >> /etc/pacman.d/hooks/50-bootbackup.hook

sudo pacman -S rsync

echo "Remove 'fsck' from 'HOOKS'"
read -p "You understand?" yn
case $yn in
    [Yy]* ) ;;
    [Nn]* ) exit;;
    * ) echo "Please anwser yes or no.";;
esac
sudo vim /etc/mkinitcpio.conf
