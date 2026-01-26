{
  pkgs,
  config,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    sway
    xwayland
    fuzzel
    kitty
  ];
}