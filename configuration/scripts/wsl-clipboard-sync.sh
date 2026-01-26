#!/bin/bash

# 1. 环境初始化
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

# 2. 自动补全 Windows 路径 (NixOS PATH 默认很干净，可能找不到 powershell)
export PATH=$PATH:/mnt/c/Windows/System32/WindowsPowerShell/v1.0/:/mnt/c/Windows/System32/

# 3. 等待 Wayland (Sway/Niri) 就绪
until [ -S "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" ]; do
  sleep 1
done

# 4. 清理旧进程
pkill -9 -f "wl-paste.*clip.exe" 2>/dev/null || true

# --- 5. Linux -> Windows ---
wl-paste -t "text/plain;charset=utf-8" --watch bash -c '
    cat | iconv -c -f UTF-8 -t UTF-16LE | clip.exe
' 2>/dev/null &

# --- 6. Windows -> Linux ---
last_hash=""
while true; do
    # 使用较轻量级的 .NET 调用，带编码处理
    current=$(powershell.exe -NoProfile -NonInteractive -Command \
        "Add-Type -AssemblyName System.Windows.Forms; 
         \$content = [System.Windows.Forms.Clipboard]::GetText();
         if (\$content) { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8; Write-Output \$content } " 2>/dev/null | tr -d '\r')

    if [[ -n "$current" ]]; then
        current_hash=$(echo -n "$current" | md5sum | awk '{print $1}')
        if [[ "$current_hash" != "$last_hash" ]]; then
            # 只有当 Linux 本地不一致时才写入
            if [[ "$current" != "$(wl-paste -n 2>/dev/null)" ]]; then
                echo -n "$current" | wl-copy 2>/dev/null
                echo -n "$current" | wl-copy --primary 2>/dev/null
                last_hash="$current_hash"
            fi
        fi
    fi
    sleep 1
done