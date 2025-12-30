{ lib, ... }:
let
  recursiveImportDefault =
    (import ../../lib/recursiveImportDefault.nix { inherit lib; }).recursiveImportDefault;
in
{
  imports = recursiveImportDefault ./.;

  config.mine.desktop-gnome = {
    gdm.enable = true;
    gdm-wallpaper.enable = true;
    gnome.enable = true;
    gnome-extensions = {
      enable = true;
      extensions = [
        "blur-my-shell"
        "just-perfection"
        "caffeine"
        "tailscale-qs"
        "emoji-copy"
        "iso-clock"
        "clipboard-indicator"
        "color-picker"
        "launch-new-instance"
        "forge"
        "status-area-horizontal-spacing"
        "appindicator"
      ];
    };
    gnome-monitors-xml.enable = true;
  };
}
