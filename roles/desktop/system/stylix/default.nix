{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.system.stylix;
  wp =
    config.mine.desktop.system.wallpaper.processed.plain.${config.mine.desktop.system.wallpaper.mode};
in
{
  options.mine.desktop.system.stylix = {
    enable = mkEnableOption "stylix (Desktop)";
  };

  config = mkIf cfg.enable {
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        noto-fonts
        noto-fonts-color-emoji
      ];
    };

    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/default-dark.yaml";
      image = "${wp}/share/wallpapers/plain.png";
      polarity = "dark";
      autoEnable = false;

      #TODO: expand this (maybe opt-in at the roles themselves?)
      targets = {
        gtk.enable = true;
        qt.enable = true;
        grub.enable = true;
        plymouth.enable = true;
      };
      fonts = {
        serif = {
          package = pkgs.noto-fonts;
          name = "Noto Serif";
        };

        sansSerif = {
          package = pkgs.noto-fonts;
          name = "Noto Sans";
        };

        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };

        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };

        sizes = {
          desktop = 10;
          applications = 12;
          terminal = 12;
          popups = 14;
        };
      };
    };
  };
}
