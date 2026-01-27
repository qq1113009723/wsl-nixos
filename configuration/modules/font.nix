{ config, pkgs, lib, ... }: {
  # 字体配置
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      cascadia-code
      noto-fonts
      noto-fonts-cjk-sans  
      noto-fonts-cjk-serif   
      jetbrains-mono 
    ];
    fontconfig = {
      defaultFonts = {
        sansSerif = [ "Noto Sans CJK SC" ];
        serif = [ "Noto Serif CJK SC" ];
        monospace = [ "JetBrainsMono Nerd Font" "Noto Sans Mono CJK SC" ];
      };
    };
  };
}