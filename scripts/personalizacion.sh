#!/bin/bash
# Configuración de botones a la izquierda (macOS style)
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'

# Configuración de GRUB (Asume que el tema ya fue copiado a /boot/grub2/themes/ en el overlay)
echo 'GRUB_THEME="/boot/grub2/themes/macos-grub-theme/theme.txt"' >> /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

# Configuración de Plymouth (Asume que el tema ya fue copiado a /usr/share/plymouth/themes/ en el overlay)
plymouth-set-default-theme macos-like -R

# Configuración de la fuente (usando Inter como un proxy para SF Pro)
gsettings set org.gnome.desktop.interface font-name 'Inter 10'
gsettings set org.gnome.desktop.interface document-font-name 'Inter 10'
gsettings set org.gnome.desktop.interface monospace-font-name 'Inter Regular 10'
