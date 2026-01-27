#!/bin/bash
export USER_ID=$(id -u)
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/run/user/$USER_ID}
export WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-wayland-0}
export DISPLAY=${DISPLAY:-:0}
export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
export XDG_SESSION_DESKTOP=niri
export XDG_SESSION_TYPE=wayland
export _JAVA_AWT_WM_NONREPARENTING=1

[ ! -d "$XDG_RUNTIME_DIR" ] && mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR"

MESA_JSON="/usr/share/glvnd/egl_vendor.d/50_mesa.json"
[ -f "$MESA_JSON" ] && export __EGL_VENDOR_LIBRARY_FILENAMES="$MESA_JSON"

echo "Cleaning up legacy processes..."
pkill -9 -f "wsl-clipboard-sync" 2>/dev/null
pkill -9 wl-paste 2>/dev/null
pkill -9 powershell.exe 2>/dev/null

echo "Fixing X11 socket directory..."
sudo umount -l /tmp/.X11-unix 2>/dev/null || true
sudo rm -rf /tmp/.X11-unix 2>/dev/null || true
sudo mkdir -p /tmp/.X11-unix
sudo chmod 1777 /tmp/.X11-unix
if [ -e /mnt/wslg/.X11-unix/X0 ]; then
    sudo ln -sf /mnt/wslg/.X11-unix/X0 /tmp/.X11-unix/X0
fi
sudo chmod 1777 /tmp/.X11-unix

ln -sf /mnt/wslg/runtime-dir/wayland-0 "${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY}"
ln -sf /mnt/wslg/runtime-dir/wayland-0.lock "${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY}.lock"

if [[ ! -e ${XDG_RUNTIME_DIR}/bus ]]; then
    systemctl --user start dbus.socket
fi

echo "Starting niri..."
dbus-run-session niri > /tmp/niri.log 2>&1

echo "niri has exited. Final cleanup..."
pkill -9 -f "wsl-clipboard-sync" 2>/dev/null
pkill -9 wl-paste 2>/dev/null