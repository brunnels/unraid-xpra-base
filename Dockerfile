FROM debian:stretch-slim

RUN echo 'deb http://deb.debian.org/debian stretch-backports main' > /etc/apt/sources.list.d/backports.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -q -y gnupg && \
    gpg --keyserver pgpkeys.mit.edu --recv-key 18ADB31CF18AD6BB && \
    gpg -a --export 18ADB31CF18AD6BB | apt-key add - && \
    echo "deb http://xpra.org/ stretch main" > /etc/apt/sources.list.d/xpra.list && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -q -y \
    gosu \
    dbus-x11 \
    x264 \
    x265 \
    xpra \
    pulseaudio \
    pulseaudio-utils \
    python-mutagen \
    python-dbus \
    python-gi \
    python-gi-cairo \
    python-dbus \
    python-opengl \
    python-gtkglext1 \
    python-lz4 \
    python-lzo \
    python-pil \
    python-avahi \
    python-cups \
    python-gst-1.0 \
    python-opencv \
    python-netifaces \
    python-yaml \
    python-pip && \
    apt-get clean && \
    pip install \
    python-uinput && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN mkdir -m 770 /var/run/xpra && \
    chgrp xpra /var/run/xpra

ENV GUEST_USER=user \
    GUEST_UID=9001 \
    GUEST_GROUP=user \
    GUEST_GID=9001 \
    DISPLAY=:0 \
    XPRA_OPTIONS=

ADD bin/ /docker/
RUN chmod a+x /docker/*

ENTRYPOINT ["/docker/entrypoint.sh"]