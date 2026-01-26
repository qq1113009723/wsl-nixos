{ pkgs, ... }: {
  imports = [
    ./font.nix
    ./sway.nix
    ./niri.nix
    ./fcitx5.nix
    ./i18n.nix
  ];
  environment.systemPackages = with pkgs; [
    fuzzel
    kitty
  ];
}