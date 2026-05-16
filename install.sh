#!/usr/bin/env bash

mkdir -p ~/.config

ln -sf ~/Documentos/.dotfiles/bspwm ~/.config/
ln -sf ~/Documentos/.dotfiles/sxhkd ~/.config/
ln -sf ~/Documentos/.dotfiles/polybar ~/.config/
ln -sf ~/Documentos/.dotfiles/picom ~/.config/
ln -sf ~/Documentos/.dotfiles/kitty ~/.config/
ln -sf ~/Documentos/.dotfiles/ranger ~/.config/

ln -sf ~/Documentos/.dotfiles/rofi ~/.config/

ln -sf ~/Documentos/.dotfiles/starship/starship.toml ~/.config/starship.toml

chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/polybar/launch.sh
