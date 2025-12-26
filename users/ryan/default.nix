{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./dconf.nix
  ];

  home.username = "ryan";
  home.homeDirectory = "/home/${config.home.username}";

  mine.home = {
    apps = {
      microsoft-outlook.enable = true;
      microsoft-teams.enable = true;
      screenshot.enable = true;
      spotify.enable = true;
      toggl-track.enable = true;
    };
    env = {
      bash.enable = true;
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
    settings = {
      user = {
        name = "Ryan Cole";
        email = "admin@ryanc.me";
      };
    };
  };

  home.stateVersion = "25.05";
}
