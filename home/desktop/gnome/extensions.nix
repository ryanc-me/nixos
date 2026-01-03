{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:

{
  config =
    lib.mkIf (osConfig.mine ? desktop-gnome && osConfig.mine.desktop-gnome.gnome-extensions.enable)
      {
        dconf.settings."org/gnome/shell".enabled-extensions = map (
          pkg: pkgs.gnomeExtensions.${pkg}.extensionUuid
        ) osConfig.mine.desktop-gnome.gnome-extensions.extensions;
      };
}
