{ lib, config, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.mine.system.networking.hostname;
in
{
  options.mine.system.networking.hostname = {
    enable = mkEnableOption "Enable Network hostname";
    hostname = mkOption {
      type = lib.types.str;
      description = "Set the system hostname";
    };
  };

  config = mkIf cfg.enable {
    networking = {
      hostName = cfg.hostname;
    };
  };
}
