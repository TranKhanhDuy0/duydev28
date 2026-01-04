FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0
ENV PORT=8080

RUN apt update && apt install -y \
    xvfb \
    openbox \
    xterm \
    x11vnc \
    novnc \
    websockify \
    supervisor \
    curl \
    && curl -fsSL https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 \
       -o /usr/local/bin/cloudflared \
    && chmod +x /usr/local/bin/cloudflared \
    && apt clean

RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8080

CMD ["/usr/bin/supervisord"]
