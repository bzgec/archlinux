# Install
- Dualboot with Windows 10 - [video](https://www.youtube.com/watch?v=L1B1O0R1IHA)
- Btrfs with snapper - [video](https://www.youtube.com/watch?v=Xynotc9BKe8)
- [Installation guide - wiki.archlinux.org](https://wiki.archlinux.org/index.php/installation_guide)
Note that for installation you need internet connection
1. Set up the correct keyboard: `ls /usr/share/kbd/keymaps/**/*.map.gz | less`
2. Select keyboard: `loadkeys slovene.map.gz`
3. Check if wireless card is not blocked: `rfkill list`
4. Connect to WiFi:
   1. `iwctl`
   2. First, if you do not know your wireless device name, list all Wi-Fi devices: `device list`
   3. Then, to scan for networks: `station [device] scan`
   4. You can then list all available networks: `station [device] get-networks`
   5. Finally, to connect to a network: `iwctl --passphrase [passphrase] station [device] connect [SSID]`
   6. Done
5. Plug in ethernet cable and check if you have connection: `ping google.com`
6. Update the system clock: `timedatectl set-ntp true`.
   You can verify it with: `timedatectl status`
7. Update the mirrors: `sudo pacman -Syy`
8. Get best mirrors: `sudo pacman -S reflector && reflector --verbose --latest 10 --sort rate --save /etc/pacman.d/mirrorlist`
9. Update the mirrors: `sudo pacman -Syy`
10. Partition the disks - [wiki.archlinux.org](https://wiki.archlinux.org/index.php/Partitioning)
   1. Verify if you have BIOS or UEFI: `ls /sys/firmware/efi/efivars` (if no error than you have UEFI)
   2. Identify devices: `lsblk`
   3. Open selected disk: `fdisk /dev/sda` or `fdisk /dev/nvme0n1`
     - list free unpartitioned space
     - 1. `o` to select MBR/DOS partition table
       1. Create new partition: `n`
       2. Set partition type to primary: `p`
       3. Set partition number to 1: `1`
       4. Set first sector (where to start first sector) - leave default (just hit enter)
       5. Set swap size (equals to RAM size): `+2G`
       6. If some error occurs about type just ignore it
       7. Set rest of the disk size: `n`, `p`, `2`, default, default (all remaining memory)
       8. Change swap partition type: `t`, `1`, `82` (this should be checked with `L`
       9. Enable boot from linux partition: `a`, `2`
     - 1. `g` to select GPT partition table (skip if Windows 10 is already installed)
       1. Create efi partition: `n`, `1`, default, `+550M`  TODO: is EFI partition really necessary if Windows 10 is already installed?
       2. Create swap partition: `n`, `2`, default, `+16G` (size of RAM)
       3. Create Linux partition: `n`, `3`, default, default
       4. Change partitions type:
          1. `t`, `1`, `1` (check with `l` - EFI)
          2. `t`, `2`, ``19` (check with `l` - swap)
          3. Already Linux file system
   4. Write table to disk: `w`
11. Make file systems:
   1. EFI: `mkfs.fat -F32 /dev/sda1` (only if using UEFI)
   2. swap:
      1. Create swap: `mkswap /dev/sda1` or `mkswap /dev/sda2`
      2. Turn on swap: `swapon /dev/sda1` or `swapon /dev/sda2`
   3. Big partition: `mkfs.ext4 /dev/sda2` or `mkfs.ext4 /dev/sda3` or `mkfs.btrfs /dev/nvme0n1p7`
12. Mound the big partition: `mount /dev/sda2 /mnt` or `mount /dev/sda3 /mnt`
13. Btrfs only:
    1. Create *root* subvolume: `btrfs su cr /mnt/@`
    2. Create *home* subvolume: `btrfs su cr /mnt/@home`
    3. Create *snapshots* subvolume: `btrfs su cr /mnt/@snapshots`
    4. Create *var_log* subvolume: `btrfs su cr /mnt/@var_log`
    5. Unmount `/mnt`: `umount /mnt`
    6. Mount *root* subvolume with btrfs:`mount -o noatime,compress=lzo,space_cache=v2,subvol=@ /dev/nvme0n1p7 /mnt`
    7. Make directories: `mkdir -p /mnt/{boot,home,.snapshots,var_log}`
    8. Mount other subvmolumes:
       1. `mount -o noatime,compress=lzo,space_cache=v2.subvol=@home /dev/nvme0n1p7 /mnt/home`
       2. `mount -o noatime,compress=lzo,space_cache=v2.subvol=@snapshots /dev/nvme0n1p7 /mnt/.snapshots`
       3. `mount -o noatime,compress=lzo,space_cache=v2.subvol=@var_log /dev/nvme0n1p7 /mnt/var_log`
       4. `mount /dev/nvme0n1p5 /mnt/boot`
    9. Mount Windows 10: `mkdir /mnt/win10 && mount /dev/nvme0n1p3 /mnt/win10`
14. Install essential packages (base system): `pacstrap /mnt base linux linux-firmware vim amd-ucode`
15. Generate file system table: `genfstab -U /mnt >> /mnt/etc/fstab`
    We can check if everything is ok with: `cat /mnt/etc/fstab`
16. Change root into the new system: `arch-chroot /mnt`
17. Set timezone: `ln -sf /usr/share/zoneinfo/Europe/Ljubljana /etc/localtime` (you can help
   yourself with `ls /usr/share/zoneinfo`)
12. Set hardware clock: `hwclock --systohc`
13. Select locale: `vim /etc/locale.gen`, uncomment `en_US.UTF-8 UTF-8` and `sl_SI.UTF-8 UTF-8`
14. Generate the locales: `locale-gen`
15. Set the `LANG` variable: `vim /etc/locale.conf`, enter `LANG=en_US.UTF-8` (or simpler just:
    `echo "LANG=en_US.UTF-8" >> /etc/locale.conf`)
16. Make Arch Linux remember keyboard layout: `vim /etc/vconsole.conf`, enter `KEYMAP=slovene.map.gz`
    (or simpler: `echo "KEYMAP=slovene.map.gz" >> /etc/vconsole.conf`)
17. Create hostname: `vim /etc/hostname`, input just the hostname: `arch` (or simpler:
    `echo "arch" >> /etc/hostname`)
18. Add hostname to hosts: `vim /etc/hosts`, add this lines:
    ```
    127.0.0.1    localhost
    ::1          localhost
    127.0.1.1    arch.localdomain arch
    ```
19. Create root password: `passwd`, enter root password
20. `pacman -S --noconfirm sudo grub networkmanager network-manager-applet wireless_tools wpa_supplicant efibootmgr ntfs-3g dosfstools os-prober mtools base-devel linux-headers git bash-completion`
21. Set `EDITOR` environment variable: `echo "export EDITOR=vim" >> /etc/profile`
21. Btrfs only:
    1. Add `btrfs` into modules in `vim /etc/mkinitcpio.conf` file (`MODULES=(btrfs)`)
    2. Recreate kernel image with btrfs module included: `mkinitcpio -p linux`
22. Init grub: `grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB`
23. Generate grub configuration: `grub-mkconfig -o /boot/grub/grub.cfg`
    (you should see Linux and Windows 10 images)
24. Enable previously installed packages:
    1. `systemctl enable NetworkManager`
    2. `systemctl enable bluetooth`
    3. `systemctl enable wpa_supplicant`
25. Create user: `useradd -mG wheel bzgec`, `passwd bzgec`, enter password
26. Add user to groups: `usermod -aG wheel,audio,video,optical,storage bzgec`
27. Add user to use sudo privileges: `EDITOR=vim visudo`, uncomment line `%wheel ALL=(ALL) ALL`
28. Enable hibernation:
    1. Add kernel parameter (add `resume=` parameter):
        1. Edit `/etc/default/grub` and append your kernel options between the quotes in the
          `GRUB_CMDLINE_LINUX_DEFAULT` line:
          ```
          /etc/default/grub
          -------------------------------------------------------------------------
          GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet resume=/dev/nvme0n1p6"
          ```
        2. And then automatically re-generate the `grub.cfg` file with:
           `grub-mkconfig -o /boot/grub/grub.cfg`
    2. Configure the `initramfs` (add `resume` hook). Whether by label or by UUID, the swap
       partition is referred to with a udev device node, so the `resume` hook must go after the
       `udev` hook. This example was made starting from the default hook configuration:
       ```
       /etc/mkinitcpio.conf
       --------------------------------------------------------------------------
       HOOKS=(base udev autodetect modconf block filesystems keyboard resume)
       ```
       [Kernel parameters](https://wiki.archlinux.org/index.php/kernel_parameters)
       [Power management - suspend and hibernate](https://wiki.archlinux.org/index.php/Power_management/Suspend_and_hibernate#Hibernation)
29. Change options for closing the laptop lid, power button press -
    [Power management](https://wiki.archlinux.org/index.php/Power_management#ACPI_events).
    Edit `/etc/systemd/logind.conf`:
    ```
    /etc/systemd/logind.conf
    --------------------------------------------------
    HandlePowerKey=hibernate
    HandleLidSwitch=suspend-then-hibernate
    HandleLidSwitchExternalPower=suspend-then-hibernate
    IdleAction=suspend-then-hibernate
    IdleActionSec=10min
    ```
    You can also change delay between suspend and hibernate, edit `/etc/systemd/sleep.conf`:
    ```
    /etc/systemd/sleep.conf
    --------------------------------------------------
    HibernateDelaySec=120min
    ```
30. `exit`
31. `unmount -R /mnt`
32. `reboot`
33. Connecto to WiFi:
    1. List available WiFis: `nmcli device wifi list`
    2. Connect: `nmcli device wifi connect [SSID] password [PASSWORD]`
    3. List all the connected networks: `nmcli connection show`
    4. Check status of network devices: `nmcli device`
    5. Disconnect network: `nmcli device disconnect [DEVICE]`
    6. Re-connect with a network: `nmcli connection show`
    7. Disable WiFi: `nmcli radio wifi off`
    You could also use `nmtui` - ncurses based interface
34. Clone other automated Arch linux setup: `git clone https://github.com/bzgec/archlinux.git && cd archlinux && git submodule update --init --recursive`

### References
- [video - Arch Linux Installation Guide 2020](https://www.youtube.com/watch?v=PQgyW10xD8s)
- [arcolinuxd.com - 5 THE ACTUAL INSTALLATION OF ARCH LINUX PHASE 1 BIOS](https://arcolinuxd.com/5-the-actual-installation-of-arch-linux-phase-1-bios/)
- [wiki.archlinux.org- Installation guide](https://wiki.archlinux.org/index.php/Installation_guide)

## Wifi setup
### References
- [wiki.archlinux.org - iwctl](https://wiki.archlinux.org/index.php/Iwd#iwctl)
- [wiki.archlinux.org - Wireless](https://wiki.archlinux.org/index.php/Network_configuration/Wireless)
- [wiki.archlinux.org - Wireless#Rfkill_caveat](https://wiki.archlinux.org/index.php/Network_configuration/Wireless#Rfkill_caveat)

