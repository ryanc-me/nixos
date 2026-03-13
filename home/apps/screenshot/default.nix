{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:

let
  inherit (lib) mkEnableOption;
  cfg = config.mine.home.apps.screenshot;
in
{
  # note that gnome/niri/etc implement the actual logic here - this module is
  # just an enable/disable flag
  options.mine.home.apps.screenshot = {
    enable = mkEnableOption "screenshot (custom script)";
  };
}
