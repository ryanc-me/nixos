{
  lib,
  config,
  osConfig,
  ...
}:
let
  wp = osConfig.my.wallpaper.processed.plain;
  enable = osConfig.my.wallpaper.enable;
in
{
  config = lib.mkIf enable {
    # Home Manager dconf (works whether or not you're on GNOME)
    dconf.enable = true;
    dconf.settings = {
      "org/gnome/desktop/background" = {
        picture-uri = "file://${wp}/share/wallpapers/plain.png";
        picture-uri-dark = "file://${wp}/share/wallpapers/plain.png";
        picture-options = osConfig.my.wallpaper.mode;
      };
      "org/gnome/desktop/screensaver" = {
        picture-uri = "file://${wp}/share/wallpapers/plain.png";
        picture-options = osConfig.my.wallpaper.mode;
      };
    };
  };
}
