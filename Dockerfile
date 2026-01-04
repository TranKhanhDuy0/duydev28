# Base image
FROM ubuntu:22.04

# Set environment
ENV DEBIAN_FRONTEND=noninteractive

# Cài gói cơ bản với Chromium thay Chrome
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies \
    xrdp \
    supervisor \
    wget curl unzip \
    dbus-x11 \
    xvfb \
    x11vnc \
    firefox \
    chromium-browser \
    --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Tạo user duydev
RUN useradd -m -s /bin/bash duydev && echo "duydev:@1U2I3o4p" | chpasswd
RUN mkdir -p /home/duydev && chown duydev:duydev /home/duydev

# Cấu hình XRDP để dùng XFCE
RUN echo "exec startxfce4" > /etc/xrdp/startwm.sh
RUN chmod +x /etc/xrdp/startwm.sh

# Copy supervisord config (bắt buộc phải có file này trong folder build)
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Tạo .xsession mặc định nếu chưa có
RUN echo "startxfce4" > /home/duydev/.xsession
RUN chown duydev:duydev /home/duydev/.xsession
RUN chmod +x /home/duydev/.xsession

# Expose XRDP port
EXPOSE 3389

# Start supervisord
CMD ["/usr/bin/supervisord", "-n"]
