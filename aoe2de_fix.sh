#!/bin/sh
#
# Run: `source aoe2de_fix.sh`

# https://www.protondb.com/app/813780

cd /home/$USER/.steam/steam/steamapps/compatdata/813780/pfx/drive_c/windows/system32/
wget "https://aka.ms/vs/16/release/vc_redist.x64.exe"
sudo cabextract vc_redist.x64.exe
sudo cabextract a10
cd -
