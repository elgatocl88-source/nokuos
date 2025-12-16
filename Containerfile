# Definición de variables de entorno para personalización
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-base-main}"
ARG SOURCE_ORG="${SOURCE_ORG:-ghcr.io/ublue-os}"
ARG BASE_IMAGE="${SOURCE_ORG}/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-41}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION}

# Variables reutilizables y configuraciones
ARG FLATPAK_RUNTIME_VERSION="23.08"
ARG FLATPAK_RUNTIME_ARCH="x86_64"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-41}"

# Establecer bash en modo estricto para manejo de errores
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Paso 1: Configurar repositorios y paquetes
RUN set -euxo pipefail && \
    if [ "${FEDORA_MAJOR_VERSION}" == "rawhide" ]; then \
        curl -Lo /etc/yum.repos.d/_copr_ryanabx-cosmic.repo \
            https://copr.fedorainfracloud.org/coprs/ryanabx/cosmic-epoch/repo/fedora-rawhide/ryanabx-cosmic-epoch-fedora-rawhide.repo; \
    else \
        curl -Lo /etc/yum.repos.d/_copr_ryanabx-cosmic.repo \
            https://copr.fedorainfracloud.org/coprs/ryanabx/cosmic-epoch/repo/fedora-$(rpm -E %fedora)/ryanabx-cosmic-epoch-fedora-$(rpm -E %fedora).repo; \
    fi && \
    rpm-ostree install \
        cosmic-desktop \
        pipewire-jack \
        wireplumber \
        alsa-utils \
        gnome-tweaks \
        unzip \
        plymouth \
        gsettings-desktop-schemas \
        mesa-vulkan-drivers \
        gnome-keyring-pam \
        NetworkManager-tui \
        NetworkManager-openvpn \
        xdg-user-dirs && \
    systemctl disable gdm || true && \
    systemctl disable sddm || true && \
    systemctl enable cosmic-greeter && \
    mkdir -p /var/tmp && chmod -R 1777 /var/tmp

# Paso 2: Integración de archivos personalizados y scripts
COPY ./rootfs-overlay/ /           # Archivos de personalización (Temas, Iconos, etc.)
COPY ./scripts/personaliza.sh /usr/bin/personaliza.sh
COPY ./scripts/configurar-flatpaks.sh /usr/bin/configurar-flatpaks.sh

# Asegurar permisos en scripts
RUN chmod +x /usr/bin/personaliza.sh /usr/bin/configurar-flatpaks.sh && \
    /usr/bin/personaliza.sh && \
    /usr/bin/configurar-flatpaks.sh

# Paso 3: Habilitar servicios necesarios
RUN systemctl enable hello-screen.service

# Finalización del contenedor
RUN ostree container commit
