FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0

# ===== CÀI GÓI CẦN THIẾT (NHẸ NHẤT CÓ THỂ) =====
RUN apt-get update && apt-get install -y \
    ubuntu-mate-core \
    mate-session-manager \
    mate-terminal \
    x11vnc \
    xvfb \
    supervisor \
    chromium-browser \
    git \
    python3 \
    dbus-x11 \
    --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# ===== noVNC =====
RUN git clone https://github.com/novnc/noVNC.git /opt/novnc && \
    git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify && \
    ln -s /opt/novnc/vnc.html /opt/novnc/index.html

# ===== USER =====
RUN useradd -m -s /bin/bash duydev && \
    echo "duydev:@1U2I3o4p" | chpasswd

# ===== SUPERVISOR =====
RUN mkdir -p /etc/supervisor/conf.d

RUN printf "[supervisord]\nnodaemon=true\n\n\
[program:xvfb]\n\
command=Xvfb :0 -screen 0 1280x720x24\n\
autostart=true\n\
autorestart=true\n\n\
[program:mate]\n\
command=mate-session\n\
environment=DISPLAY=:0\n\
user=duydev\n\
autostart=true\n\
autorestart=true\n\n\
[program:vnc]\n\
command=x11vnc -display :0 -forever -shared -rfbport 5900 -nopw\n\
autostart=true\n\
autorestart=true\n\n\
[program:novnc]\n\
command=/opt/novnc/utils/novnc_proxy --vnc localhost:5900 --listen 8080\n\
autostart=true\n\
autorestart=true\n" \
> /etc/supervisor/conf.d/supervisord.conf

# ===== AUTO MỞ CHROMIUM FULL MÀN =====
RUN mkdir -p /home/duydev/.config/autostart && \
    printf "[Desktop Entry]\nType=Application\nExec=chromium-browser --no-sandbox --start-fullscreen\nHidden=false\nX-MATE-Autostart-enabled=true\nName=Chromium\n" \
    > /home/duydev/.config/autostart/chromium.desktop && \
    chown -R duydev:duydev /home/duydev

# ===== PORT =====
EXPOSE 8080

CMD ["/usr/bin/supervisord"]
