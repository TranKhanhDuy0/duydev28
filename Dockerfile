FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0
ENV USER=duydev
ENV PASS=@1U2I3o4p

# Cài gói cần thiết (nhẹ)
RUN apt update && apt install -y \
    ubuntu-mate-core \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    chromium-browser \
    dbus-x11 \
    supervisor \
    sudo \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Tạo user
RUN useradd -m -s /bin/bash $USER \
    && echo "$USER:$PASS" | chpasswd \
    && usermod -aG sudo $USER

# Supervisor config
RUN mkdir -p /etc/supervisor/conf.d

RUN printf "[supervisord]\nnodaemon=true\n\n\
[program:xvfb]\ncommand=/usr/bin/Xvfb :0 -screen 0 1280x720x24\n\n\
[program:mate]\ncommand=/usr/bin/mate-session\nuser=%s\nenvironment=DISPLAY=:0\n\n\
[program:x11vnc]\ncommand=/usr/bin/x11vnc -display :0 -forever -shared -nopw -rfbport 5900\n\n\
[program:novnc]\ncommand=/usr/share/novnc/utils/novnc_proxy --vnc localhost:5900 --listen 8080\n" "$USER" \
> /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8080

CMD ["/usr/bin/supervisord","-c","/etc/supervisor/conf.d/supervisord.conf"]
