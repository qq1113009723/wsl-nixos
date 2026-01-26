{ lib, ... }: {
  imports = [
    ./font.nix
    ./sway.nix
    ./fcitx5.nix
    ./i18n.nix
  ];
}