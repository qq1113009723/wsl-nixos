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
      /* 全局重置：确保不占用任何多余像素 */
      * {
          border: none;
          border-radius: 0;
          font-family: "JetBrainsMono Nerd Font", "Source Han Sans SC";
          font-size: 12px;
          font-weight: 500;
          min-height: 0;
          margin: 0;
          padding: 0;
      }

      /* 状态栏主背景：深色半透明 Kvantum 玻璃 */
      window#waybar {
          background: rgba(20, 20, 20, 0.85);
          color: #dcdcdc;
          border-bottom: 1px solid rgba(255, 255, 255, 0.1); /* 底部极细的高光线 */
      }

      /* 工作空间：极致压缩宽度 */
      #workspaces {
          margin-left: 5px;
      }

      #workspaces button {
          padding: 0 6px;      /* 压缩左右内边距 */
          color: #777777;
          min-width: 20px;     /* 强制窄化下标宽度 */
          background: transparent;
          transition: all 0.2s ease;
      }

      /* 活动状态：Kvantum 风格的底部蓝色短条或背景 */
      #workspaces button.focused,
      #workspaces button.active {
          color: #ffffff;
          background: rgba(255, 255, 255, 0.1);
          box-shadow: inset 0 -2px 0 #3498db; /* 底部蓝色高亮指示 */
          text-shadow: 0 0 5px rgba(255, 255, 255, 0.3);
      }

      #workspaces button.urgent {
          color: #ff5555;
          background: rgba(255, 85, 85, 0.1);
      }

      /* 右侧模块：紧凑排列，使用垂直高光线分隔 */
      #cpu, #memory, #disk, #clock, #tray {
          padding: 0 10px;
          background: transparent;
          /* 模拟 Kvantum 的模块分割感 */
          border-left: 1px solid rgba(255, 255, 255, 0.05);
      }

      /* 为特定模块添加微弱的变色效果 */
      #cpu { color: #88c0d0; }
      #memory { color: #a3be8c; }
      #disk { color: #ebcb8b; }
      #clock { 
          color: #eceff4; 
          font-weight: bold;
          border-right: 1px solid rgba(255, 255, 255, 0.05);
      }

      /* 窗口标题 */
      #window {
          padding: 0 20px;
          color: rgba(255, 255, 255, 0.9);
          font-style: italic;
      }

      /* 托盘样式 */
      #tray {
          margin: 0 5px;
      }
    '';
  };
}