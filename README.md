
# ArchLinux
My ArchLinux setup...
- [nvim](./scripts/nvim/README.md)
- [paru](https://github.com/Morganamilo/paru) - AUR helper and pacman wrapper
- [Alacritty](https://github.com/alacritty/alacritty) - terminal emulator
- [Starship](https://starship.rs) - shell prompt - [config](./config/starship.toml)
- Window Managers:
  - Bare bone:
    - [dwm](https://dwm.suckless.org/) - C
  - Not so bare bone:
    - [qtile](http://www.qtile.org/) - Python
    - **[awesomewm](https://awesomewm.org/) - Lua**
- Display manager (login manager):
  - [LightDM](https://wiki.archlinux.org/index.php/LightDM)
- Application launcher
  - [rofi](https://github.com/davatorium/rofi) - A window switcher, Application launcher and dmenu replacement
  ([wiki.archlinux.org](https://wiki.archlinux.org/index.php/Rofi))
  - [dmenu](https://wiki.archlinux.org/index.php/dmenu) - dynamic menu for X

## CPU
- [Ryzen - wiki.archlinux.org](https://wiki.archlinux.org/index.php/Ryzen)
- [microcode - wiki.wrchlinux.org](https://wiki.archlinux.org/index.php/microcode)

## GPU
- [NVIDIA](https://wiki.archlinux.org/index.php/NVIDIA)
- [optimus manager](https://github.com/Askannz/optimus-manager)
  ([wiki.archlinux.org](https://wiki.archlinux.org/index.php/NVIDIA_Optimus))

## Media programs
- vlc
- obs-studio
- [peek](https://github.com/phw/peek) - animated GIF recorder
- [flameshot](https://github.com/flameshot-org/flameshot) - screenshot software

## Other
- [reflector](https://wiki.archlinux.org/index.php/reflector) - retrieve the latest mirror list from
  the Arch Linux Mirror Status page, filter the most up-to-date mirrors, sort them by speed and
  overwrite the file `/etc/pacman.d/mirrorlist`
- [snapper](https://wiki.archlinux.org/index.php/snapper)
- [qbittorrent](https://archlinux.org/packages/community/x86_64/qbittorrent/) - BitTorrent client
- [Redshift](https://github.com/jonls/redshift) - [config](./config/redshift.toml)
  ([wiki.archlinux.org](https://wiki.archlinux.org/index.php/redshift))
- [Element](https://element.io/) - messaging app
- [Discord](https://discord.com/) ([wiki.archlinux.org](https://wiki.archlinux.org/index.php/Discord))
- [backup to external hard drive](./scripts/backupScript/README.md)
## TODO
- closing the lid, pressing power button

- DistroTube [video](https://www.youtube.com/watch?v=FX26s8INUYo) explaining what you typically need

- Copy configuration files to `~/.config/` folder: `bash copyConfig.sh`

### Map `caps lock` to `backspace`
- `setxkbmap -option caps:backspace`
- automatically ran on startup

### Second keyboard doesn't have the same layout
- get the device number: `libinput list-devices`
  (the number after `/dev/input/event`)
- set new keyboard layout: `setxkbmap -device [device_number] si`

### Get key events/codes
- `xev` (xorg-xev package)

### Touchpad reverse scrolling direction
- Edit `/usr/share/X11/xorg.conf.d/40-libinput.conf` and add
  `Option "NaturalScrolling" "true"` to touchpad setting:
```
Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
        Option "NaturalScrolling" "true"
        Option "Tapping" "on"
        Option "DisableWhileTyping" "on"
EndSection
```

### Brightness control with xbacklight
If you don't have permission check [arch wiki](https://wiki.archlinux.org/index.php/Backlight)
(know that user must be in `video` group (`usermod -aG video <user>`))
If you get `No outputs have backlight property` error when running it `xbacklight`.
- Add `/usr/share/X11/xorg.conf.d/50-backlight.conf`
```
Section "Device"
    Identifier  "Intel Graphics"
    Driver      "intel"
    Option      "Backlight"  "intel_backlight"
EndSection
```
[This](https://askzorin.com/t/error-while-setting-up-custom-brightness-keys-with-xbacklight/105/3) link helped me.
I had `/sys/class/backlight/intel_backlight`.

### Can't control sound with amixer
My error was: `amixer: Unable to find simple control 'Master',0`
1. Print available cards: `cat /proc/asound/cards`
```
/proc/asound/cards
---------------------------------------------------------------
 0 [NVidia         ]: HDA-Intel - HDA NVidia
                      HDA NVidia at 0xd1000000 irq 96
 1 [Generic        ]: HDA-Intel - HD-Audio Generic
                      HD-Audio Generic at 0xd15c0000 irq 97
```
   We can see that our card is `1` and not `0`

2. Edit `/usr/share/alsa/alsa.conf` and change `defaults.ctl.card` and `defaults.pcm.card`:
   (previously it was `0` now set it to `1`)
```
/usr/share/alsa/alsa.conf
----------------------------------
defaults.ctl.card 1
defaults.pcm.card 1
```
#### Resources
- [askubuntu.com](https://askubuntu.com/a/673334)
- [bss.asrchlinux.org - Alsa audio won't work](https://bbs.archlinux.org/viewtopic.php?id=200806)

### Mount disk at boot
We are doing the right way - with `fstab`
1. Get UUID of the disk: `ls -al /dev/disk/by-uuid/`
2. Get file system format of the partition: `file -sL /dev/sd*`
3. Configure `fstab` file: `sudo vim /etc/fstab`
```
/etc/fstab
----------------------------------------------------------------------------------------------------
# Static information about the filesystems.
# See fstab(5) for details.

# <file system> <dir> <type> <options> <dump> <pass>
# /dev/nvme0n1p3
UUID=C25684FB5684F189	/win10    	ntfs      	rw,nosuid,nodev,user_id=0,group_id=0,allow_other,blksize=4096	0 0

# /dev/nvme0n1p7
UUID=20cce99b-5a1f-4e98-9a1e-351f31df1c4c	/home     	btrfs     	rw,noatime,compress=lzo,ssd,space_cache=v2,subvolid=257,subvol=/@home,subvol=@home	0 0

# /dev/nvme0n1p6
UUID=eb530593-0307-4678-a1f2-9c9065574950	none      	swap      	defaults  	0 0

# /dev/sda1
UUID=7D524647407BEC2A	/home/bzgec/SlimBoi      	ntfs      	defaults  	0 0
```
#### Resources
- [random post](https://confluence.jaytaala.com/display/TKB/Mount+drive+in+linux+and+set+auto-mount+at+boot)
- [get partition (fs) format - unix.stackexchange.com](https://unix.stackexchange.com/a/60783)

### Disable microphone
- [ALSA - Advanced Linux Sound Architecture](https://wiki.archlinux.org/index.php/Advanced_Linux_Sound_Architecture)
- Toggle microphone: `amixer set Capture toggle`

## Using
### pacman
- `--needed`: Do not reinstall the targets that are already up-to-date.
- `-S`: Install packages.
- `-R`: Remove a package (keep dependencies).
- `-Rs`: Remove a package and remove dependencies which are not required by any other installed
         package. If it fails on a group try `-Rsu`.
- `-Qtd`: check for packages that were installed as a dependency but now, no other packages depend
          on them
- Generally avoid using:
  - `--overwrite`: pacman will bypass file conflict checks
  - `-Sy`: partial upgrades (use `-Syu`)
  - `-d`: skips dependency checks during package removal
  -  [AUR helpers](https://wiki.archlinux.org/index.php/AUR_helpers) which automate installation
     of AUR packages (yay, paru)
#### References
- [wiki.archlinux.org - pacman](https://wiki.archlinux.org/index.php/pacman)
- [wiki.archlinux.org - System maintenance](https://wiki.archlinux.org/index.php/System_maintenance)

## KDE (Plasma)
- [wiki.archlinux.org - KDE](https://wiki.archlinux.org/index.php/KDE)
- [Display manager](https://wiki.archlinux.org/index.php/Display_manager#Loading_the_display_manager)
  `sudo pacman -S xorg plasma kde-applications`
  `sudo systemctl enable sddm.service`
  Check the default target to boot into: `systemctl get-default`, it should return `graphical.target`
  KDE (Plasma) should now work.

## Random
**linux-lts** long term support kernel
- [Multi-head, multi-screen, multi-display or multi-monitor](https://wiki.archlinux.org/index.php/Multihead)
- Keyboard configuration:
  - [Xorg](https://wiki.archlinux.org/index.php/Xorg/Keyboard_configuration) - only for Desktop
    Environment
  - [Linux console](https://wiki.archlinux.org/index.php/Linux_console/Keyboard_configuration) -
    only for virtual console
- Connect to WiFI - [Network Manager](https://wiki.archlinux.org/index.php/NetworkManager)
  - `nmcli` - command line interface
  - `nmtui` - ncurses base interface

## TODO list
- Fix bad DPI
- Display GPU temperature
- Widget for volume control, and play buttons

### Done
- Microphone ON/OFF
