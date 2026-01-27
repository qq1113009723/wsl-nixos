{ config, pkgs, lib, ... }: {
  # 字体配置
  fonts = {
    # 1. 确保安装了所有在下方 defaultFonts 中引用的字体包
    packages = with pkgs; [
      inter
      lexend
      # 图标与基础等宽
      nerd-fonts.jetbrains-mono
      jetbrains-mono
      
      # 枫叶等宽 (JetBrains Maple Mono)
      maple-mono.NF 
      
      # 微软 Cascadia Code
      cascadia-code
      
      # 中文字体 (思源系列) 
      source-han-sans    
      source-han-serif   
      
      # Google Noto 系列
      noto-fonts
      noto-fonts-cjk-sans  # 提供 Noto Sans CJK SC
      noto-fonts-cjk-serif # 提供 Noto Serif CJK SC
      noto-fonts-color-emoji     # 提供彩色表情支持
    ];

    # 2. 默认字体优先级配置
    fontconfig = {
      enable = true; # 显式开启
      defaultFonts = {
        # 无衬线字体：UI 和 网页的主要显示
        sansSerif = [ 
          "Inter" 
          "Source Han Sans SC" 
          "Noto Sans CJK SC"
        ];
        
        # 等宽字体：终端 (Kitty/Alacritty) 和 代码编辑器
        monospace = [ 
          "Maple Mono NF" 
          "JetBrainsMono Nerd Font"
        ];
        
        # 衬线字体：正文阅读
        serif = [ 
          "Source Han Serif SC" 
          "Noto Serif CJK SC" 
        ];

        # 表情符号
        emoji = [ "Noto Color Emoji" ];
      };
      
    };
  };
}