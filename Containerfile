FROM ghcr.io/ublue-os/arch-distrobox AS okadora-arch

COPY system_files /

# Install needed packages
RUN pacman -Syu \
        lib32-vulkan-radeon \
        libva-mesa-driver \
        intel-media-driver \
        vulkan-mesa-layers \
        lib32-vulkan-mesa-layers \
        lib32-libnm \
        openal \
        pipewire \
        pipewire-pulse \
        pipewire-alsa \
        pipewire-jack \
        wireplumber \
        lib32-pipewire \
        lib32-pipewire-jack \
        lib32-libpulse \
        lib32-openal \
        xdg-desktop-portal-kde \
        vim \
        nano \
        hyfetch \
        fish \
        yad \
        xdg-user-dirs \
        xdotool \
        xorg-xwininfo \
        wmctrl \
        wxwidgets-gtk3 \
        rocm-opencl-runtime \
        rocm-hip-runtime \
        libbsd \
        noto-fonts-cjk \
        glibc-locales \
        --noconfirm && \
    pacman -S --clean --clean && \
    rm -rf /var/cache/pacman/pkg/*

# Create build user
RUN useradd -m --shell=/bin/bash build && usermod -L build && \
    echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install AUR packages
USER build
WORKDIR /home/build
RUN paru -S \
        aur/obs-vkcapture-git \
        aur/lib32-obs-vkcapture-git \
        aur/lib32-gperftools \
        --noconfirm
USER root
WORKDIR /

# Cleanup
# Native march & tune. This is a gaming image and not something a user is going to compile things in with the intent to share.
# We do this last because it'll only apply to updates the user makes going forward. We don't want to optimize for the build host's environment.
RUN sed -i 's/-march=x86-64 -mtune=generic/-march=native -mtune=native/g' /etc/makepkg.conf && \
    userdel -r build && \
    rm -drf /home/build && \
    sed -i '/build ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers && \
    sed -i '/root ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers && \
    rm -rf /home/build/.cache/* && \
    rm -rf \
        /tmp/* \
        /var/cache/pacman/pkg/*

FROM okadora-arch as okadora-arch-gnome

# Replace KDE portal with GNOME portal, swap included icon theme.
RUN sed -i 's/-march=native -mtune=native/-march=x86-64 -mtune=generic/g' /etc/makepkg.conf && \
    pacman -Rnsdd \
        xdg-desktop-portal-kde \
        --noconfirm && \
    pacman -S \
        xdg-desktop-portal-gtk \
        xdg-desktop-portal-gnome \
        --noconfirm && \
    rm -rf /var/cache/pacman/pkg/*

# Cleanup
RUN sed -i 's/-march=x86-64 -mtune=generic/-march=native -mtune=native/g' /etc/makepkg.conf && \
    rm -rf \
        /tmp/*
