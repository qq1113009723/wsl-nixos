{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 28; # 紧凑高度
        # 去掉 margin，实现贴边全宽
        margin-top = 0;
        margin-left = 0;
        margin-right = 0;
        spacing = 0;

        modules-left = [ "niri/workspaces" "sway/workspaces" ];
        modules-center = [ "niri/window" "sway/window" ];
        modules-right = [ "tray" "cpu" "memory" "disk" "clock" ];

        "sway/workspaces" = {
          format = "{index}";
          disable-scroll = true;
          all-outputs = true;
        };

        "niri/workspaces" = {
          format = "{index}";
        };

        "cpu" = {
          format = " {usage}%";
          interval = 2;
        };

        "memory" = {
          format = " {percentage}%";
          interval = 5;
        };

        "disk" = {
          format = "󱛟 {percentage_used}%";
          path = "/";
          interval = 30;
        };

        "tray" = {
          icon-size = 15;
          spacing = 10;
        };

        "clock" = {
          format = "󱑂 {:%H:%M}";
        };

        "niri/window" = {
          max-length = 50;
        };
      };
    };

    style = ''
      /* 全局重置 */
      * {
          border: none;
          border-radius: 0;
          font-family: "JetBrainsMono Nerd Font", "Source Han Sans SC";
          font-size: 12px;
          min-height: 0;
      }

      window#waybar {
          background: rgba(20, 20, 20, 0.85);
          color: #dcdcdc;
          border-bottom: 1px solid rgba(255, 255, 255, 0.1);
      }

      /* --- 窗口标题 (Apple 风格美化) --- */
      #window {
          /* 核心：使用 Inter 模拟 SF Pro，Source Han Sans 模拟萍方 */
          font-family: "Inter", "Source Han Sans SC", sans-serif;
          font-size: 13px;       /* 标题稍微大一点点 */
          font-weight: 600;      /* 苹果风格喜欢用 Semi-bold */
          color: #ffffff;        /* 纯白文字 */
          padding: 0 20px;
          /* 稍微增加一点字间距，更有现代感 */
          letter-spacing: 0.3px; 
          /* 移除之前的 font-style: italic */
      }

      /* 工作空间压缩 */
      #workspaces button {
          padding: 0 6px;
          color: #777777;
          min-width: 20px;
      }

      #workspaces button.focused,
      #workspaces button.active {
          color: #ffffff;
          background: rgba(255, 255, 255, 0.1);
          box-shadow: inset 0 -2px 0 #3498db;
      }

      /* 右侧模块分割线 */
      #cpu, #memory, #disk, #clock, #tray {
          padding: 0 10px;
          border-left: 1px solid rgba(255, 255, 255, 0.05);
      }

      #cpu { color: #88c0d0; }
      #memory { color: #a3be8c; }
      #disk { color: #ebcb8b; }
      #clock { color: #eceff4; font-weight: bold; }
    '';
  };
}