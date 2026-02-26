{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop-niri.system.noctalia;
in
{
  options.mine.desktop-niri.system.noctalia = {
    enable = mkEnableOption "noctalia support";
  };

  config = mkIf cfg.enable {
    services.noctalia-shell.enable = true;
  };
}
