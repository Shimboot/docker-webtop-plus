FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntujammy

# Set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="mollomm1"

ENV TITLE="Ubuntu 22.04 Gnome"

# Copy Firefox preferences
COPY /root/etc/apt/preferences.d/firefox-no-snap /etc/apt/preferences.d/firefox-no-snap

# Copy custom files
COPY /root/ /

# Install packages
RUN \
  echo "**** install packages ****" && \
  add-apt-repository -y ppa:mozillateam/ppa && \
  apt-get update && \
  apt-get install -y \
    firefox \
    fonts-ubuntu \
    gnome-shell \
    gnome-shell-* \
    dbus-x11 \
    gnome-terminal \
    gnome-accessibility-themes \
    gnome-calculator \
    gnome-control-center* \
    gnome-desktop3-data \
    gnome-initial-setup \
    gnome-menus \
    gnome-themes-extra* \
    gnome-user-docs \
    gnome-video-effects \
    gnome-tweaks \
    gnome-software \
    language-pack-en-base \
    mesa-utils \
    xdg-desktop-portal \
    flatpak \
    gnome-software \
    gnome-software-plugin-flatpak \
    yaru-* \
    ubuntu-desktop 

# Apply fixes for GNOME and Flatpak compatibility
RUN \
  echo "**** apply fixes ****" && \
  for file in $(find /usr -type f -iname "*login1*"); do mv -v "$file" "$file.back"; done && \
  chown abc /defaults/wallpaper.jpg && \
  echo "\n# fixes and stuff for gnome and flatpaks\nexport $(dbus-launch)\nexport XDG_CURRENT_DESKTOP=ubuntu:GNOME\nexport XDG_DATA_DIRS=/var/lib/flatpak/exports/share:/config/.local/share/flatpak/exports/share:/usr/local/share:/usr/share\nexport XDG_SESSION_TYPE=x11\nexport DESKTOP_SESSION=ubuntu\nexport GNOME_SHELL_SESSION_MODE=ubuntu" >> /etc/profile && \
  mv -v /usr/share/applications/gnome-sound-panel.desktop /usr/share/applications/gnome-sound-panel.desktop.back

# Install dbus explicitly (if not installed)
RUN apt-get update && apt-get install -y dbus

# Set the stop signal for proper shutdown
STOPSIGNAL SIGRTMIN+3

# Clean up unnecessary packages
RUN \
  echo "**** clean stuff ****" && \
  apt-get remove -y \
    gnome-power-manager \
    gnome-bluetooth \
    gpaste \
    hijra-applet gnome-shell-extension-hijra \
    mailnag gnome-shell-mailnag \
    xterm \
    gnome-software-plugin-snap \
    snapd \
    gnome-shell-pomodoro gnome-shell-pomodoro-data && \
  apt autoremove -y && \
  apt clean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# Ports and volumes
EXPOSE 3000

VOLUME /config

# Start systemd
CMD ["/lib/systemd/systemd"]

