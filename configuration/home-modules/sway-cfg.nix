{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "start-sway" (builtins.readFile ./scripts/start-sway.sh))
    (pkgs.writeShellScriptBin "wsl-clipboard-sync" (builtins.readFile ./scripts/wsl-clipboard-sync.sh))  
  ];
}