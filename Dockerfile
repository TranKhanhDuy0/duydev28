FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0

# ===== CÀI GÓI CẦN THIẾT =====
RUN apt update && apt install -y \
    xvfb openbox xrdp dbus-x11 sudo \
    wget gnupg ca-certificates \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# ===== CÀI GOOGLE CHROME =====
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" \
    > /etc/apt/sources.list.d/google-chrome.list && \
    apt update && apt install -y google-chrome-stable

# ===== TẠO USER =====
RUN useradd -m duydev && \
    echo "duydev:@1U2I3o4p" | chpasswd && \
    adduser duydev sudo

# ===== XSESSION =====
RUN echo "openbox-session" > /home/duydev/.xsession && \
    chown duydev:duydev /home/duydev/.xsession && \
    chmod 644 /home/duydev/.xsession

# ===== FIX XAUTHORITY (QUAN TRỌNG) =====
RUN rm -f /home/duydev/.Xauthority && \
    touch /home/duydev/.Xauthority && \
    chown duydev:duydev /home/duydev/.Xauthority && \
    chmod 600 /home/duydev/.Xauthority

# ===== XRDP CONFIG =====
RUN sed -i 's/port=3389/port=58906/' /etc/xrdp/xrdp.ini

# ===== SUPERVISOR =====
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 58906

CMD ["/usr/bin/supervisord", "-n"]
