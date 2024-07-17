#!/bin/bash

configPath="${HOME}/.config"

rutas=("$configPath/bspwm/bspwmrc" "$configPath/sxhkd/sxhkdrc" "${HOME}/.xinit")

for ruta in "${rutas[@]}"; do

{
    cp "$ruta" . > /dev/null 2>&1
} || {
           echo "🟥 $ruta"
           exit 1
}
           echo "🟩 $ruta"
done