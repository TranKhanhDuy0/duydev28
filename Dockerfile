FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Base
RUN apt update && apt install -y \
    supervisor \
    xvfb \
    xrdp \
    openbox \
    dbus-x11 \
    sudo \
    wget \
    gnupg \
    ca-certificates \
    fonts-liberation \
    libnss3 \
    libxss1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    x11-xserver-utils \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /usr/share/keyrings/chrome.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/chrome.list && \
    apt update && apt install -y google-chrome-stable && rm -rf /var/lib/apt/lists/*

# User (KHÔNG ROOT)
RUN useradd -m duy && echo "duy:123456" | chpasswd && adduser duy sudo

# XRDP config
RUN sed -i 's/^port=.*/port=3389/' /etc/xrdp/xrdp.ini

# X session
RUN echo "openbox-session" > /home/duy/.xsession && \
    chown duy:duy /home/duy/.xsession

# startwm FIX display 0
RUN printf '#!/bin/sh\nexport DISPLAY=:0\nexport XDG_SESSION_TYPE=x11\nunset DBUS_SESSION_BUS_ADDRESS\nexec openbox-session\n' > /etc/xrdp/startwm.sh && \
    chmod +x /etc/xrdp/startwm.sh

# Supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 3389

CMD ["/usr/bin/supervisord","-n"]
