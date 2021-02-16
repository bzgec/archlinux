
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

### Get key events/codes
- `xev`

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
