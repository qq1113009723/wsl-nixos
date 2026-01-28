{ pkgs, lib, ... }:

{
  programs.firefox = {
    enable = true;
    
    package = pkgs.firefox.override {
      cfg = {
        enableWayland = true;
      };
    };

    # profiles.default = {
    #   id = 0;
    #   name = "default";
    #   isDefault = true;
    #   settings = {
    #     "font.name.sans-serif.x-western" = "Inter";
    #     "font.name.sans-serif.zh-CN" = "Source Han Sans SC";
    #     "font.name.monospace.x-western" = "Maple Mono NF";
    #     "font.name.monospace.zh-CN" = "Source Han Sans SC";
    #   };
    # };
  };
}