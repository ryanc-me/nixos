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
    ./extensions.nix
    ./wallpaper.nix
  ];

  config = mkIf osConfig.mine.desktop-gnome.gnome.enable {
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
  };
}
