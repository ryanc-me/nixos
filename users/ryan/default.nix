{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./dconf.nix
    ./bash.nix
  ];

  home.username = "ryan";
  home.homeDirectory = "/home/${config.home.username}";

  mine.home = {
    apps = {
      screenshot.enable = true;
    };
    services = {
      docker-socket-tunnel.enable = true;
      flatpak.enable = true;
      ssh-agent.enable = true;
    };
    system = {
      electron-wayland.enable = true;
      fonts.enable = true;
    };
  };

  # this is require for syncthing (hence it lives here, not in a module)
  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Ryan Cole";
        email = "admin@ryanc.me";
      };
    };
  };

  #TODO: move this to the NixOS side for better perf?
  # https://github.com/nix-community/impermanence/issues/42#issuecomment-951093430
  home.persistence."/persist/sync" = {
    files = [
      ".config/Code/User/settings.json"

      ".ssh/config"
      ".ssh/config-wedoo-clients"
      ".ssh/config-wedoo-infra"
      ".ssh/config-wedoo-internal"
      ".ssh/config-wedoo-legacy"
    ];
    directories = [
      ".config/forge"
      ".config/noctalia"
      ".config/niri"

      ".aws"
      "projects"
      "work"
    ];
  };

  home.stateVersion = "25.05";
}
