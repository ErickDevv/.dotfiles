#!/usr/bin/env bash
set -uo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$HOME/.config"

ALL_CONFIGS=(bspwm sxhkd polybar picom kitty rofi starship)

declare -A CONFIG_BIN=(
    [bspwm]=bspwm
    [sxhkd]=sxhkd
    [polybar]=polybar
    [picom]=picom
    [kitty]=kitty
    [rofi]=rofi
    [starship]=starship
)

# --- Banner ---------------------------------------------------------------
show_banner() {
    clear
    cat <<'EOF'
   ___     ___     ___     ___    _  __    ___     ___   __   __ __   __ 
  | __|   | _ \   |_ _|   / __|  | |/ /   |   \   | __|  \ \ / / \ \ / / 
  | _|    |   /    | |   | (__   | ' <    | |) |  | _|    \ V /   \ V /  
  |___|   |_|_\   |___|   \___|  |_|\_\   |___/   |___|   _\_/_   _\_/_  
_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_| """"|_| """"| 
"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-' 
EOF
    sleep 1
}

# --- Dependency check -------------------------------------------------------
check_dependencies() {
    echo "Comprobando programas a configurar..."
    local name bin missing=()
    for name in "${ALL_CONFIGS[@]}"; do
        bin="${CONFIG_BIN[$name]}"
        if command -v "$bin" >/dev/null 2>&1; then
            echo "  ✓ $bin"
        else
            echo "  ✗ $bin (falta)"
            missing+=("$bin")
        fi
    done

    if [ "${#missing[@]}" -eq 0 ]; then
        echo "  Todos los programas están instalados."
        echo
        return
    fi

    echo
    echo "Faltan programas: ${missing[*]}" >&2
    echo "Instálalos con el gestor de paquetes de tu sistema." >&2
    exit 1
}

# --- Package manager detection ----------------------------------------------
detect_pkg_manager() {
    if command -v apt-get >/dev/null 2>&1 || command -v apt >/dev/null 2>&1; then
        echo "apt"
    else
        echo "desconocido"
    fi
}

# --- Predependency install via setup.sh --------------------------------------
offer_install_predependencies() {
    local pkg_manager="$1"

    if [ "$pkg_manager" != "apt" ]; then
        return
    fi

    read -rp "Se detectó APT. ¿Instalar predependencias con setup.sh? [s/N]: " reply
    case "$reply" in
        [sS]|[sS][iI])
            "$DOTFILES/setup.sh" "$pkg_manager"
            ;;
        *)
            echo "  → instalación de predependencias omitida."
            ;;
    esac
    echo
}

# --- Desktop environment detection ----------------------------------------
detect_de() {
    local de="${XDG_CURRENT_DESKTOP:-${DESKTOP_SESSION:-}}"

    if [ -z "$de" ]; then
        if pgrep -x bspwm >/dev/null 2>&1; then
            de="bspwm"
        elif pgrep -x i3 >/dev/null 2>&1; then
            de="i3"
        else
            de="desconocido"
        fi
    fi

    echo "$de"
}

# --- Validar sincronización (repo vs instalado) ------------------------------
check_sync() {
    local name="$1"
    local src="$DOTFILES/$name"
    local dest="$TARGET/$name"
    if [ "$name" = "starship" ]; then
        src="$DOTFILES/starship/starship.toml"
        dest="$TARGET/starship.toml"
    fi

    if [ ! -e "$dest" ]; then
        echo "no instalado"
    elif diff -rq "$src" "$dest" >/dev/null 2>&1; then
        echo "sincronizado"
    else
        echo "diferente"
    fi
}

# --- Mostrar contenido de una config ----------------------------------------
show_config() {
    local name="$1"
    local src="$DOTFILES/$name"
    [ "$name" = "starship" ] && src="$DOTFILES/starship/starship.toml"

    {
        echo "--- $name ($src) ---"
        if [ -d "$src" ]; then
            find "$src" -type f | sort | while IFS= read -r f; do
                echo
                echo "## $f"
                cat "$f"
            done
        elif [ -f "$src" ]; then
            cat "$src"
        else
            echo "(no existe: $src)"
        fi
    } | "${PAGER:-less}" -R
}

# --- Config selector (menú con flechas) --------------------------------------
select_configs() {
    if ! [ -t 0 ] || ! command -v tput >/dev/null 2>&1; then
        select_configs_fallback
        return
    fi

    local items=("${ALL_CONFIGS[@]}")
    local n=${#items[@]}
    local checked=()
    local i cursor=0 key key2
    for ((i = 0; i < n; i++)); do checked[i]=0; done

    local old_stty
    old_stty="$(stty -g)"
    trap 'stty "$old_stty" 2>/dev/null; tput cnorm >&2; echo >&2; exit 130' INT TERM
    stty -echo -icanon time 0 min 0
    tput civis >&2

    draw_menu() {
        echo "↑/↓ mover  espacio marcar  a=todas  v=ver config  Enter confirmar  q/Esc salir" >&2
        for ((i = 0; i < n; i++)); do
            local prefix="  " box="[ ]" status
            [ "$i" -eq "$cursor" ] && prefix="➤ "
            [ "${checked[$i]}" -eq 1 ] && box="[x]"
            status="$(check_sync "${items[$i]}")"
            printf "%s%s %s (%s)\n" "$prefix" "$box" "${items[$i]}" "$status" >&2
        done
    }

    local menu_lines=$((n + 1))
    draw_menu

    while true; do
        IFS= read -rsn1 key
        if [ "$key" = $'\x1b' ]; then
            IFS= read -rsn2 -t 0.01 key2 || key2=""
            key+="$key2"
        fi
        case "$key" in
            $'\x1b[A') # arriba
                ((cursor--)); [ "$cursor" -lt 0 ] && cursor=$((n - 1)) ;;
            $'\x1b[B') # abajo
                ((cursor++)); [ "$cursor" -ge "$n" ] && cursor=0 ;;
            ' ')
                if [ "${checked[$cursor]}" -eq 1 ]; then checked[$cursor]=0; else checked[$cursor]=1; fi ;;
            a|A)
                local all_on=1
                for ((i = 0; i < n; i++)); do [ "${checked[$i]}" -eq 0 ] && all_on=0 && break; done
                for ((i = 0; i < n; i++)); do checked[$i]=$((1 - all_on)); done ;;
            v|V)
                stty "$old_stty"
                tput cnorm >&2
                show_config "${items[$cursor]}"
                stty -echo -icanon time 0 min 0
                tput civis >&2
                tput clear >&2
                draw_menu
                continue
                ;;
            ''|$'\n'|$'\r')
                break ;;
            q|Q|$'\x1b')
                stty "$old_stty"
                tput cnorm >&2
                trap - INT TERM
                echo "Saliendo." >&2
                exit 0
                ;;
        esac
        tput cuu "$menu_lines" >&2
        tput ed >&2
        draw_menu
    done

    stty "$old_stty"
    tput cnorm >&2
    trap - INT TERM

    local selected=()
    for ((i = 0; i < n; i++)); do
        [ "${checked[$i]}" -eq 1 ] && selected+=("${items[$i]}")
    done

    echo "${selected[@]}"
}

# --- Config selector (fallback sin TTY/tput) ----------------------------------
select_configs_fallback() {
    echo "Configs disponibles:" >&2
    local i status
    for i in "${!ALL_CONFIGS[@]}"; do
        status="$(check_sync "${ALL_CONFIGS[$i]}")"
        printf "  [%d] %s (%s)\n" "$((i + 1))" "${ALL_CONFIGS[$i]}" "$status" >&2
    done
    printf "  [%d] Todas\n" "$((${#ALL_CONFIGS[@]} + 1))" >&2
    printf "  [%d] Salir\n" "$((${#ALL_CONFIGS[@]} + 2))" >&2

    local choices
    while true; do
        read -rp "Elige config(s) a instalar (ej: 1 3 4, 'todas', 'salir', 'ver N' para previsualizar): " -a choices
        if [ "${#choices[@]}" -eq 2 ] && [[ "${choices[0]}" =~ ^[Vv]er$ ]] && [[ "${choices[1]}" =~ ^[0-9]+$ ]] \
            && [ "${choices[1]}" -ge 1 ] && [ "${choices[1]}" -le "${#ALL_CONFIGS[@]}" ]; then
            show_config "${ALL_CONFIGS[$((choices[1] - 1))]}"
            continue
        fi
        break
    done

    local salir_idx=$((${#ALL_CONFIGS[@]} + 2))
    local selected=()
    for c in "${choices[@]}"; do
        if [[ "$c" =~ ^[Ss]alir$ ]] || [ "$c" = "$salir_idx" ]; then
            echo "Saliendo." >&2
            exit 0
        fi
        if [[ "$c" =~ ^[Tt]odas$ ]] || [ "$c" = "$((${#ALL_CONFIGS[@]} + 1))" ]; then
            selected=("${ALL_CONFIGS[@]}")
            break
        fi
        if [[ "$c" =~ ^[0-9]+$ ]] && [ "$c" -ge 1 ] && [ "$c" -le "${#ALL_CONFIGS[@]}" ]; then
            selected+=("${ALL_CONFIGS[$((c - 1))]}")
        fi
    done

    echo "${selected[@]}"
}

# --- Install one config ------------------------------------------------------
install_config() {
    local name="$1"
    local src="$DOTFILES/$name"
    local dest="$TARGET/$name"

    if [ "$name" = "starship" ]; then
        src="$DOTFILES/starship/starship.toml"
        dest="$TARGET/starship.toml"
    fi

    if [ ! -e "$src" ]; then
        echo "  ✗ $name: no existe en el repo ($src), se omite."
        return
    fi

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        read -rp "  '$dest' ya existe. ¿Reemplazar? [s/N]: " reply
        case "$reply" in
            [sS]|[sS][iI])
                rm -rf "$dest"
                ;;
            *)
                echo "  → $name omitido."
                return
                ;;
        esac
    fi

    mkdir -p "$(dirname "$dest")"
    ln -sf "$src" "$dest"
    echo "  ✓ $name instalado en $dest"
}

# --- Restart bspwm/sxhkd -----------------------------------------------------
restart_bspwm() {
    read -rp "¿Reiniciar BSPWM y SXHKD? [s/N]: " reply
    case "$reply" in
        [sS]|[sS][iI])
            if command -v bspc >/dev/null 2>&1; then
                bspc wm -r
                echo "  ✓ BSPWM reiniciado."
            else
                echo "  ✗ bspc no encontrado, no se pudo reiniciar BSPWM."
            fi
            if pgrep -x sxhkd >/dev/null 2>&1; then
                pkill -USR1 sxhkd
                echo "  ✓ SXHKD reiniciado."
            else
                echo "  ✗ sxhkd no está corriendo."
            fi
            ;;
        *)
            echo "  → reinicio omitido."
            ;;
    esac
}

# --- Main --------------------------------------------------------------------
main() {
    show_banner

    local pkg_manager
    pkg_manager="$(detect_pkg_manager)"
    offer_install_predependencies "$pkg_manager"

    check_dependencies

    local de
    de="$(detect_de)"
    echo "Entorno de escritorio detectado: $de"
    echo

    local selection
    selection="$(select_configs)"

    if [ -z "$selection" ]; then
        echo "No se seleccionó ninguna config. Saliendo."
        exit 0
    fi

    echo
    echo "Instalando configs..."
    for cfg in $selection; do
        install_config "$cfg"
    done

    if [ "$de" = "bspwm" ]; then
        echo
        restart_bspwm
    fi

    echo
    echo "Listo."
}

main "$@"
