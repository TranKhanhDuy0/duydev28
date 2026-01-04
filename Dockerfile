FROM ubuntu:22.04

# Cài gói cơ bản
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies \
    xrdp \
    supervisor \
    wget curl unzip \
    dbus-x11 \
    xvfb \
    x11vnc \
    firefox \
    google-chrome-stable \
    --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Tạo user duydev
RUN useradd -m -s /bin/bash duydev && echo "duydev:@1U2I3o4p" | chpasswd

# XRDP config
RUN sed -i 's/3389/3389/' /etc/xrdp/xrdp.ini
RUN echo "exec startxfce4" > /etc/xrdp/startwm.sh
RUN chmod +x /etc/xrdp/startwm.sh

# Supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# xsession
RUN mkdir -p /home/duydev && chown duydev:duydev /home/duydev
COPY .xsession /home/duydev/.xsession
RUN chown duydev:duydev /home/duydev/.xsession
RUN chmod +x /home/duydev/.xsession

# Set environment
ENV DISPLAY=:10
EXPOSE 3389

CMD ["/usr/bin/supervisord", "-n"]
