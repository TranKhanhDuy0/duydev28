FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0

RUN apt update && apt install -y \
    xvfb \
    openbox \
    xrdp \
    supervisor \
    wget \
    curl \
    fonts-liberation \
    libnss3 \
    libxss1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    dbus-x11 \
    && wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt install -y ./google-chrome-stable_current_amd64.deb \
    && rm google-chrome-stable_current_amd64.deb \
    && apt clean

# XRDP config
RUN echo "openbox-session" > /etc/skel/.xsession \
 && echo "openbox-session" > /root/.xsession

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 3389

CMD ["/usr/bin/supervisord"]
