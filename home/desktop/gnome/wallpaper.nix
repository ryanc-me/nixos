{
  lib,
  config,
  osConfig,
  ...
}:
let
  gnome = osConfig.mine.desktop-gnome.gnome;
  wallpaper = osConfig.mine.desktop.system.wallpaper;
  wp = wallpaper.processed.plain."${wallpaper.mode}";
in
{
  config = lib.mkIf (wallpaper.enable && gnome.enable) {
    # Home Manager dconf (works whether or not you're on GNOME)
    dconf.enable = true;
    dconf.settings = {
      "org/gnome/desktop/background" = {
        picture-uri = "file://${wp}/share/wallpapers/plain.png";
        picture-uri-dark = "file://${wp}/share/wallpapers/plain.png";
        picture-options = wallpaper.mode;
      };
      "org/gnome/desktop/screensaver" = {
        picture-uri = "file://${wp}/share/wallpapers/plain.png";
        picture-options = wallpaper.mode;
      };
    };
  };
}
