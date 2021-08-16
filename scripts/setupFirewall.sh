#!/bin/sh

pacman_install() { sudo pacman -S --needed --noconfirm "$@"; }

echo "####################################################################################"
echo "Setup firewall - ufw"
echo "####################################################################################"
# https://wiki.archlinux.org/title/Uncomplicated_Firewall
pacman_install ufw
sudo systemctl enable ufw.service

# ufw service won't work if iptables.service is also enabled (and same for its ipv6 counterpart)
sudo systemctl stop iptables.service
sudo systemctl disable iptables.service

sudo systemctl start ufw.service

sudo ufw reset  # Clear any previous configuration
sudo ufw default allow outgoing  # Allow all outgoing traffic
sudo ufw default deny incoming  # Block all incoming traffic
sudo ufw enable
sudo ufw reload
