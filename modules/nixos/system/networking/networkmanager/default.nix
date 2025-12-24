{ lib, config, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.system.networking.networkmanager;
in
{
  options.mine.system.networking.networkmanager = {
    enable = mkEnableOption "Enable NetworkManager service";
  };

  config = mkIf cfg.enable {
    networking = {
      networkmanager.enable = true;
    };
  };
}
