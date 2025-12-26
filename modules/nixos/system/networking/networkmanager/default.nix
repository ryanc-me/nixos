{ lib, config, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.nixos.system.networking.networkmanager;
in
{
  options.mine.nixos.system.networking.networkmanager = {
    enable = mkEnableOption "Enable NetworkManager service";
  };

  config = mkIf cfg.enable {
    networking = {
      networkmanager.enable = true;
    };
  };
}
