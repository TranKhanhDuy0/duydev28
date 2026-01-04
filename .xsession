#!/bin/sh
unset DBUS_SESSION_BUS_ADDRESS
unset XDG_RUNTIME_DIR

# Start desktop
exec startxfce4 &

# Chrome fullscreen
google-chrome \
  --no-sandbox \
  --disable-dev-shm-usage \
  --start-fullscreen \
  https://railway.app
