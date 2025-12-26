{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.mine.nixos.services.syncthing;
in
{
  # https://wiki.nixos.org/wiki/Syncthing
  options.mine.nixos.services.syncthing = {
    enable = mkEnableOption "Enable syncthing";
  };

  config = mkIf cfg.enable {
    # note, we specify syncthing on the home-manager side, this file is only for
    # the enable/disable option
  };
}
