{ pkgs, ... }: {
  imports = [
    ./font.nix
    ./desktop.nix
    ./fcitx5.nix
    ./i18n.nix
  ];
  environment.systemPackages = with pkgs; [
    fuzzel
    kitty
  ];
}