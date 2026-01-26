{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  niri-official = inputs.niri.packages.${pkgs.system}.default;
  niri-wsl = niri-official.overrideAttrs (oldAttrs: {
    # patches = [ ./patch/niri-winit-decorations.patch ];
    postPatch = lib.concatStringsSep "\n" [
      "patchShebangs resources/niri-session"
      "substituteInPlace src/backend/winit.rs --replace-fail '.with_title(\"niri\")' '.with_decorations(false).with_title(\"niri\")'"
    ];
  });
in
{

  environment.systemPackages = with pkgs; [
    niri-wsl
    alacritty       
    xwayland-satellite 
    wl-clipboard    
    cliphist       
    cosmic-files    
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
  ] ;

  environment.variables = {
    __GLX_VENDOR_LIBRARY_NAME = "mesa";  
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
    XCURSOR_SIZE = "0";
  };
}