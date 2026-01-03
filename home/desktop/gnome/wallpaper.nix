{
  lib,
  config,
  osConfig,
  ...
}:
let
  hasDesktop = osConfig.mine ? desktop-gnome && osConfig.mine.desktop-gnome ? gnome;

  gnome = if hasDesktop then osConfig.mine.desktop-gnome.gnome else { enable = false; };
  wallpaper = if hasDesktop then osConfig.mine.desktop.system.wallpaper else { enable = false; };
  wp = if hasDesktop then wallpaper.processed.plain."${wallpaper.mode}" else "";
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
