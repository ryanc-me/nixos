# modules/hm/gnome-wallpaper.nix
{ lib, config, osConfig, ... }:
let
  # using this, it works properly:
  # wp = osConfig.my.wallpaper.processedPath;

  # but this does not
  wp = osConfig.my.wallpaper.path;
  enable = osConfig.my.wallpaper.enable;
in
{
  config = lib.mkIf enable {
    # Home Manager dconf (works whether or not you're on GNOME)
    dconf.enable = true;
    dconf.settings = {
      "org/gnome/desktop/background" = {
        picture-uri       = "file://${wp}";
        picture-uri-dark  = "file://${wp}";
        picture-options  = "centered";
      };
      "org/gnome/desktop/screensaver" = {
        picture-uri      = "file://${wp}";
        picture-options  = "centered";
      };
    };
  };
}