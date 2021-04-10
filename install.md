# Install

- Dualboot with Windows 10 - [video](https://www.youtube.com/watch?v=L1B1O0R1IHA)
- Btrfs with snapper - [video](https://www.youtube.com/watch?v=Xynotc9BKe8)
- [Installation guide - wiki.archlinux.org](https://wiki.archlinux.org/index.php/installation_guide)

Note that for installation you need internet connection

## 1. Set up the correct keyboard

`ls /usr/share/kbd/keymaps/**/*.map.gz | less`

## 2. Select keyboard

`loadkeys slovene.map.gz`

## 3. Check if wireless card is not blocked

`rfkill list`

## 4. Connect to WiFi

1. `iwctl`
2. First, if you do not know your wireless device name, list all Wi-Fi devices: `device list`
3. Then, to scan for networks: `station [device] scan`
4. You can then list all available networks: `station [device] get-networks`
5. Finally, to connect to a network: `iwctl --passphrase [passphrase] station [device] connect [SSID]`
6. Done

## 5. Plug in ethernet cable and check if you have connection

`ping google.com`

## 6. Update the system clock

`timedatectl set-ntp true`

You can verify it with: `timedatectl status`

## 7. Update the mirrors

`sudo pacman -Syy`

## 8. Get best mirrors

`sudo pacman -S reflector && reflector --verbose --latest 10 --sort rate --save /etc/pacman.d/mirrorlist`

## 9. Update the mirrors

`sudo pacman -Syy`

## 10. Partition the disks

- [wiki.archlinux.org](https://wiki.archlinux.org/index.php/Partitioning)

### 10.1. Verify if you have BIOS or UEFI

`ls /sys/firmware/efi/efivars` (if no error than you have UEFI)

### 10.2. Identify devices

`lsblk`

### 10.3. Open selected disk

`fdisk /dev/sda` or `fdisk /dev/nvme0n1`

### 10.4 Partition

#### 10.4.1 BIOS with MBR

- list free partitioned space

1. `o` to select MBR/DOS partition table
2. List free unpartitioned space: `F`
3. Create new partition: `n`
4. Set partition type to primary: `p`
5. Set partition number to 1: `1`
6. Set first sector (where to start first sector) - leave default (just hit enter)
7. Set swap size (equals to RAM size): `+2G`
8. If some error occurs about type just ignore it
9. Set rest of the disk size: `n`, `p`, `2`, default, default (all remaining memory)
10. Change swap partition type: `t`, `1`, `82` (this should be checked with `L`
11. Enable boot from linux partition: `a`, `2`
12. Write table to disk: `w`

#### 10.4.2 UEFI with GPT

1. `g` to select GPT partition table (skip if Windows 10 is already installed)
2. Create efi partition: `n`, `1`, default, `+550M`  TODO: is EFI partition really necessary if Windows 10 is already installed?
3. Create swap partition: `n`, `2`, default, `+16G` (size of RAM)
4. Create Linux partition: `n`, `3`, default, default
5. Change partitions type:
   1. `t`, `1`, `1` (check with `l` - EFI)
   2. `t`, `2`, `19` (check with `l` - swap)
   3. Already Linux file system
6. Write table to disk: `w`

## 11. Make file systems

1. EFI: `mkfs.fat -F32 /dev/sda1` (only if using UEFI)
2. swap:
   1. Create swap: `mkswap /dev/sda1` or `mkswap /dev/sda2`
   2. Turn on swap: `swapon /dev/sda1` or `swapon /dev/sda2`

3. Big partition: `mkfs.ext4 /dev/sda2` or `mkfs.ext4 /dev/sda3` or `mkfs.btrfs /dev/nvme0n1p7`

   If you want to create ntfs: `mkfs.ntfs /dev/sda3` or `mkfs.ntfs -f /dev/sda3`
   (`-f` - perform quick (fast) format. This will skip both zeroing of the volume and
   bad sector checking.)

## 12. Mound the big partition

`mount /dev/sda2 /mnt` or `mount /dev/sda3 /mnt`

## 13. Btrfs only:

1. Create *root* subvolume: `btrfs su cr /mnt/@`
2. Create *home* subvolume: `btrfs su cr /mnt/@home`
3. Create *snapshots* subvolume: `btrfs su cr /mnt/@snapshots`
4. Create *var_log* subvolume: `btrfs su cr /mnt/@var_log`
5. Unmount `/mnt`: `umount /mnt`
6. Mount *root* subvolume with btrfs:`mount -o noatime,compress=lzo,space_cache=v2,subvol=@ /dev/nvme0n1p7 /mnt`
7. Make directories: `mkdir -p /mnt/{boot,home,.snapshots,var_log}`
8. Mount other subvmolumes:
   1. `mount -o noatime,compress=lzo,space_cache=v2,subvol=@home /dev/nvme0n1p7 /mnt/home`
   2. `mount -o noatime,compress=lzo,space_cache=v2,subvol=@snapshots /dev/nvme0n1p7 /mnt/.snapshots`
   3. `mount -o noatime,compress=lzo,space_cache=v2,subvol=@var_log /dev/nvme0n1p7 /mnt/var_log`
   4. `mount /dev/nvme0n1p5 /mnt/boot` (EFI ONLY)
9. Mount Windows 10: `mkdir /mnt/win10 && mount /dev/nvme0n1p3 /mnt/win10`

## 14. Install essential packages (base system)

`pacstrap /mnt base linux linux-firmware vim amd-ucode`

## 15. Generate file system table

`genfstab -U /mnt >> /mnt/etc/fstab`

We can check if everything is ok with: `cat /mnt/etc/fstab`

## 16. Change root into the new system

`arch-chroot /mnt`

## 17. Set timezone

`ln -sf /usr/share/zoneinfo/Europe/Ljubljana /etc/localtime` (you can help
yourself with `ls /usr/share/zoneinfo`)

## 18. Set hardware clock

`hwclock --systohc`

## 19. Select locale

`vim /etc/locale.gen`, uncomment `en_US.UTF-8 UTF-8` and `sl_SI.UTF-8 UTF-8`

## 20. Generate the locales

`locale-gen`

## 21. Set the `LANG` variable

`vim /etc/locale.conf`, enter `LANG=en_US.UTF-8` (or simpler just:
`echo "LANG=en_US.UTF-8" >> /etc/locale.conf`)

## 22. Make Arch Linux remember keyboard layout

`vim /etc/vconsole.conf`, enter `KEYMAP=slovene.map.gz`
(or simpler: `echo "KEYMAP=slovene.map.gz" >> /etc/vconsole.conf`)

## 23. Create hostname

`vim /etc/hostname`, input just the hostname: `arch` (or simpler:
`echo "arch" >> /etc/hostname`)

## 24. Add hostname to hosts

`vim /etc/hosts`, add this lines:

```text
vim /etc/hosts
--------------------------------------
127.0.0.1    localhost
::1          localhost
127.0.1.1    arch.localdomain arch
```

## 25. Create root password

`passwd`, enter root password

## 26. Install other packages

`pacman -S --noconfirm sudo grub networkmanager network-manager-applet wireless_tools wpa_supplicant efibootmgr ntfs-3g dosfstools os-prober mtools base-devel linux-headers git bash-completion reflector`

Note that `os-prober` is needed only for multiboot setups.

## 27. Set `EDITOR` environment variable

`echo "export EDITOR=vim" >> /etc/profile`

## 28. Btrfs only

1. Add `btrfs` into modules in `vim /etc/mkinitcpio.conf` file (`MODULES=(btrfs)`)
2. Recreate kernel image with btrfs module included: `mkinitcpio -p linux`

## 29. Init grub

- BIOS: `grub-install --target=i386-pc /dev/sda`
- EFI: `grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB`

## 30. Generate grub configuration

`grub-mkconfig -o /boot/grub/grub.cfg` (you should see Linux and Windows 10 images)

## 31. Enable previously installed packages

1. `systemctl enable NetworkManager`
2. `systemctl enable bluetooth`
3. `systemctl enable wpa_supplicant`

## 32. Create user

`useradd -mG wheel bzgec`, `passwd bzgec`, enter password

## 33. Add user to groups

`usermod -aG wheel,audio,video,optical,storage bzgec`

## 34. Add user to use sudo privileges

`EDITOR=vim visudo`, uncomment line `%wheel ALL=(ALL) ALL`

## 35. Enable hibernation

1. Add kernel parameter (add `resume=` parameter):
   1. Edit `/etc/default/grub` and append your kernel options between the quotes in the
      `GRUB_CMDLINE_LINUX_DEFAULT` line:

      ```text
      /etc/default/grub
      -------------------------------------------------------------------------
      GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet resume=/dev/nvme0n1p6"
      ```

   2. And then automatically re-generate the `grub.cfg` file with:
       `grub-mkconfig -o /boot/grub/grub.cfg`
2. Configure the `initramfs` (add `resume` hook). Whether by label or by UUID, the swap
   partition is referred to with a udev device node, so the `resume` hook must go after the
   `udev` hook. This example was made starting from the default hook configuration:

   ```text
   /etc/mkinitcpio.conf
   --------------------------------------------------------------------------
   HOOKS=(base udev autodetect modconf block filesystems keyboard resume)
   ```

- [Kernel parameters](https://wiki.archlinux.org/index.php/kernel_parameters)
- [Power management - suspend and hibernate](https://wiki.archlinux.org/index.php/Power_management/Suspend_and_hibernate#Hibernation)

## 36. Change options for closing the laptop lid, power button press

- [Power management](https://wiki.archlinux.org/index.php/Power_management#ACPI_events).

Edit `/etc/systemd/logind.conf`:

```text
/etc/systemd/logind.conf
--------------------------------------------------
HandlePowerKey=hibernate
HandleLidSwitch=suspend-then-hibernate
HandleLidSwitchExternalPower=suspend-then-hibernate
IdleAction=suspend-then-hibernate
IdleActionSec=10min
```

You can also change delay between suspend and hibernate, edit `/etc/systemd/sleep.conf`:

```text
/etc/systemd/sleep.conf
--------------------------------------------------
HibernateDelaySec=120min
```

## 37. `exit`

## 38. `umount -R /mnt`

## 39. `reboot`

## 40. Connect to WiFi

1. List available WiFis: `nmcli device wifi list`
2. Connect: `nmcli device wifi connect [SSID] password [PASSWORD]`
3. List all the connected networks: `nmcli connection show`
4. Check status of network devices: `nmcli device`
5. Disconnect network: `nmcli device disconnect [DEVICE]`
6. Re-connect with a network: `nmcli connection show`
7. Disable WiFi: `nmcli radio wifi off`

You could also use `nmtui` - ncurses based interface

## 41. Clone other automated Arch linux setup

`git clone https://github.com/bzgec/archlinux.git && cd archlinux && git submodule update --init --recursive`

## 42. Setup for servers

### 42.1. Set static IP

Open `nmtui`:

1. Edit connection for selected WiFi
2. Set IPv4 configuration to `<Manual>`
3. *Address*: Put your static IP address - `192.168.64.3/24`
4. *Gateway*: Router gateway - `192.168.64.1`
5. *DNS servers*: ... - `8.8.8.8`

Restart WiFi service...

Check for IP with: `ip addr`

- [Reference](https://www.tecmint.com/nmtui-configure-network-connection/)

### 42.2. Setup SSH

1. Install `openssh`: `sudo pacman -S openssh`
2. Enable service: `sudo systemctl enable sshd.service`
3. Start service: `sudo systemctl start sshd.service`
4. Check that service is running: `systemctl status sshd.service`

### 42.3 Set Up SSH Keys

- If you already have RSA key pair you can just send public key to remote:

  ```bash
  cat ~/.ssh/id_rsa.pub | ssh USERNAME@REMOTE_HOST "mkdir -p ~/.ssh && \
  touch ~/.ssh/authorized_keys && chmod -R go= ~/.ssh && cat >> ~/.ssh/authorized_keys"
  ```

1. Generate private and public RSA key pair: `ssh-keygen -b 4096`
2. Select name that is not the same as default if you want to use multiple/different keys.
3. Create also a password
4. Key pair should now be generated, copy it to `~/.ssh/` folder
5. Run this command to copy public RSA key to client/remote host:
   `cat ~/.ssh/RSA_KEY.pub | ssh USERNAME@REMOTE_HOST "mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys && chmod -R go= ~/.ssh && cat >> ~/.ssh/authorized_keys"`
6. You can now login to remote host with `ssh USERNAME@REMOTE_HOST -i ~/.ssh/RSA_KEY`

- Note that if you use the default RSA key there is no need to pass `-i RSA_KEY`
- [Reference](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-20-04)

### 42.4 Disabling Password Authentication on remote host

- Edit `sudo vim /etc/ssh/sshd_config`
- Uncomment and set to `no`:

  ```text
  /etc/ssh/sshd_config
  -----------------------------------------------
  PasswordAuthentication no
  ```

- [Reference](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-20-04)

### 42.5 Install and enable crontab

1. Install `crontab`: `sudo pacman -S cronie`
2. Enable service: `sudo systemctl enable cronie.service`
3. Start service: `sudo systemctl start cronie.service`
4. Check that service is running: `systemctl status cronie.service`

- [wiki.archlinux.org - cron](https://wiki.archlinux.org/index.php/cron)

## References

- [video - Arch Linux Installation Guide 2020](https://www.youtube.com/watch?v=PQgyW10xD8s)
- [arcolinuxd.com - 5 THE ACTUAL INSTALLATION OF ARCH LINUX PHASE 1 BIOS](https://arcolinuxd.com/5-the-actual-installation-of-arch-linux-phase-1-bios/)
- [wiki.archlinux.org- Installation guide](https://wiki.archlinux.org/index.php/Installation_guide)

## Wifi setup

### References

- [wiki.archlinux.org - iwctl](https://wiki.archlinux.org/index.php/Iwd#iwctl)
- [wiki.archlinux.org - Wireless](https://wiki.archlinux.org/index.php/Network_configuration/Wireless)
- [wiki.archlinux.org - Wireless#Rfkill_caveat](https://wiki.archlinux.org/index.php/Network_configuration/Wireless#Rfkill_caveat)

