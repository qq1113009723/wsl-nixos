{ lib, ... }: {
  imports = [
    ./brower.nix
    ./sway-cfg.nix
    ./niri-cfg.nix
  ];
}