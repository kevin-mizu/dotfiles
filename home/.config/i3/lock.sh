#!/bin/bash
scrot /tmp/screen.png
convert /tmp/screen.png -scale 20% -scale 500% /tmp/screen.png
[[ -f ~/.config/i3/key.png ]] && convert /tmp/screen.png ~/.config/i3/key.png -gravity center -composite -matte /tmp/screen.png
i3lock -n -i /tmp/screen.png
rm /tmp/screen.png
