#!/bin/bash
# Habilitar Flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Instalar aplicaciones requeridas (Steam, Heroic, Ardour, Minecraft)
flatpak install -y flathub \
    com.valvesoftware.Steam \
    com.heroicgameslauncher.hgl \
    org.ardour.Ardour \
    com.mojang.MinecraftLauncher

# Anclaje automático de Ardour al dock/dash (Usando la configuración de GNOME/dconf)
# Nota: Esto es complejo y la clave dconf puede variar en COSMIC. Usaremos la clave estándar de GNOME.
# Obtenemos la lista actual de favoritos.
CURRENT_FAVS=$(gsettings get org.gnome.shell favorite-apps | sed "s/]//" | sed "s/\[//" | sed "s/'$//" | tr -d '\n')

# Definimos el ID de Ardour
ARDOUR_ID='org.ardour.Ardour.desktop'

# Añadimos Ardour a la lista si no está ya
if [[ $CURRENT_FAVS == *"$ARDOUR_ID"* ]]; then
    echo "Ardour ya está en favoritos."
else
    # Si la lista no está vacía, añadimos una coma
    if [[ -n "$CURRENT_FAVS" ]]; then
        NEW_FAVS="$CURRENT_FAVS, '$ARDOUR_ID']"
    else
        NEW_FAVS="'$ARDOUR_ID']"
    fi
    # Aplicamos la nueva lista.
    gsettings set org.gnome.shell favorite-apps "['$NEW_FAVS"
fi
