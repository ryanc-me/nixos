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
    ./screenshot.nix
  ];

  config = mkIf (osConfig.mine ? desktop-gnome && osConfig.mine.desktop-gnome.gnome.enable) {
  };
}
