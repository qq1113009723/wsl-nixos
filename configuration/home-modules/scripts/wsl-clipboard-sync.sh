#!/bin/bash

# 1. 路径修复
POWERSHELL_BIN="/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"
if [ ! -f "$POWERSHELL_BIN" ]; then
    POWERSHELL_BIN=$(which powershell.exe 2>/dev/null)
fi

# 杀死旧进程
pkill -9 -f "GetClipboardSequenceNumber" 2>/dev/null || true

last_linux_content=""
last_windows_content=""

echo "剪贴板同步服务已启动 (Base64 加密传输版)..."

while true; do
    # --- 1. Linux -> Windows (同步中文不乱码的关键) ---
    current_linux_content=$(wl-paste -n 2>/dev/null)
    
    if [[ -n "$current_linux_content" && "$current_linux_content" != "$last_linux_content" ]]; then
        if [[ "$current_linux_content" != "$last_windows_content" ]]; then
            # 将内容转为 Base64 发送给 Windows
            b64_content=$(echo -n "$current_linux_content" | base64 -w 0)
            
            # 在 PowerShell 内部解码 Base64 并设置剪贴板
            "$POWERSHELL_BIN" -NoProfile -NonInteractive -Command \
                "\$b64 = '$b64_content'; 
                 \$bytes = [System.Convert]::FromBase64String(\$b64); 
                 \$text = [System.Text.Encoding]::UTF8.GetString(\$bytes); 
                 Set-Clipboard -Value \$text" 2>/dev/null
            
            last_linux_content="$current_linux_content"
            # echo "已同步到 Windows: $current_linux_content"
        fi
    fi

    # --- 2. Windows -> Linux ---
    # 同样使用 Base64 获取，确保从 Windows 回传时不乱码
    win_b64=$("$POWERSHELL_BIN" -NoProfile -NonInteractive -Command \
        "\$c = Get-Clipboard -Raw; 
         if (\$c) { 
             \$bytes = [System.Text.Encoding]::UTF8.GetBytes(\$c); 
             [Convert]::ToBase64String(\$bytes) 
         }" 2>/dev/null | tr -d '\r')

    if [ -n "$win_b64" ]; then
        current_windows_content=$(echo "$win_b64" | base64 -d 2>/dev/null)
        
        if [[ "$current_windows_content" != "$last_windows_content" ]]; then
            if [[ "$current_windows_content" != "$current_linux_content" ]]; then
                printf "%s" "$current_windows_content" | wl-copy 2>/dev/null
                printf "%s" "$current_windows_content" | wl-copy --primary 2>/dev/null
                last_windows_content="$current_windows_content"
                last_linux_content="$current_windows_content"
                # echo "已从 Windows 同步"
            fi
        fi
    fi

    sleep 1
done