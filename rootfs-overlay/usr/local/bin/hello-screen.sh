#!/bin/bash

# Asegúrate de que XDG_RUNTIME_DIR esté configurado para la sesión gráfica
export XDG_RUNTIME_DIR="/run/user/$(id -u)"

# Lanza una ventana de bienvenida simple (requiere zenity o YAD instalado, o puedes usar una app GTK propia)
# Necesitarías instalar 'zenity' o similar en el Containerfile si eliges este método.
zenity --info --title="Bienvenido a CosmicOS" --text="¡Hola! Su nuevo sistema operativo estilo macOS está listo.\nDisfrute de la experiencia personalizada." --width=400 --height=150

# Opcional: Ejecutar un reproductor de video para un efecto animado (requiere 'mpv' o similar)
# mpv --fs --loop=no /usr/share/videos/welcome.mp4

# Marca la instalación como completada
touch /var/lib/cosmic-os/welcome_ran
