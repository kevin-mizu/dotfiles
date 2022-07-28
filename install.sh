#!/bin/bash
# inspired by https://github.com/Ooggle/dotfiles/

# intro
echo ""
echo "--------------------------------------------------"
echo "            - Auto configure script -             "
echo "   This script need to run with root privileges.  "
echo "Please use this with a Ubuntu/Debian based distro."
echo "--------------------------------------------------"
echo ""

echo ""
echo "--------------------------------------------------"
echo "            - Installing dependencies -           "
echo "--------------------------------------------------"
echo ""

# update & upgrade
apt update && apt upgrade -y

# install base dependencies
apt install -y xorg i3 i3blocks

# install dependencies
apt install -y build-essential feh maim scrot xclip light pulseaudio \
ffmpeg imagemagick libncurses5-dev git make xdg-utils pkg-config vim lxappearance \
gsettings-desktop-schemas xinput ncdu rofi notepadqq libnotify-bin playerctl neofetch \
bat apt-transport-https curl vlc lxterminal ltrace

# brave
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
apt update && apt install -y brave-browser

# python
apt install -y python2 python3 python3-pip python-is-python3
wget https://bootstrap.pypa.io/pip/2.7/get-pip.py -O /tmp/get-pip.py && python2.7 /tmp/get-pip.py

# discord canary
wget https://discordapp.com/api/download/canary?platform=linux -O /tmp/discord.deb
apt install -y /tmp/discord.deb

# config light suid
chmod +s /usr/bin/light


# i3 rounded corner
echo ""
echo "--------------------------------------------------"
echo "   - Installing i3 Gaps (temporarly disabled) -   "
echo "--------------------------------------------------"
echo ""

# i3 gaps dependences
apt install -y i3 meson libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev \
libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev \
libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev \
libxkbcommon-dev libxkbcommon-x11-dev autoconf libxcb-xrm0 libxcb-xrm-dev \
automake libxcb-shape0-dev

# build
git clone https://www.github.com/Airblader/i3 /tmp/i3-gaps && cd /tmp/i3-gaps
mkdir -p build && cd build
meson ..
ninja

# remove useless dependences
apt remove -y meson libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb1-dev \
libxcb-icccm4-dev libyajl-dev libev-dev libxcb-xkb-dev libxcb-cursor-dev libxkbcommon-dev \
libxcb-xinerama0-dev libxkbcommon-x11-dev libstartup-notification0-dev libxcb-randr0-dev \
libxcb-xrm-dev libxcb-shape0-dev


# installing dotfiles
echo ""
echo "--------------------------------------------------"
echo "              - Installing dotfiles -             "
echo "--------------------------------------------------"
echo ""

# git clone dotfiles
git clone https://github.com/kevin-mizu/dotfiles.git /tmp/dotfiles
cd /tmp/dotfiles

# home directory
chown 1000:1000 -R home/
cat home/.bashrc >> ~/.bashrc
rm home/.bashrc
cp -ar home/. ~/

# usr directory
cp -ar usr/. /usr/

# misc
python -m pip install -r python-requirements.txt


echo ""
echo "--------------------------------------------------"
echo "                - Other configs -"
echo "--------------------------------------------------"
echo ""

# brave as default browser
xdg-mime default brave-browser.desktop x-scheme-handler/http

# lxterminal as default terminal
ln -sf /usr/bin/lxterminal /etc/alternatives/x-terminal-emulator

# cleaning
echo ""
echo "--------------------------------------------------"
echo "                 - Cleaning files -               "
echo "--------------------------------------------------"
echo ""

rm -rf /tmp/*
cd


# finish
echo ""
echo "--------------------------------------------------"
echo "             - Configuration complete.            "
echo "--------------------------------------------------"
echo ""
