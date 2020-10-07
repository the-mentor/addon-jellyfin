ARG BUILD_FROM=hassioaddons/debian-base:3.2.2
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base system
ARG BUILD_ARCH=amd64
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        curl \ 
        wget \
        gnupg1 \
        apt-transport-https \
    # Add Jellifin Debian Repo 
    &&  wget -O /tmp/jellyfin_team.gpg.key https://repo.jellyfin.org/debian/jellyfin_team.gpg.key \
    && apt-key add /tmp/jellyfin_team.gpg.key \
    && echo "deb [arch=$( dpkg --print-architecture )] https://repo.jellyfin.org/debian buster main" | tee /etc/apt/sources.list.d/jellyfin.list \
    # Update Package list and Install Jellifin
    && apt-get update \
    && apt install --no-install-recommends -y jellyfin=10.6.4-1


#\
# && curl -L https://github.com/jellyfin/jellyfin-web/archive/${JELLYFIN_WEB_VERSION}.tar.gz | tar zxf - \
# && cd jellyfin-web-* \
# && yarn install \
# && mv dist /dist

# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="Jellyfin Media Server" \
    io.hass.description="Jellyfin is the volunteer-built media solution that puts you in control of your media. Stream to any device from your own server, with no strings attached. Your media, your server, your way." \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Avri Chen-Roth <aroth@addons.community>" \
    org.opencontainers.image.title="Jellyfin Media Server" \
    org.opencontainers.image.description="Jellyfin is the volunteer-built media solution that puts you in control of your media. Stream to any device from your own server, with no strings attached. Your media, your server, your way." \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Avri Chen-Roth <aroth@addons.community>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/hassio-addons/addon-plex" \
    org.opencontainers.image.documentation="https://github.com/hassio-addons/addon-plex/blob/master/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
