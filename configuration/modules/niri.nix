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
    # 添加 patchelf 工具用于修改二进制
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ pkgs.patchelf ];

    postPatch = (oldAttrs.postPatch or "") + ''
      substituteInPlace src/backend/winit.rs \
        --replace-fail '.with_title("niri")' '.with_decorations(false).with_title("niri")'

      substituteInPlace src/backend/winit.rs \
        --replace-fail 'let (backend, winit) = winit::init_from_attributes(builder)?;' \
                       'let (backend, winit) = winit::init_from_attributes(builder)?; backend.window().set_cursor_visible(false);'

      if [ -f resources/niri.service ]; then
        substituteInPlace resources/niri.service --replace "/usr/bin/niri" "$out/bin/niri"
      fi
      
      patchShebangs resources/niri-session
    '';
    postInstall = (oldAttrs.postInstall or "") + ''
      echo "Patching Niri RPATH for WSLg..."
      patchelf --add-rpath /usr/lib/wsl/lib $out/bin/niri
    '';
    doCheck = false;
  });
in
{
  programs.niri = {
    enable = true;
    package = niri-wsl;
  };
  environment.systemPackages = with pkgs; [
    # niri-wsl
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
  };
}