#!/usr/bin/env bash

DOTFILES=~/Documentos/.dotfiles

for dir in bspwm sxhkd polybar picom kitty ranger rofi; do
    mkdir -p ~/.config/$dir
    rsync -a "$DOTFILES/$dir/" ~/.config/$dir/
done

rm -f ~/.config/starship.toml
cp "$DOTFILES/starship/starship.toml" ~/.config/starship.toml

chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/polybar/launch.sh
chmod +x ~/.config/bspwm/scripts/* 2>/dev/null || true

pkill -USR1 sxhkd 2>/dev/null || true

notify-send "Dotfiles" "Config sincronizada" 2>/dev/null || true
