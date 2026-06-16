{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  imports = [
    ./screenshot.nix
  ];

  config = mkIf (osConfig.mine ? desktop-niri && osConfig.mine.desktop-niri.system.niri.enable) {
    programs.fuzzel = {
      enable = true;

      settings = {
        main = {
          # dpi-aware = true;
          exit-on-keyboard-focus-loss = "yes";
          keyboard-focus = "on-demand";
        };
      };
    };

    programs.noctalia = {
      enable = true;
      systemd.enable = true;
    };

    # we'll maintain the main config file manually, for now
    xdg.configFile."noctalia/settings.json".enable = lib.mkForce false;

    gtk = {
      enable = true;

      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };

      gtk4 = {
        theme = config.gtk.theme;
        extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
      };

      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    };

  };
}
