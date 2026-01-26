{ config, pkgs, lib, ... }: {
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-chinese-addons
      fcitx5
      qt6Packages.fcitx5-configtool
      fcitx5-nord
      fcitx5-rime  
    ];
    fcitx5.waylandFrontend = true;
  };
}