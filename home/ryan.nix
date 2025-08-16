{ config, pkgs, lib, ... }:

let
  wallpaper = ./wallpaper/wallhaven-wyrqg7.png;
in
{
  imports = [
    ./features/bash.nix
    ./features/syncthing.nix
    ./apps
  ];

  home.username = "ryan";
  home.homeDirectory = "/home/${config.home.username}";

  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";


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
      "org/gnome/desktop/background" = {
        color-shading-type = "solid";
        picture-options = "zoom";
        picture-uri = "file://${wallpaper}";
        picture-uri-dark = "file://${wallpaper}";
      };
      "org/gnome/desktop/screensaver" = {
        picture-uri = "file://${wallpaper}";
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
