#!/usr/bin/env bash
set -uo pipefail

PKG_MANAGER="${1:-apt}"

install_apt() {
    sudo apt update

    sudo apt install -y \
    bspwm \
    sxhkd \
    polybar \
    rofi \
    picom \
    kitty \
    ranger \
    tmux \
    fastfetch \
    fzf \
    bat \
    eza \
    btop \
    zathura \
    mpv \
    nitrogen
}

case "$PKG_MANAGER" in
    apt)
        install_apt
        ;;
    *)
        echo "Empaquetador no soportado: $PKG_MANAGER" >&2
        echo "Soportados actualmente: apt" >&2
        exit 1
        ;;
esac
