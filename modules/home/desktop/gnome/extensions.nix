{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
let
  extensions = osConfig.mine.nixos.desktop.gnome.extensions;
in
{
  config = lib.mkIf (osConfig.mine.nixos.desktop.gnome.enable) {
    dconf.settings."org/gnome/shell".enabled-extensions = map (
      pkg: pkgs.gnomeExtensions.${pkg}.extensionUuid
    ) extensions;
  };
}
