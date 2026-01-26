{
  pkgs,
  config,
  lib,
  ...
}: {
  programs = {
    hyprland = {
      enable = false;
      xwayland = {
        enable = true;
      };
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };
  };
  environment.systemPackages = with pkgs; [
    sway
    xwayland
    fuzzel
    kitty
  ];
}
