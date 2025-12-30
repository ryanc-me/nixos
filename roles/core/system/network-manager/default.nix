{ lib, config, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.core.system.network-manager;
in
{
  options.mine.core.system.network-manager = {
    enable = mkEnableOption "Enable NetworkManager service";
  };

  config = mkIf cfg.enable {
    networking = {
      networkmanager.enable = true;
    };
  };
}
