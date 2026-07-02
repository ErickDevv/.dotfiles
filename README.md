# .dotfiles

Config personal para BSPWM en Linux.

## Componentes

| Programa | Rol |
|----------|-----|
| bspwm | Window manager |
| sxhkd | Keybindings |
| polybar | Status bar |
| picom | Compositor |
| kitty | Terminal |
| rofi | Launcher |
| starship | Prompt |

## Instalación

```bash
git clone https://github.com/ErickDevv/.dotfiles ~/Documentos/.dotfiles
cd ~/Documentos/.dotfiles
bash install.sh
```

## Keybindings

### General

| Key | Acción |
|-----|--------|
| `Super + Return` | Abrir terminal (kitty) |
| `Super + D` | Lanzar rofi |
| `Super + Q` | Cerrar ventana |
| `Super + Alt + R` | Reiniciar bspwm |

### Navegación

| Key | Acción |
|-----|--------|
| `Super + H` | Foco → izquierda |
| `Super + J` | Foco → abajo |
| `Super + K` | Foco → arriba |
| `Super + L` | Foco → derecha |

### Mover ventanas

| Key | Acción |
|-----|--------|
| `Super + Shift + H` | Mover → izquierda |
| `Super + Shift + J` | Mover → abajo |
| `Super + Shift + K` | Mover → arriba |
| `Super + Shift + L` | Mover → derecha |

### Resize

| Key | Acción |
|-----|--------|
| `Super + Alt + H` | Resize → izquierda |
| `Super + Alt + J` | Resize → abajo |
| `Super + Alt + K` | Resize → arriba |
| `Super + Alt + L` | Resize → derecha |

### Escritorios

| Key | Acción |
|-----|--------|
| `Super + 1-9` | Ir a escritorio N |
| `Super + Shift + 1-9` | Mover ventana a escritorio N |

## Estructura

```
.dotfiles/
├── bspwm/
│   └── bspwmrc
├── sxhkd/
│   └── sxhkdrc
├── polybar/
│   ├── config.ini
│   └── launch.sh
├── picom/
│   └── picom.conf
├── kitty/
│   └── kitty.conf
├── starship/
│   └── starship.toml
└── install.sh
```
