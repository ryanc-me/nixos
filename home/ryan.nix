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

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerd-fonts.droid-sans-mono
    nerd-fonts.fira-code
    satdump
  ];

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
          pkgs.gnomeExtensions.tailscale-qs.extensionUuid
          pkgs.gnomeExtensions.emoji-copy.extensionUuid
          pkgs.gnomeExtensions.iso-clock.extensionUuid
          pkgs.gnomeExtensions.clipboard-indicator.extensionUuid
          pkgs.gnomeExtensions.color-picker.extensionUuid
        ];
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-enable-primary-paste = false;
        cursor-theme = "Capitaine Cursors";
        cursor-size = lib.gvariant.mkInt32 24;
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
