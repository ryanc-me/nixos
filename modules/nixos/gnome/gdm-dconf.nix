{
  config,
  pkgs,
  lib,
  ...
}:

{
  # GDM dconf stuff
  programs.dconf.profiles.gdm.databases = [
    {
      settings."org/gnome/mutter" = {
        experimental-features = [ "scale-monitor-framebuffer" ];
      };
      settings."org/gnome/desktop/interface" = {
        cursor-theme = "Capitaine Cursors";
        cursor-size = lib.gvariant.mkInt32 24;
      };
    }
  ];
}
