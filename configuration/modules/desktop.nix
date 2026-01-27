{...}:{
  imports = [ 
    ./niri.nix 
    ./sway.nix
    ];

  environment.variables = {
    __GLX_VENDOR_LIBRARY_NAME = "mesa";  
    WLR_NO_HARDWARE_CURSORS = "1";
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
  };
}