FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0

RUN apt update && apt install -y \
    openbox \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    chromium-browser \
    supervisor \
    dbus-x11 \
    xterm \
    && apt clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/supervisor/conf.d

RUN printf "[supervisord]\nnodaemon=true\n\n\
[program:xvfb]\ncommand=Xvfb :0 -screen 0 1280x720x24\n\n\
[program:wm]\ncommand=openbox-session\nenvironment=DISPLAY=:0\n\n\
[program:vnc]\ncommand=x11vnc -display :0 -forever -shared -nopw -rfbport 5900\n\n\
[program:novnc]\ncommand=/usr/share/novnc/utils/novnc_proxy --vnc localhost:5900 --listen 8080\n" \
> /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8080
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/conf.d/supervisord.conf"]
