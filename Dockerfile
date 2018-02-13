FROM debian:stretch-slim

RUN echo 'deb http://deb.debian.org/debian stretch-backports main' > /etc/apt/sources.list.d/backports.list && \
    apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -q -y --no-install-recommends dirmngr gnupg && \
    gpg --keyserver hkp://pool.sks-keyservers.net --recv-key 18ADB31CF18AD6BB && \
    gpg -a --export 18ADB31CF18AD6BB | apt-key add - && \
    echo "deb http://xpra.org/ stretch main" > /etc/apt/sources.list.d/xpra.list && \
    apt-get update && \
    apt-get install -q -y --no-install-recommends \
    gosu \
    dbus-x11 \
    openssl \
    xauth \
    xpra \
    cups \
    python-cups \
    python-yaml \
    pulseaudio \
    pulseaudio-utils \
    gir1.2-gtk-3.0 \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-pulseaudio \
    python-gst-1.0 \
    python-yaml \
    python-dbus \
    python-cryptography \
    python-lzo \
    python-netifaces \
    python-pyinotify \
    python-websockify \
    websockify \
    libjs-jquery \
    websockify-common && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    mkdir -m 770 /var/run/xpra && \
    chgrp xpra /var/run/xpra

ENV DISPLAY=":14"            \
    XPRA_OPTIONS=""          \
    XPRA_TCP_PORT="14500"    \
    XPRA_HTML="no"

ENV PUSER="nobody"              \
    PUID="99"                   \
    PGROUP="users"              \
    PGID="100"                  \
    PUSER_HOME="/home/$PUSER"

ADD bin/ /docker/
RUN chmod a+x /docker/*

ENTRYPOINT ["/docker/entrypoint.sh"]