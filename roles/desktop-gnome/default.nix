{
  lib,
  config,
  ...
}:
{
  options.mine.desktop-gnome.enable = lib.mkEnableOption "'desktop-gnome' role";

  config.mine.desktop-gnome = lib.mkIf config.mine.desktop-gnome.enable {
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
