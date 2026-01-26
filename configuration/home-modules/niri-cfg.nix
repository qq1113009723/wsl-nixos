{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "start-niri" (builtins.readFile ./scripts/start-niri.sh))
    (pkgs.writeShellScriptBin "wsl-clipboard-sync" (builtins.readFile ./scripts/wsl-clipboard-sync.sh))  
  ];
}