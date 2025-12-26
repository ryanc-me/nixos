{
  lib,
  config,
  osConfig,
  ...
}:
let
  cfg = osConfig.mine.nixos.desktop.wallpaper;
  wp = cfg.processed.plain."${cfg.mode}";
in
{
  config = lib.mkIf (osConfig.mine.nixos.desktop.gnome.enable && cfg.enable) {
    # Home Manager dconf (works whether or not you're on GNOME)
    dconf.enable = true;
    dconf.settings = {
      "org/gnome/desktop/background" = {
        picture-uri = "file://${wp}/share/wallpapers/plain.png";
        picture-uri-dark = "file://${wp}/share/wallpapers/plain.png";
        picture-options = cfg.mode;
      };
      "org/gnome/desktop/screensaver" = {
        picture-uri = "file://${wp}/share/wallpapers/plain.png";
        picture-options = cfg.mode;
      };
    };
  };
}
