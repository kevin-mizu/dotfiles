#!/bin/bash
# inspired by https://github.com/Ooggle/dotfiles/


echo ""
echo "--------------------------------------------------"
echo "              - Installation checks -             "
echo "--------------------------------------------------"
echo ""

# must be root
if [ "$EUID" -ne 0 ]
    then echo -e "\x1b[1m[\x1b[31m-\x1b[0m] This script must be run as root!"
    exit
fi

# home user
USER=mizu


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
bat apt-transport-https curl vlc lxterminal htop compton numlockx pavucontrol \
gcc-multilib fuse libfuse2 gem ruby-rubygems php

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

# docker
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update && apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
groupadd docker && usermod -aG docker $USER

# config light suid
chmod +s /usr/bin/light


# <3
echo ""
echo "--------------------------------------------------"
echo "                  - Cyber Tools -                 "
echo "--------------------------------------------------"
echo ""

# pwn
apt install -y gdb ltrace checksec
bash -c "$(curl -fsSL https://gef.blah.cat/sh)"
gem install one_gadget
sudo -H python3 -m pip install ROPgadget

# network
echo "wireshark-common wireshark-common/install-setuid boolean true" | debconf-set-selections
DEBIAN_FRONTEND=noninteractive apt -y install wireshark tshark nmap

# web
apt install -y gobuster

## postman
wget https://dl.pstmn.io/download/latest/linux64 -O /opt/postman.tar.gz
tar -xvf /opt/postman.tar.gz -C /opt/
rm /opt/postman.tar.gz

# steg
apt install -y exiftools audacity binwalk foremost


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
sudo install ./i3 /bin/i3

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
chmod +x -R ~/sc/

# usr directory
cp -ar usr/. /usr/

# misc
python -m pip install -r python-requirements.txt


# misc
echo ""
echo "--------------------------------------------------"
echo "                - Other configs -"
echo "--------------------------------------------------"
echo ""

# brave as default browser
xdg-mime default brave-browser.desktop x-scheme-handler/http

# lxterminal as default terminal
ln -sf /usr/bin/lxterminal /etc/alternatives/x-terminal-emulator

# login manager Ly
apt install -y libpam0g-dev libxcb-xkb-dev
git clone --recurse-submodules https://github.com/nullgemm/ly && cd ly
make && make install
systemctl disable gdm.service && systemctl enable ly


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
