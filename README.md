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
./welcome.sh
```

`welcome.sh` es el instalador interactivo:

- Detecta el gestor de paquetes (por ahora solo **APT**) y, si lo encuentra, ofrece instalar las predependencias vía `setup.sh`.
- Comprueba qué programas (bspwm, sxhkd, polybar, picom, kitty, rofi, starship) están instalados.
- Detecta el entorno de escritorio actual.
- Muestra un menú para elegir qué configs symlinkear a `~/.config`:
  - `↑/↓` mover, `espacio` marcar, `a` marcar/desmarcar todas, `v` previsualizar la config seleccionada, `Enter` confirmar, `q`/`Esc` salir.
  - Cada config muestra su estado de sincronización: `sincronizado`, `diferente` o `no instalado` (compara el archivo/carpeta del repo contra lo instalado en `~/.config`).
- Si el entorno es bspwm, ofrece reiniciar bspwm/sxhkd al terminar.

`setup.sh` instala las predependencias del sistema y acepta el gestor de paquetes como parámetro (por defecto `apt`, único soportado por ahora):

```bash
./setup.sh apt
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
├── setup.sh
├── welcome.sh
```
