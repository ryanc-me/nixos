{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.system.firewall;
in
{
  options.mine.desktop.system.firewall = {
    enable = mkEnableOption "Firewall (Desktop)";
  };

  # TODO: can we define the ports in modules/home, then aggregate them here?
  config = mkIf cfg.enable {
    networking.firewall = {
      enable = true;
    };
  };
}
