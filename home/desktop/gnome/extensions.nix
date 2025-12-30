{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
let
  gnome-ext = osConfig.mine.desktop-gnome.gnome-extensions;
in
{
  config = lib.mkIf (gnome-ext.enable) {
    dconf.settings."org/gnome/shell".enabled-extensions = map (
      pkg: pkgs.gnomeExtensions.${pkg}.extensionUuid
    ) gnome-ext.extensions;
  };
}
