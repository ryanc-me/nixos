{ config, pkgs, lib, ... }:

{
  imports = [
    ./features/bash.nix
    ./features/syncthing.nix
    ./apps
  ];

  home.username = "ryan";
  home.homeDirectory = "/home/ryan";

  sops.age.keyFile = "/home/ryan/.config/sops/age/keys.txt";


  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };
  dconf = {
    enable = true;
    settings = {
      "org/gnome/mutter" = {
        experimental-features = [
          "scale-monitor-framebuffer"
          "variable-refresh-rate"
          "xwayland-native-scaling"
        ];
      };
      "org/gnome/shell" = {
        enabled-extensions = [
          pkgs.gnomeExtensions.blur-my-shell.extensionUuid
          pkgs.gnomeExtensions.just-perfection.extensionUuid
          pkgs.gnomeExtensions.caffeine.extensionUuid
        ];
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-enable-primary-paste = false;
      };
    };
  };

  # enable git
  services.ssh-agent.enable = true;

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Ryan Cole";
    userEmail = "admin@ryanc.me";
  };

  home.stateVersion = "25.05";
}
