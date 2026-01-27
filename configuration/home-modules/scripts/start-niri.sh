#!/bin/bash
set -euo pipefail  # 严格模式：未定义变量报错、管道失败退出

# 导出环境变量（放在最前面，避免后续命令受影响）
export USER_ID=$(id -u)
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$USER_ID}"
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-0}"
export DISPLAY="${DISPLAY:-:0}"
export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
export XDG_SESSION_DESKTOP=niri
export XDG_SESSION_TYPE=wayland
export _JAVA_AWT_WM_NONREPARENTING=1

# 确保 XDG_RUNTIME_DIR 存在且权限正确
mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR" || { echo "Failed to chmod XDG_RUNTIME_DIR"; exit 1; }

# Mesa EGL vendor 文件（可选，WSLg 通常不需要，但保留以兼容）
MESA_JSON="/usr/share/glvnd/egl_vendor.d/50_mesa.json"
if [ -f "$MESA_JSON" ]; then
    export __EGL_VENDOR_LIBRARY_FILENAMES="$MESA_JSON"
fi

echo "Cleaning up legacy processes..."
# 用 -f 避免 no process 报错
pkill -9 -f "wsl-clipboard-sync" 2>/dev/null || true
pkill -9 wl-paste 2>/dev/null || true
pkill -9 powershell.exe 2>/dev/null || true

echo "Fixing X11 socket directory..."
# 避免 sudo 失败导致整个脚本退出，用 || true
sudo umount -l /tmp/.X11-unix 2>/dev/null || true
sudo rm -rf /tmp/.X11-unix 2>/dev/null || true
sudo mkdir -p /tmp/.X11-unix || { echo "Failed to create /tmp/.X11-unix"; exit 1; }
sudo chmod 1777 /tmp/.X11-unix || true

# 如果 WSLg 有 X0 socket，链接它（更安全检查是否存在）
if [ -S /mnt/wslg/.X11-unix/X0 ]; then
    sudo ln -sf /mnt/wslg/.X11-unix/X0 /tmp/.X11-unix/X0 || true
fi

# Wayland socket 链接（WSLg 标准路径）
ln -sf /mnt/wslg/runtime-dir/wayland-0 "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" || true
ln -sf /mnt/wslg/runtime-dir/wayland-0.lock "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY.lock" || true

# dbus socket 检查和启动
if [[ ! -S "$XDG_RUNTIME_DIR/bus" ]]; then
    echo "Starting user dbus..."
    systemctl --user start dbus.socket || {
        echo "Failed to start dbus.socket"
        journalctl --user -u dbus.socket -n 20
        exit 1
    }
    # 等待 dbus 就绪
    sleep 1
fi

# 清理残留的旧 socket（防止启动失败）
rm -f "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY.lock" 2>/dev/null || true
# 重新链接（确保最新）
ln -sf /mnt/wslg/runtime-dir/wayland-0 "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY"
ln -sf /mnt/wslg/runtime-dir/wayland-0.lock "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY.lock"

echo "Starting niri..."
# 用 exec 替换当前进程，日志重定向
exec dbus-run-session -- niri > >(tee /tmp/niri.log) 2>&1