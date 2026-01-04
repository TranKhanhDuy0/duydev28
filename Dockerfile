FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0

# ========================
# Install packages
# ========================
RUN apt update && apt install -y \
    supervisor \
    xvfb \
    tigervnc-standalone-server \
    tigervnc-common \
    mate-desktop-environment-core \
    mate-terminal \
    caja \
    novnc \
    websockify \
    dbus-x11 \
    x11-xserver-utils \
    && apt clean

# ========================
# Create config dirs (FIX CAJA)
# ========================
RUN mkdir -p /root/.vnc \
    /root/.config/caja \
    /root/.cache \
    /root/.local/share \
    && chmod -R 777 /root

# ========================
# VNC password
# ========================
RUN echo "123456" | vncpasswd -f > /root/.vnc/passwd \
    && chmod 600 /root/.vnc/passwd

# ========================
# xstartup
# ========================
RUN printf '#!/bin/sh\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\nexec mate-session &' > /root/.vnc/xstartup \
    && chmod +x /root/.vnc/xstartup

# ========================
# Supervisor config
# ========================
RUN printf "[supervisord]\nnodaemon=true\n\n\
[program:xvfb]\ncommand=Xvfb :0 -screen 0 1280x720x24\n\n\
[program:vnc]\ncommand=vncserver :0 -geometry 1280x720 -depth 24\n\n\
[program:novnc]\ncommand=websockify --web=/usr/share/novnc/ 0.0.0.0:${PORT} localhost:5900\n" \
> /etc/supervisor/conf.d/supervisord.conf

# ========================
# Start
# ========================
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
