{
  # FIXME: uncomment the next line if you want to reference your GitHub/GitLab access tokens and other secrets
  # secrets,
  username,
  hostname,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./modules
  ];
  
  # FIXME: change to your tz! look it up with "timedatectl list-timezones"
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "zh_CN.UTF-8";

  networking.hostName = "${hostname}";

  # FIXME: change your shell here if you don't want fish
  programs.fish.enable = true;
  environment.pathsToLink = ["/share/fish"];
  environment.shells = [pkgs.fish];

  environment.enableAllTerminfo = true;

  security.sudo.wheelNeedsPassword = false;

  # FIXME: uncomment the next line to enable SSH
  # services.openssh.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    # FIXME: change your shell here if you don't want fish
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      # FIXME: uncomment the next line if you want to run docker without sudo
      # "docker"
    ];
    # FIXME: add your own hashed password
    # hashedPassword = "";
    # FIXME: add your own ssh public key
    # openssh.authorizedKeys.keys = [
    #   "ssh-rsa ..."
    # ];
  };

  home-manager.users.${username} = {
    imports = [
      ./home.nix
    ];
  };

  system.stateVersion = "25.11";

  wsl = {
    enable = true;
    interop.register = true;
    useWindowsDriver=true;
    wslConf.automount.root = "/mnt";
    wslConf.interop.appendWindowsPath = false;
    wslConf.network.generateHosts = false;
    defaultUser = username;
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    docker-desktop.enable = false;
  };

  virtualisation.docker = {
    enable = false;
    enableOnBoot = false;
    autoPrune.enable = true;
  };

  # FIXME: uncomment the next block to make vscode running in Windows "just work" with NixOS on WSL
  # solution adapted from: https://github.com/K900/vscode-remote-workaround
  # more information: https://github.com/nix-community/NixOS-WSL/issues/238 and https://github.com/nix-community/NixOS-WSL/issues/294
  # systemd.user = {
  #   paths.vscode-remote-workaround = {
  #     wantedBy = ["default.target"];
  #     pathConfig.PathChanged = "%h/.vscode-server/bin";
  #   };
  #   services.vscode-remote-workaround.script = ''
  #     for i in ~/.vscode-server/bin/*; do
  #       if [ -e $i/node ]; then
  #         echo "Fixing vscode-server in $i..."
  #         ln -sf ${pkgs.nodejs_18}/bin/node $i/node
  #       fi
  #     done
  #   '';
  # };
  environment.systemPackages = with pkgs;[
    mesa
    mesa-demos 
  ];
  environment.variables = {
    LD_LIBRARY_PATH= "/usr/lib/wsl/lib";
    GALLIUM_DRIVER="d3d12";
    MESA_LOADER_DRIVER_OVERRIDE="d3d12";
  };

  nix = {
    settings = {
      trusted-users = [username];
      # FIXME: use your access tokens from secrets.json here to be able to clone private repos on GitHub and GitLab
      # access-tokens = [
      #   "github.com=${secrets.github_token}"
      #   "gitlab.com=OAuth2:${secrets.gitlab_token}"
      # ];

      accept-flake-config = true;
      auto-optimise-store = true;
      substituters = [
        "https://mirrors.ustc.edu.cn/nix-channels/store"    
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"  
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };

    registry = {
      nixpkgs = {
        flake = inputs.nixpkgs;
      };
    };

    nixPath = [
      "nixpkgs=${inputs.nixpkgs.outPath}"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    package = pkgs.nixVersions.stable;
    extraOptions = ''experimental-features = nix-command flakes'';

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}
