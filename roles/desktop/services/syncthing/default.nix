{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.mine.desktop.services.syncthing;
in
{
  # https://wiki.nixos.org/wiki/Syncthing
  options.mine.desktop.services.syncthing = {
    enable = mkEnableOption "Syncthing";
  };

  config = mkIf cfg.enable {
    # note, we specify syncthing on the home-manager side, this file is only for
    # the enable/disable option
  };
}
